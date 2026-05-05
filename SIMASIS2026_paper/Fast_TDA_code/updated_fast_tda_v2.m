% fast_tda demo
% Authors: Charlton Rolle and Jason D. Bakos
% Modified to:
% 1) save every fitted ellipse window
% 2) generate the video as before
% 3) open an interactive review figure with a slider so you can move back
%    and forth through the saved windows after the simulation finishes

clear; clc;

%% Read data
data = readtable('Temp_21_output_time.csv');
time = data.Time_s;
output = data.Output;

fprintf('Data loaded: %d rows\n', length(time));

writematrix(output, 'hls_test_input.csv');   % one column, one sample per line
fprintf('Exported %d raw samples to hls_test_input.csv for HLS testbench\n', length(output));

%% Basic checks
if length(time) < 2
    error('Not enough time samples.');
end

dt = time(2) - time(1);

%% Plot the spectrum
Fs = 1 / dt;
N = length(output);
Y = fft(output);
Y_magnitude = abs(Y / N);

if mod(N, 2) == 0
    f = (0:N/2) * (Fs / N);
    Y_magnitude = Y_magnitude(1:N/2+1);
    Y_magnitude(2:end-1) = 2 * Y_magnitude(2:end-1);
else
    f = (0:(N-1)/2) * (Fs / N);
    Y_magnitude = Y_magnitude(1:(N+1)/2);
    Y_magnitude(2:end) = 2 * Y_magnitude(2:end);
end

figure('Name', 'Spectrum');
plot(f, Y_magnitude, 'LineWidth', 1.5);
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Single-Sided Amplitude Spectrum of Output Signal');
grid on;

%% Extract peak frequencies
max_mag = max(Y_magnitude);

[peaks, peak_props] = findpeaks(Y_magnitude, ...
    'MinPeakHeight', 0.05 * max_mag, ...
    'MinPeakProminence', 0.1 * max_mag, ...
    'MinPeakDistance', 5);

if isempty(peak_props)
    error('No valid spectral peaks found. Adjust findpeaks thresholds.');
end

peak_freqs = f(peak_props);
Fmin = min(peak_freqs);
Fmax = max(peak_freqs);

fprintf('F_max = %0.2f Hz, F_min = %0.2f Hz\n', Fmax, Fmin);

%% Fast TDA parameters
time_delay = 0.25 / Fmax;
time_delay_in_samples = round(time_delay / dt);

window_duration = 1 / Fmin;
num_points_per_window = round(window_duration / dt);

step_size = 50;

% Use a safe last valid starting index
max_start_idx = length(output) - num_points_per_window - time_delay_in_samples + 1;
if max_start_idx < 1
    error('Signal is too short for the chosen window and delay.');
end

win_starts = 1:step_size:max_start_idx;
num_saved_windows = numel(win_starts);

fprintf('Number of saved windows: %d\n', num_saved_windows);

%% Delete existing video file
if exist('myVideo.mp4', 'file')
    delete('myVideo.mp4');
end

%% Data range for acceleration plot
min_accel = min(output, [], 'all');
max_accel = max(output, [], 'all');

%% Create invisible figure for video generation
fig = figure('Visible', 'off', 'Renderer', 'opengl', 'Position', [100 100 1200 900]);

% --- Subplots ---
ax1 = subplot(4,1,1, 'Parent', fig);
plot(ax1, time, output, 'r-', 'LineWidth', 2);
hold(ax1, 'on');
grid(ax1, 'on');
xlabel(ax1, 'time');
ylabel(ax1, 'acceleration');
xlim(ax1, [min(time) max(time)]);

ax2 = subplot(4,1,2, 'Parent', fig);
ax3 = subplot(4,1,3, 'Parent', fig);
ax4 = subplot(4,1,4, 'Parent', fig);

% keep handles for parameter plots
line_handles_conic = gobjects(5,1);
for j = 1:5
    line_handles_conic(j) = plot(ax3, NaN, NaN, 'LineWidth', 1);
    hold(ax3, 'on');
end
legend(ax3, {"a", "b", "c", "d", "e"}, 'Location', 'northeast');
xlabel(ax3, 'time');
xlim(ax3, [min(time) max(time)]);
grid(ax3, 'on');

line_handles_parametric = gobjects(5,1);
for j = 1:5
    line_handles_parametric(j) = plot(ax4, NaN, NaN, 'LineWidth', 1);
    hold(ax4, 'on');
