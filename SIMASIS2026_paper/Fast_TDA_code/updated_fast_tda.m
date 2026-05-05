% fast_tda demo
% Authors: Charlton Rolle and Jason D. Bakos
% takes a dataset, in the form crafted by Mohsen Gol Zardian
% finds the time delay and window using the method prescribed by Arman Razmarashooli
% fits an ellipse over each window using the conic Fitzgibbon method
% converts each set of conic parameters to "parametric parameters", i.e.
% converts quadratic coefficients to ellipse center, size, and angle
% plots all data and saves to a video file

% read data
data = readtable('Temp_21_output_time.csv');
time = data.Time_s;
output = data.Output;
%if ismember('Var1', data.Properties.VariableNames)
    %time = data.Var1;
    %output = data.Var2;
%else
    %time = data.Time;
    %output = data.Var2;
%end
fprintf('Data loaded: %d rows\n', length(time));

writematrix(output, 'hls_test_input.csv');   % one column, one sample per line
fprintf('Exported %d raw samples to hls_test_input.csv for HLS testbench\n', length(output));

% find the sample rate
dt = time(2) - time(1);

% plot the spectrum
Fs = 1 / dt; % Sampling frequency (Hz)
N = length(output); % Number of samples
Y = fft(output); % Compute FFT
Y_magnitude = abs(Y/N); % Normalize magnitude
if mod(N, 2) == 0
    % Even number of samples
    f = (0:N/2)*(Fs/N); % Frequency vector for single-sided spectrum
    Y_magnitude = Y_magnitude(1:N/2+1); % Take single-sided spectrum
    Y_magnitude(2:end-1) = 2*Y_magnitude(2:end-1); % Double amplitudes (except DC and Nyquist)
else
    % Odd number of samples
    f = (0:(N-1)/2)*(Fs/N); % Frequency vector for single-sided spectrum
    Y_magnitude = Y_magnitude(1:(N+1)/2); % Take single-sided spectrum
    Y_magnitude(2:end) = 2*Y_magnitude(2:end); % Double amplitudes (except DC)
end

figure;
plot(f, Y_magnitude);
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title('Single-Sided Amplitude Spectrum of Output Signal');
grid on;

% Extract peak frequencies
max_mag = max(Y_magnitude);
[peaks, peak_props] = findpeaks(Y_magnitude, ...
    'MinPeakHeight', 0.05 * max_mag, ...
    'MinPeakProminence', 0.1 * max_mag, ...
    'MinPeakDistance', 5);
peak_freqs = f(peak_props);
Fmin = min(peak_freqs);
Fmax = max(peak_freqs);
fprintf('F_max = %0.2f Hz, F_min = %0.2f Hz\n', Fmax, Fmin);
hold off;

% set up Fast TDA parameters
time_delay = 0.25 / Fmax;
time_delay_in_samples = round(time_delay / dt); % from Arman
window_duration = 1 / Fmin; % from Arman
num_points_per_window = round(window_duration / dt); 
num_windows = length(time) - num_points_per_window;
step_size = 50;

% delete the existing video file
if exist('myVideo.mp4', 'file')
    delete('myVideo.mp4');
end

% get ranges for acceleration plot
min_accel = min(output, [], 'all');
max_accel = max(output, [], 'all');

% Create an invisible figure with larger size for better visibility in video
fig = figure('Visible', 'off', 'Renderer', 'opengl', 'Position', [100 100 1200 900]);

% Create subplots (axes) once outside the loop
ax1 = subplot(4,1,1);
plot(ax1, time, output, 'r-', 'LineWidth', 2);
hold(ax1, 'on');
grid(ax1, 'on');
xlabel(ax1, 'time');
ylabel(ax1, 'acceleration');
xlim(ax1, [min(time) max(time)]);
ax2 = subplot(4,1,2);
ax3 = subplot(4,1,3);
ax4 = subplot(4,1,4);

% set up the conic arguments plot
line_handles_conic = gobjects(5,1);
for j = 1:5
    line_handles_conic(j) = plot(ax3, NaN, NaN, 'LineWidth', 1);
    hold(ax3, 'on');
end
legend(ax3, {"a", "b", "c", "d", "e"});
xlabel(ax3, "time");
xlim(ax3, [min(time) max(time)]);