end
legend(ax4, {"center_x", "center_y", "semi-major", "semi-minor", "angle"}, 'Location', 'northeast');
xlabel(ax4, 'time');
xlim(ax4, [min(time) max(time)]);
grid(ax4, 'on');

%% Prepare video
video = VideoWriter('myVideo.mp4', 'MPEG-4');
video.FrameRate = 10;
open(video);

%% Storage for results
ellipse_params = nan(6, num_saved_windows);
ellipse_params_parametric = nan(5, num_saved_windows);
P_store = cell(num_saved_windows, 1);
window_start_time = nan(num_saved_windows, 1);

%% Optional: generate golden coefficients for HLS comparison
golden_coeffs = nan(6, num_saved_windows);

fprintf('Generating golden coefficients...\n');
for k = 1:num_saved_windows
    i = win_starts(k);

    temp_delay = 1;    % must match HLS
    temp_win   = 100;  % must match WINDOW_SIZE in HLS
    end_idx    = i + temp_win - 1;

    if end_idx > length(output)
        break;
    end

    Pgold = [output(i : end_idx - temp_delay), ...
             output(i + temp_delay : end_idx)];

    golden_coeffs(:,k) = fit_ellipse_hls_golden(Pgold(:,1), Pgold(:,2));
end

writematrix(golden_coeffs', 'hls_golden_coeffs.csv');
fprintf('Exported golden coefficients to hls_golden_coeffs.csv\n');

%% Main sliding-window loop
rect_handle = [];

for k = 1:num_saved_windows
    i = win_starts(k);

    start_idx = i;
    end_idx = i + num_points_per_window - 1;

    if end_idx + time_delay_in_samples > length(output)
        break;
    end

    % point cloud for this window
    P = [output(start_idx : end_idx - time_delay_in_samples), ...
         output(start_idx + time_delay_in_samples : end_idx)];

    P_store{k} = P;
    window_start_time(k) = time(start_idx);

    % fit the ellipse
    ellipse_params(:,k) = fit_ellipse_hls_golden(P(:,1), P(:,2));

    if all(ellipse_params(:,k) == 0) || any(isnan(ellipse_params(:,k)))
        warning('Skipping invalid ellipse at k=%d', k);
        continue;
    end

    % update sliding window rectangle on the first subplot
    if ~isempty(rect_handle) && isgraphics(rect_handle)
        delete(rect_handle);
    end

    x_left = time(start_idx);
    y_bottom = min_accel;
    width = window_duration;
    height = max_accel - min_accel;

    x_rect = [x_left x_left+width x_left+width x_left];
    y_rect = [y_bottom y_bottom y_bottom+height y_bottom+height];

    rect_handle = patch(ax1, x_rect, y_rect, [0.5 0.7 1], ...
        'FaceAlpha', 0.3, 'EdgeColor', 'b', 'LineWidth', 1);

    % plot the point cloud and fitted ellipse
    cla(ax2);
    plot_ellipse(P, ellipse_params(:,k), ax2);

    % update conic parameter plots
    t_values = window_start_time(1:k);
    for j = 1:5
        set(line_handles_conic(j), 'XData', t_values, ...
            'YData', ellipse_params(j, 1:k));
    end
    xlim(ax3, [min(time) max(time)]);

    % convert to parametric parameters
    try
        ellipse_params_parametric(:,k) = conic_to_parametric(ellipse_params(:,k));

        if any(isnan(ellipse_params_parametric(:,k))) || ...
           any(isinf(ellipse_params_parametric(:,k))) || ...
           any(imag(ellipse_params_parametric(:,k)) ~= 0)
            ellipse_params_parametric(:,k) = zeros(5,1);
        end
    catch
        ellipse_params_parametric(:,k) = zeros(5,1);
        warning('conic_to_parametric failed at k=%d', k);
    end

    % update parametric plots
    for j = 1:5
        set(line_handles_parametric(j), 'XData', t_values, ...
            'YData', real(ellipse_params_parametric(j, 1:k)));
    end
    xlim(ax4, [min(time) max(time)]);

    % update video
    drawnow;
    frame = getframe(fig);
    writeVideo(video, frame);
end

close(video);
close(fig);

fprintf('Video saved to myVideo.mp4\n');

%% Interactive review mode
review_ellipse_windows(time, output, win_starts, window_duration, ...
    min_accel, max_accel, P_store, ellipse_params, ellipse_params_parametric);

%% ========================= LOCAL FUNCTIONS =========================

function review_ellipse_windows(time, output, win_starts, window_duration, ...
    min_accel, max_accel, P_store, ellipse_params, ellipse_params_parametric)

    nWin = numel(win_starts);

    fig = figure('Name', 'Ellipse Review', 'NumberTitle', 'off', ...
                 'Position', [100 100 1200 900], 'Color', 'w');

    ax1 = subplot(4,1,1, 'Parent', fig);
    plot(ax1, time, output, 'r-', 'LineWidth', 2);
    hold(ax1, 'on');
    grid(ax1, 'on');
    xlabel(ax1, 'time');
    ylabel(ax1, 'acceleration');
    xlim(ax1, [min(time) max(time)]);

    ax2 = subplot(4,1,2, 'Parent', fig);
    ax3 = subplot(4,1,3, 'Parent', fig);
    ax4 = subplot(4,1,4, 'Parent', fig);

    conicLines = gobjects(5,1);
    paramLines = gobjects(5,1);

    for j = 1:5
        conicLines(j) = plot(ax3, NaN, NaN, 'LineWidth', 1);
        hold(ax3, 'on');
        paramLines(j) = plot(ax4, NaN, NaN, 'LineWidth', 1);
        hold(ax4, 'on');
    end

    legend(ax3, {"a", "b", "c", "d", "e"}, 'Location', 'northeast');
    xlabel(ax3, 'time');
    xlim(ax3, [min(time) max(time)]);
    grid(ax3, 'on');

    legend(ax4, {"center_x", "center_y", "semi-major", "semi-minor", "angle"}, 'Location', 'northeast');
    xlabel(ax4, 'time');
    xlim(ax4, [min(time) max(time)]);
    grid(ax4, 'on');

    % Slider
    sld = uicontrol(fig, 'Style', 'slider', 'Units', 'normalized', ...
        'Position', [0.15 0.01 0.70 0.03], ...
        'Min', 1, 'Max', nWin, 'Value', 1);

    if nWin > 1
        stepSmall = 1 / (nWin - 1);
        stepLarge = min(10 / (nWin - 1), 1);
    else
        stepSmall = 1;
        stepLarge = 1;
    end

    sld.SliderStep = [stepSmall stepLarge];

    txt = uicontrol(fig, 'Style', 'text', 'Units', 'normalized', ...
        'Position', [0.01 0.01 0.12 0.03], ...
        'String', 'Window 1', ...
        'BackgroundColor', get(fig, 'Color'));

    rect_handle = [];

    sld.Callback = @updatePlots;
    updatePlots();

    function updatePlots(~, ~)
        k = round(get(sld, 'Value'));
        k = max(1, min(nWin, k));
        set(sld, 'Value', k);

        idx = win_starts(k);
        set(txt, 'String', sprintf('Window %d / %d', k, nWin));

        % Update blue window on top plot
        if ~isempty(rect_handle) && isgraphics(rect_handle)
            delete(rect_handle);
        end

        x_left = time(idx);
        y_bottom = min_accel;
        width = window_duration;
        height = max_accel - min_accel;

        x_rect = [x_left x_left+width x_left+width x_left];
        y_rect = [y_bottom y_bottom y_bottom+height y_bottom+height];

        rect_handle = patch(ax1, x_rect, y_rect, [0.5 0.7 1], ...
            'FaceAlpha', 0.3, 'EdgeColor', 'b', 'LineWidth', 1);

        % Update ellipse plot
        cla(ax2);
        if ~isempty(P_store{k})
            if all(~isnan(ellipse_params(:,k))) && any(ellipse_params(:,k) ~= 0)
                plot_ellipse(P_store{k}, ellipse_params(:,k), ax2);
            else
                plot(ax2, P_store{k}(:,1), P_store{k}(:,2), 'b.');
                axis(ax2, 'equal');
                grid(ax2, 'on');
            end
        end

        % Update conic parameter plots
        t_values = time(win_starts(1:k));
        for j = 1:5
            set(conicLines(j), 'XData', t_values, ...
                'YData', ellipse_params(j, 1:k));
        end
        xlim(ax3, [min(time) max(time)]);

        % Update parametric parameter plots
        for j = 1:5
            set(paramLines(j), 'XData', t_values, ...
                'YData', real(ellipse_params_parametric(j, 1:k)));
        end
        xlim(ax4, [min(time) max(time)]);

        drawnow;
    end
end

function p = conic_to_parametric(a)
    % Conic coefficients: [A B C D E F]
    A = a(1); B = a(2); C = a(3); D = a(4); E = a(5); F = a(6);

    % Center
    denom = B^2 - 4*A*C;
    if abs(denom) < 1e-12
        p = zeros(5,1);
        return;
    end

    cx = (2*C*D - B*E) / denom;
    cy = (2*A*E - B*D) / denom;

    % Rotation angle
    if abs(B) < 1e-12
        theta = 0;
    else
        theta = 0.5 * atan2(B, A - C);
    end

    % Semi-axes (approximate)
    T = A + C;
    R = sqrt((A - C)^2 + B^2);
    lambda1 = (T + R) / 2;
    lambda2 = (T - R) / 2;

    if lambda1 <= 0 || lambda2 <= 0
        p = zeros(5,1);
        return;
    end

    semi_major = sqrt(1 / lambda2);
    semi_minor = sqrt(1 / lambda1);

    p = [cx; cy; semi_major; semi_minor; theta];
end

function plot_ellipse(P, params, ax)
    % params = [a b c d e f]
    a = params(1); b = params(2); c = params(3);
    d = params(4); e = params(5); f = params(6);

    denom = b^2 - 4*a*c;
    if abs(denom) < 1e-12
        warning('Degenerate ellipse');
        plot(ax, P(:,1), P(:,2), 'b.');
        axis(ax, 'equal');
        grid(ax, 'on');
        return;
    end

    x0 = (2*c*d - b*e) / denom;
    y0 = (2*a*e - b*d) / denom;

    % Rotation angle
    if abs(b) < 1e-12
        if a < c
            theta = 0;
        else
            theta = pi/2;
        end
    else
        theta = 0.5 * atan2(b, a - c);
    end

    % Semi-axes
    up = 2 * (a*e^2 + c*d^2 + f*b^2 - 2*b*d*e - 4*a*c*f);

    % Protect against division by zero
    if abs(a-c) < 1e-12
        temp = 0;
    else
        temp = sqrt(1 + (b/(a-c))^2);
    end

    down1 = (b^2 - 4*a*c) * ( (c - a) * temp - (c + a) );
    down2 = (b^2 - 4*a*c) * ( -(c - a) * temp - (c + a) );

    if up <= 0 || down1 <= 0 || down2 <= 0 || isnan(up) || isnan(down1) || isnan(down2)
        warning('Cannot compute ellipse axes');
        plot(ax, P(:,1), P(:,2), 'b.');
        axis(ax, 'equal');
        grid(ax, 'on');
        return;
    end

    rx = sqrt(up / down1);
    ry = sqrt(up / down2);

    t = linspace(0, 2*pi, 200);
    x = rx * cos(t);
    y = ry * sin(t);

    x_rot = x*cos(theta) - y*sin(theta) + x0;
    y_rot = x*sin(theta) + y*cos(theta) + y0;

    plot(ax, P(:,1), P(:,2), 'b.');
    hold(ax, 'on');
    plot(ax, x_rot, y_rot, 'r-', 'LineWidth', 1.5);
    axis(ax, 'equal');
    grid(ax, 'on');
    hold(ax, 'off');
end

function a = fit_ellipse_hls_golden(x, y)
    % GOLDEN REFERENCE — exact replica of the HLS scatter_matrix kernel

    if length(x) < 5
        error('At least 5 points required');
    end

    % Design matrix: [x^2, x*y, y^2, x, y, 1]
    D = [x.^2, x.*y, y.^2, x, y, ones(size(x))];
    S = D' * D;

    % Block extraction
    Spp = S(1:3,1:3);
    Spq = S(1:3,4:6);
    Sqq = S(4:6,4:6);

    % Analytic inverse of Sqq with regularization
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

    % Schur reduction
    temp = Spq * inv_qq;
    S_reduced = Spp - temp * Spq';

    % Hard-coded invD
    invD = [ 0.0  0.5  0.0 ;
             0.5  0.0  0.0 ;
             0.0  0.0 -1.0 ];

    % Form A
    A = invD * S_reduced;

    % Eigen-decomposition
    [V, D_eig] = eig(A);
    lambdas = diag(D_eig);

    % Choose eigenvector with smallest absolute eigenvalue
    [~, idx] = min(abs(lambdas));
    ap = V(:, idx);

    % Recover linear part
    aq = -inv_qq * (Spq' * ap);

    % Full coefficient vector
    a = [ap; aq];

    % Normalize
    C = zeros(6,6);
    C(1,3) = 2;  C(3,1) = 2;
    C(2,2) = -1;

    scale = sqrt(abs(a' * C * a));
    if scale > 1e-12
        a = a / scale;
    end
end