% set up the parametric parameters plot
line_handles_parametric = gobjects(5,1);
for j = 1:5
    line_handles_parametric(j) = plot(ax4, NaN, NaN, 'LineWidth', 1);
    hold(ax4, 'on');
end
legend(ax4, {"center_x", "center_y", "semi-major", "semi-minor", "angle"});
xlabel(ax4, "time");
xlim(ax4, [min(time) max(time)]);

% set up video with lower frame rate to slow down playback
video = VideoWriter('myVideo.mp4', 'MPEG-4');
video.FrameRate = 10;
open(video);

% allocate space for ellipse conic parameters
ellipse_params = zeros(6, num_windows);

% allocate space for parametric parameters
ellipse_params_parametric = zeros(5, num_windows);

% used for the sliding window display
rect_handle = [];

golden_coeffs = zeros(6, num_windows);
for i = 1:step_size:num_windows
    start_idx = i;
    temp_delay = 1;          % must match HLS
    temp_win   = 100;        % must match WINDOW_SIZE in HLS
    end_idx    = start_idx + temp_win - 1;
    
    if end_idx > length(output)
        break;
    end
    
    P = [output(start_idx : end_idx-temp_delay), ...
         output(start_idx+temp_delay : end_idx)];
    
    golden_coeffs(:,i) = fit_ellipse_hls_golden(P(:,1), P(:,2));
end

writematrix(golden_coeffs', 'hls_golden_coeffs.csv');
fprintf('Exported golden coefficients to hls_golden_coeffs.csv\n');

writematrix(golden_coeffs', 'hls_golden_coeffs.csv');  % rows = windows, columns = [a b c d e f]
fprintf('Exported golden coefficients to hls_golden_coeffs.csv\n');
for i = 1:step_size:num_windows
    % build pointcloud
    P = [output(i:i+num_points_per_window-1-time_delay_in_samples), ...
         output(i+time_delay_in_samples:i+num_points_per_window-1)];

    % fit the ellipse
    ellipse_params(:,i) = fit_ellipse_hls_golden(P(:,1), P(:,2));

    % skip invalid ellipse
    if all(ellipse_params(:,i) == 0)
        warning('Skipping invalid ellipse at i=%d', i);
        continue;
    end

    % move the sliding window rectangle
    if ~isempty(rect_handle)
        delete(rect_handle);
    end
    x_left = i * dt;
    y_bottom = min_accel;
    width = window_duration;
    height = max_accel - min_accel;
    x_rect = [x_left x_left+width x_left+width x_left];
    y_rect = [y_bottom y_bottom y_bottom+height y_bottom+height];
    rect_handle = patch(ax1, x_rect, y_rect, [0.5 0.7 1], 'FaceAlpha', 0.3, ...
                        'EdgeColor', 'b', 'LineWidth', 1);

    % plot the pointcloud and fitted ellipse
    cla(ax2);
    plot_ellipse(P, ellipse_params(:,i), ax2);

    % plot the conic parameters
    t_values = (1:step_size:i) * dt;
    for j = 1:5 % omit 'f'
        set(line_handles_conic(j), 'XData', t_values, ...
            'YData', ellipse_params(j, 1:step_size:i));
    end
    xlim(ax3, [min(time) max(time)]);

    % compute parametric ellipse parameters safely
    try
        ellipse_params_parametric(:,i) = conic_to_parametric(ellipse_params(:,i));
        % check for invalid values
        if any(isnan(ellipse_params_parametric(:,i))) || ...
           any(isinf(ellipse_params_parametric(:,i))) || ...
           any(imag(ellipse_params_parametric(:,i)) ~= 0)
            ellipse_params_parametric(:,i) = zeros(5,1);
            % optionally mark invalid window on plot
            x_rect = [x_left x_left+width x_left+width x_left];
            y_rect = [min(ellipse_params_parametric,[],"all"), ...
                      min(ellipse_params_parametric,[],"all"), ...
                      max(ellipse_params_parametric,[],"all"), ...
                      max(ellipse_params_parametric,[],"all")];
            patch(ax4, x_rect, y_rect, [0.5 0.7 1], 'EdgeColor', 'r', 'LineWidth', 1);
        end
    catch
        % fallback if conic_to_parametric fails
        ellipse_params_parametric(:,i) = zeros(5,1);
        warning('conic_to_parametric failed at i=%d', i);
    end

    % plot the parametric parameters
    for j = 1:5
        set(line_handles_parametric(j), 'XData', t_values, ...
            'YData', real(ellipse_params_parametric(j, 1:step_size:i)));
    end
    xlim(ax4, [min(time) max(time)]);

    % update video
    drawnow;
    frame = getframe(fig);
    writeVideo(video, frame);
end

close(video);
%close(fig);

function p = conic_to_parametric(a)
    % Very basic conic → parametric conversion (center, axes, angle)
    % You can replace this with your own version if you have a better one
    A = a(1); B = a(2); C = a(3); D = a(4); E = a(5); F = a(6);
    
    % Center
    denom = B^2 - 4*A*C;
    if abs(denom) < 1e-12
        p = zeros(5,1); return;
    end
    cx = (2*C*D - B*E) / denom;
    cy = (2*A*E - B*D) / denom;
    
    % Angle
    if abs(B) < 1e-12
        theta = 0;
    else
        theta = 0.5 * atan2(B, A - C);
    end
    
    % Semi-axes (approximate)
    T = A + C;
    R = sqrt((A - C)^2 + B^2);
    lambda1 = (T + R)/2;
    lambda2 = (T - R)/2;
    if lambda1 <= 0 || lambda2 <= 0
        p = zeros(5,1); return;
    end
    semi_major = sqrt(1/lambda2);
    semi_minor = sqrt(1/lambda1);
    
    p = [cx; cy; semi_major; semi_minor; theta];
end

function plot_ellipse(P, params, ax)
    % params = [a b c d e f] conic coefficients
    % P = Nx2 data points
    
    a = params(1); b = params(2); c = params(3); d = params(4); e = params(5); f = params(6);

    % Center of the ellipse
    denom = b^2 - 4*a*c;
    if denom == 0
        warning('Degenerate ellipse');
        return;
    end
    x0 = (2*c*d - b*e) / denom;
    y0 = (2*a*e - b*d) / denom;

    % Rotation angle
    if b == 0
        if a < c
            theta = 0;
        else
            theta = pi/2;
        end
    else
        theta = 0.5 * atan(b/(a - c));
    end

    % Semi-axes (approximate, from conic to parametric)
    up = 2*(a*e^2 + c*d^2 + f*b^2 - 2*b*d*e - 4*a*c*f);
    down1 = (b^2 - 4*a*c) * ( (c - a)*sqrt(1 + (b/(a-c))^2) - (c + a) );
    down2 = (b^2 - 4*a*c) * ( -(c - a)*sqrt(1 + (b/(a-c))^2) - (c + a) );
    if up <= 0 || down1 <= 0 || down2 <= 0
        warning('Cannot compute axes');
        return;
    end
    rx = sqrt(up / down1);
    ry = sqrt(up / down2);

    % Parametric ellipse
    t = linspace(0, 2*pi, 200);
    x = rx*cos(t);
    y = ry*sin(t);

    % Rotate and translate
    x_rot = x*cos(theta) - y*sin(theta) + x0;
    y_rot = x*sin(theta) + y*cos(theta) + y0;

    % Plot
    axes(ax);
    plot(ax, P(:,1), P(:,2), 'b.'); % original points
    hold(ax, 'on');
    plot(ax, x_rot, y_rot, 'r-', 'LineWidth', 1.5); % fitted ellipse
    axis(ax, 'equal');
    hold(ax, 'off');
end

function a = fit_ellipse_hls_golden(x, y)
    % GOLDEN REFERENCE — exact replica of your Vitis HLS scatter_matrix kernel
    % Use this to generate the "golden" coefficients to compare against your testbench
    
    if length(x) < 5
        error('At least 5 points required');
    end
    
    % Design matrix — same ordering as your v[] in HLS: [x², xy, y², x, y, 1]
    D = [x.^2, x.*y, y.^2, x, y, ones(size(x))];
    S = D' * D;                     % full scatter matrix (S_out in your kernel)
    
    % === Block extraction (exact match to your HLS code) ===
    Spp = S(1:3,1:3);               % [a b c] block
    Spq = S(1:3,4:6);
    Sqq = S(4:6,4:6);
    
    % === Analytic inverse of Sqq with regularization (exact copy of your code) ===
    REG_EPSILON = 1e-6;
    a_qq = Sqq(1,1) + REG_EPSILON;  b = Sqq(1,2);  c = Sqq(1,3);
    e     = Sqq(2,2) + REG_EPSILON;  f = Sqq(2,3);
    g     = Sqq(3,3) + REG_EPSILON;
    
    det = a_qq*(e*g - f*f) - b*(b*g - f*c) + c*(b*f - e*c);
    inv_det = 1.0 / det;
    
    inv_qq = zeros(3);
    inv_qq(1,1) = (e*g - f*f) * inv_det;
    inv_qq(1,2) = -(b*g - c*f) * inv_det;
    inv_qq(1,3) = (b*f - c*e) * inv_det;
    inv_qq(2,1) = inv_qq(1,2);
    inv_qq(2,2) = (a_qq*g - c*c) * inv_det;
    inv_qq(2,3) = -(a_qq*f - c*b) * inv_det;
    inv_qq(3,1) = inv_qq(1,3);
    inv_qq(3,2) = inv_qq(2,3);
    inv_qq(3,3) = (a_qq*e - b*b) * inv_det;
    
    % === Schur reduction → S_reduced (your "S_tilde") ===
    temp = Spq * inv_qq;
    S_reduced = Spp - temp * Spq';   % this is exactly what you store in S_tilde[9]
    
    % === Hard-coded invD from your kernel ===
    invD = [ 0.0  0.5  0.0 ;
             0.5  0.0  0.0 ;
             0.0  0.0 -1.0 ];
    
    % === Form A (exactly as in your HLS) ===
    A = invD * S_reduced;
    
    % === Eigen-decomposition (golden uses eig; your HLS uses xf::solver::svdTop) ===
    [V, D_eig] = eig(A);             % V columns = eigenvectors, diag(D_eig) = eigenvalues
    lambdas = diag(D_eig);
    
    % Pick the best eigenvector (smallest absolute eigenvalue — works reliably here)
    [~, idx] = min(abs(lambdas));
    ap = V(:, idx);                  % [a; b; c]
    
    % Recover linear part (exactly as you would do after SVD in testbench)
    aq = -inv_qq * (Spq' * ap);      % [d; e; f]
    
    % Full coefficient vector [a b c d e f]
    a = [ap; aq];
    
    % Normalize to the original constraint 4ac - b² = 1 (same as Fitzgibbon)
    C = zeros(6,6);
    C(1,3) = 2;  C(3,1) = 2;
    C(2,2) = -1;
    scale = sqrt(abs(a' * C * a));
    if scale > 1e-12
        a = a / scale;
    end
end

%% Jacobi eigen-decomposition (symmetric)
function [lambda, V] = cyclicJacobi(A, eps, maxIter)
% Simple cyclic Jacobi (not optimized) for symmetric A.
    n = size(A,1);
    if size(A,2) ~= n
        error('Input to cyclicJacobi must be square.');
    end
    V = eye(n);
    C = (A + A')/2;
    iter = 0;

    % initial off-diagonal norm
    offDiag = offDiagonalFrobeniusNorm(C);

    while offDiag > eps && iter < maxIter
        for p = 1:n-1
            for q = p+1:n
                if abs(C(p,q)) < eps
                    continue;
                end
                % compute Jacobi rotation
                tau = (C(q,q) - C(p,p)) / (2*C(p,q));
                t = sign(tau) / (abs(tau) + sqrt(1+tau^2));
                c = 1 / sqrt(1 + t^2);
                s = t * c;

                % Apply rotation to C (small update)
                % Update rows/cols p and q efficiently
                Cp = C(:,p);
                Cq = C(:,q);

                % new columns:
                C(:,p) = c*Cp - s*Cq;
                C(:,q) = s*Cp + c*Cq;
                % restore symmetry for rows
                C(p,:) = C(:,p)';
                C(q,:) = C(:,q)';

                % Accumulate rotation
                J = eye(n);
                J(p,p) = c; J(q,q) = c;
                J(p,q) = -s; J(q,p) = s;
                V = V * J;
            end
        end
        offDiag = offDiagonalFrobeniusNorm(C);
        iter = iter + 1;
    end

    if iter >= maxIter
        warning('Jacobi did not converge within %d iterations', maxIter);
    end

    lambda = diag(C);
    % Optionally sort eigenvalues and eigenvectors ascending:
    % [lambda, idx] = sort(lambda, 'ascend'); V = V(:, idx);
end

