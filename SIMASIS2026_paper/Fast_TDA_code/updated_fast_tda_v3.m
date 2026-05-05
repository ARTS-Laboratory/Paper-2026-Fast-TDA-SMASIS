% fast_tda_interactive.m
% Interactive Fast TDA window inspector
%
% Changes:
% 1) Standard MATLAB color order is used consistently for ellipse,
%    conic-parameter, and stacked-trend plots.
% 2) The ellipse panel has a clear title.
% 3) A new 5th plot is added: "Normalised individual trends (stacked)"
%    restricted to the 3 to 4 second interval.
% 4) The Save button exports the current figure as SVG for Inkscape.
%
% ---------------------------------------------------------
% NOTE:
% The code sections related to the 5 plots are:
%   - Signal plot
%   - Ellipse plot
%   - Conic parameters over time
%   - Normalised individual trends (stacked)
%   - Zoomed normalised individual trends (3 to 4 s)
% ---------------------------------------------------------

clear; clc;

% =========================================================
% READ DATA
% =========================================================
data   = readtable('Temp_21_output_time.csv');
time   = data.Time_s;
output = data.Output;
fprintf('Data loaded: %d rows\n', length(time));

% =========================================================
% SAMPLE RATE AND SPECTRUM
% =========================================================
dt  = time(2) - time(1);
Fs  = 1 / dt;
N   = length(output);
Y   = fft(output);
Ym  = abs(Y / N);

if mod(N,2)==0
    f  = (0:N/2)*(Fs/N);
    Ym = Ym(1:N/2+1);
    Ym(2:end-1) = 2*Ym(2:end-1);
else
    f  = (0:(N-1)/2)*(Fs/N);
    Ym = Ym(1:(N+1)/2);
    Ym(2:end) = 2*Ym(2:end);
end

max_mag = max(Ym);
[~, pk] = findpeaks(Ym, ...
    'MinPeakHeight',     0.05*max_mag, ...
    'MinPeakProminence',  0.10*max_mag, ...
    'MinPeakDistance',    5);

if isempty(pk)
    error('No spectral peaks found. Adjust findpeaks thresholds.');
end

peak_freqs = f(pk);
Fmin = min(peak_freqs);
Fmax = max(peak_freqs);
fprintf('F_max = %.2f Hz,  F_min = %.2f Hz\n', Fmax, Fmin);

% =========================================================
% FAST TDA PARAMETERS
% =========================================================
time_delay_samp = round(0.25 / Fmax / dt);
win_pts         = round(1 / Fmin / dt);
win_dur         = win_pts * dt;
num_windows     = length(time) - win_pts + 1;
step_size       = 50;

fprintf('Window size: %d samples (%.4f s)\n', win_pts, win_dur);
fprintf('Time delay:  %d samples\n', time_delay_samp);

% =========================================================
% PRE-COMPUTE ALL ELLIPSES
% =========================================================
fprintf('Pre-computing ellipses...\n');

valid_idx  = [];
all_params  = nan(6, num_windows);

for i = 1:step_size:num_windows
    i_end = i + win_pts - 1 - time_delay_samp;
    i_del = i + time_delay_samp;
    i_del_end = i_del + win_pts - 1 - time_delay_samp;

    if i_end > length(output) || i_del_end > length(output)
        break;
    end

    P = [output(i : i_end), ...
         output(i_del : i_del_end)];

    params = fit_ellipse_hls_golden(P(:,1), P(:,2));

    if all(params == 0) || any(isnan(params))
        continue;
    end

    all_params(:, i) = params;
    valid_idx(end+1) = i; %#ok<AGROW>
end

if isempty(valid_idx)
    error('No valid windows were found.');
end

fprintf('Pre-computation done: %d valid windows.\n', length(valid_idx));

% =========================================================
% BUILD THE INTERACTIVE FIGURE
% =========================================================
min_acc = min(output);
max_acc = max(output);
t_vec   = time(valid_idx);

fig = figure('Name', 'Fast TDA - Interactive Window Inspector', ...
             'Position', [60 20 1400 1080], ...
             'Color', [0.96 0.96 0.96]);

% Standard MATLAB color order
stdColors = [0.0000 0.4470 0.7410;   % blue
             0.8500 0.3250 0.0980;   % orange
             0.9290 0.6940 0.1250;   % yellow
             0.4940 0.1840 0.5560;   % purple
             0.4660 0.6740 0.1880];  % green

% Save SVG button at the top-right
uicontrol(fig, 'Style', 'pushbutton', ...
    'Units', 'normalized', 'Position', [0.88 0.955 0.10 0.03], ...
    'String', 'Save SVG', 'FontSize', 9, ...
    'Callback', @(~,~) cb_save_svg(fig));

% =========================================================
% PLOT 1: FULL SIGNAL WITH SLIDING WINDOW
% =========================================================
ax_sig = axes('Parent', fig, 'Position', [0.06 0.78 0.88 0.16]);
plot(ax_sig, time, output, 'Color', [0.4 0.4 0.4], 'LineWidth', 0.8);
hold(ax_sig, 'on');
win_patch = patch(ax_sig, [0 0 0 0], ...
    [min_acc max_acc max_acc min_acc], ...
    [0.25 0.55 0.95], ...
    'FaceAlpha', 0.25, 'EdgeColor', [0.1 0.3 0.8], 'LineWidth', 1.5);
xlabel(ax_sig, 'Time (s)');
ylabel(ax_sig, 'Acceleration');
title(ax_sig, 'Signal - drag slider below to move window');
xlim(ax_sig, [min(time) max(time)]);
ylim(ax_sig, [min_acc - 0.05*abs(min_acc), max_acc + 0.05*abs(max_acc)]);
grid(ax_sig, 'on');
box(ax_sig, 'on');
hold(ax_sig, 'off');

% =========================================================
% PLOT 2: ELLIPSE AT SELECTED WINDOW
% =========================================================
ax_ell = axes('Parent', fig, 'Position', [0.06 0.47 0.38 0.23]);
title(ax_ell, 'Ellipse at selected window');
grid(ax_ell, 'on');
box(ax_ell, 'on');
axis(ax_ell, 'equal');

% =========================================================
% PLOT 3: CONIC PARAMETERS OVER TIME
% =========================================================
ax_par = axes('Parent', fig, 'Position', [0.54 0.47 0.40 0.23]);
hold(ax_par, 'on');

param_colors = stdColors;
param_names  = {'a', 'b', 'c', 'd', 'e'};
lh = gobjects(5,1);

for j = 1:5
    lh(j) = plot(ax_par, NaN, NaN, ...
        'Color', param_colors(j,:), 'LineWidth', 1.4, ...
        'DisplayName', param_names{j});
end

for j = 1:5
    ydata = all_params(j, valid_idx);
    set(lh(j), 'XData', t_vec, 'YData', ydata);
end

cur_line = xline(ax_par, t_vec(1), '--k', 'LineWidth', 1.5);

xlabel(ax_par, 'Time (s)');
ylabel(ax_par, 'Parameter value');
title(ax_par, 'Conic parameters over time');
legend(ax_par, 'Location', 'best');
grid(ax_par, 'on');
box(ax_par, 'on');
xlim(ax_par, [min(t_vec) max(t_vec)]);
hold(ax_par, 'off');

% =========================================================
% PLOT 4: NORMALISED INDIVIDUAL TRENDS (STACKED)
% =========================================================
ax_stk = axes('Parent', fig, 'Position', [0.54 0.13 0.40 0.24]);
hold(ax_stk, 'on');

for j = 1:5
    v = all_params(j, valid_idx);
    rngv = max(v) - min(v);
    if rngv < 1e-12
        rngv = 1;
    end
    v_n = (v - min(v)) / rngv + (5-j)*1.15;

    plot(ax_stk, t_vec, v_n, 'Color', param_colors(j,:), 'LineWidth', 1.2);
    text(ax_stk, max(t_vec)*1.002, v_n(end), param_names{j}, ...
        'Color', param_colors(j,:), 'FontWeight', 'bold', 'FontSize', 9);
end

cur_line_stk = xline(ax_stk, t_vec(1), '--k', 'LineWidth', 1.5);

xlabel(ax_stk, 'Time (s)');
ylabel(ax_stk, 'Normalised value');
title(ax_stk, 'Normalised individual trends (stacked)');
grid(ax_stk, 'on');
box(ax_stk, 'on');
set(ax_stk, 'YTick', []);
xlim(ax_stk, [min(t_vec) max(t_vec)*1.04]);
hold(ax_stk, 'off');

% =========================================================
% PLOT 5: ZOOMED NORMALISED INDIVIDUAL TRENDS (3 TO 4 s)
% =========================================================
ax_stk_zoom = axes('Parent', fig, 'Position', [0.06 0.13 0.38 0.24]);
hold(ax_stk_zoom, 'on');

mask_zoom = (t_vec >= 3) & (t_vec <= 4);
t_zoom = t_vec(mask_zoom);

if isempty(t_zoom)
    text(ax_stk_zoom, 0.5, 0.5, 'No data in 3 to 4 s range', ...
        'Units', 'normalized', 'HorizontalAlignment', 'center');
    title(ax_stk_zoom, 'Normalised individual trends (stacked) from 3 to 4 s');
    axis(ax_stk_zoom, 'off');
else
    for j = 1:5
        v = all_params(j, valid_idx);
        v = v(mask_zoom);

        if isempty(v)
            continue;
        end

        rngv = max(v) - min(v);
        if rngv < 1e-12
            rngv = 1;
        end

        v_n = (v - min(v)) / rngv + (5-j)*1.15;

        plot(ax_stk_zoom, t_zoom, v_n, 'Color', param_colors(j,:), 'LineWidth', 1.2);
        text(ax_stk_zoom, 4.01, v_n(end), param_names{j}, ...
            'Color', param_colors(j,:), 'FontWeight', 'bold', 'FontSize', 9);
    end

    xlabel(ax_stk_zoom, 'Time (s)');
    ylabel(ax_stk_zoom, 'Normalised value');
    title(ax_stk_zoom, 'Normalised individual trends (stacked) from 3 to 4 s');
    grid(ax_stk_zoom, 'on');
    box(ax_stk_zoom, 'on');
    set(ax_stk_zoom, 'YTick', []);
    xlim(ax_stk_zoom, [3 4.05]);
end
hold(ax_stk_zoom, 'off');

% =========================================================
% SLIDER + CONTROLS
% =========================================================
n_wins = length(valid_idx);

uicontrol(fig, 'Style', 'text', ...
    'Units', 'normalized', 'Position', [0.01 0.005 0.09 0.025], ...
    'String', 'Window:', ...
    'HorizontalAlignment', 'right', ...
    'BackgroundColor', fig.Color, 'FontSize', 9);

sld = uicontrol(fig, 'Style', 'slider', ...
    'Units', 'normalized', 'Position', [0.11 0.005 0.65 0.025], ...
    'Min', 1, 'Max', n_wins, 'Value', 1, ...
    'SliderStep', [1/max(n_wins-1,1), min(10/max(n_wins-1,1),1)]);

t_lbl = uicontrol(fig, 'Style', 'text', ...
    'Units', 'normalized', 'Position', [0.77 0.005 0.12 0.025], ...
    'String', sprintf('t = %.3f s', t_vec(1)), ...
    'HorizontalAlignment', 'left', ...
    'BackgroundColor', fig.Color, 'FontSize', 9);

% Use the slider callback directly
sld.Callback = @(~,~) cb_update(fig);

% Store state
ud.valid_idx       = valid_idx;
ud.all_params      = all_params;
ud.output          = output;
ud.dt              = dt;
ud.win_dur         = win_dur;
ud.win_pts         = win_pts;
ud.time_delay_samp = time_delay_samp;
ud.min_acc         = min_acc;
ud.max_acc         = max_acc;
ud.t_vec           = t_vec;
ud.ax_sig          = ax_sig;
ud.ax_ell          = ax_ell;
ud.ax_par          = ax_par;
ud.ax_stk          = ax_stk;
ud.ax_stk_zoom     = ax_stk_zoom;
ud.win_patch       = win_patch;
ud.cur_line        = cur_line;
ud.cur_line_stk    = cur_line_stk;
ud.sld             = sld;
ud.t_lbl           = t_lbl;
ud.stdColors       = stdColors;
fig.UserData       = ud;

% Draw first window
cb_update(fig);

fprintf('\nInteractive figure ready.\n');
fprintf('Drag the slider to move through windows.\n');
fprintf('Click "Save SVG" to export the current figure as vector graphics.\n');

% =========================================================
% CALLBACK: update all panels when slider moves
% =========================================================
function cb_update(fig)
    ud  = fig.UserData;
    idx = round(get(ud.sld, 'Value'));
    idx = max(1, min(idx, length(ud.valid_idx)));

    i    = ud.valid_idx(idx);
    t_cur = ud.t_vec(idx);

    % rebuild point cloud
    i1 = i;
    i2 = i + ud.win_pts - 1 - ud.time_delay_samp;
    i3 = i + ud.time_delay_samp;
    i4 = i3 + ud.win_pts - 1 - ud.time_delay_samp;

    if i2 > length(ud.output) || i4 > length(ud.output)
        return;
    end

    P = [ud.output(i1:i2), ud.output(i3:i4)];

    % update shaded window on signal
    x_l = t_cur;
    x_r = t_cur + ud.win_dur;
    set(ud.win_patch, 'XData', [x_l x_r x_r x_l]);

    % update time readout
    set(ud.t_lbl, 'String', sprintf('t = %.3f s', t_cur));

    % redraw ellipse panel
    cla(ud.ax_ell);
    plot_ellipse(P, ud.all_params(:, i), ud.ax_ell, ud.stdColors);
    title(ud.ax_ell, sprintf('Ellipse at t = %.3f s', t_cur));
    axis(ud.ax_ell, 'equal');
    grid(ud.ax_ell, 'on');
    box(ud.ax_ell, 'on');

    % move vertical marker on parameter plots
    ud.cur_line.Value     = t_cur;
    ud.cur_line_stk.Value = t_cur;

    drawnow limitrate;
end

% =========================================================
% CALLBACK: save current figure as SVG
% =========================================================
function cb_save_svg(fig)
    ud  = fig.UserData;
    idx = round(get(ud.sld, 'Value'));
    idx = max(1, min(idx, length(ud.valid_idx)));
    t_sel = ud.t_vec(idx);

    fname = sprintf('fast_tda_window_t%.3f.svg', t_sel);

    try
        exportgraphics(fig, fname, 'ContentType', 'vector', 'BackgroundColor', 'white');
    catch
        % Fallback for older MATLAB versions
        saveas(fig, fname);
    end

    fprintf('Saved SVG: %s\n', fname);
end

% =========================================================
% LOCAL FUNCTIONS
% =========================================================
function plot_ellipse(P, params, ax, cols)
    a = params(1); b = params(2); c = params(3);
    d = params(4); e = params(5); f = params(6);

    denom = b^2 - 4*a*c;
    if abs(denom) < 1e-12
        warning('Degenerate conic');
        plot(ax, P(:,1), P(:,2), '.', 'Color', cols(1,:), 'MarkerSize', 4);
        axis(ax, 'equal');
        return;
    end

    x0 = (2*c*d - b*e) / denom;
    y0 = (2*a*e - b*d) / denom;

    if abs(a-c) > 1e-12
        theta = 0.5 * atan(b / (a - c + eps));
    elseif a >= c
        theta = pi/2;
    else
        theta = 0;
    end

    up  = 2*(a*e^2 + c*d^2 + f*b^2 - 2*b*d*e - 4*a*c*f);

    if abs(a-c) < 1e-12
        temp = 0;
    else
        temp = sqrt(1 + (b/(a-c))^2);
    end

    dn1 = (b^2 - 4*a*c) * ((c-a)*temp - (c+a));
    dn2 = (b^2 - 4*a*c) * (-(c-a)*temp - (c+a));

    if up <= 0 || dn1 <= 0 || dn2 <= 0 || isnan(up) || isnan(dn1) || isnan(dn2)
        warning('Cannot compute ellipse axes');
        plot(ax, P(:,1), P(:,2), '.', 'Color', cols(1,:), 'MarkerSize', 4);
        axis(ax, 'equal');
        return;
    end

    rx = sqrt(up / dn1);
    ry = sqrt(up / dn2);

    t  = linspace(0, 2*pi, 300);
    xr = rx*cos(t)*cos(theta) - ry*sin(t)*sin(theta) + x0;
    yr = rx*cos(t)*sin(theta) + ry*sin(t)*cos(theta) + y0;

    plot(ax, P(:,1), P(:,2), '.', 'Color', cols(1,:), 'MarkerSize', 4);
    hold(ax, 'on');
    plot(ax, xr, yr, '-', 'Color', cols(2,:), 'LineWidth', 2);
    axis(ax, 'equal');
    hold(ax, 'off');
end

function a = fit_ellipse_hls_golden(x, y)
    if length(x) < 5
        error('At least 5 points required');
    end

    % Design matrix: [x^2, x*y, y^2, x, y, 1]
    D_mat = [x.^2, x.*y, y.^2, x, y, ones(size(x))];
    S_mat = D_mat' * D_mat;

    % Block extraction
    Spp = S_mat(1:3,1:3);
    Spq = S_mat(1:3,4:6);
    Sqq = S_mat(4:6,4:6);

    % Analytic inverse of Sqq with regularization
    REG = 1e-6;
    aq = Sqq(1,1) + REG;  bq = Sqq(1,2);  cq = Sqq(1,3);
    eq = Sqq(2,2) + REG;  fq = Sqq(2,3);
    gq = Sqq(3,3) + REG;

    dv = aq*(eq*gq - fq^2) - bq*(bq*gq - fq*cq) + cq*(bq*fq - eq*cq);
    id = 1 / dv;

    Q = zeros(3);
    Q(1,1) = (eq*gq - fq^2) * id;
    Q(1,2) = -(bq*gq - cq*fq) * id;
    Q(1,3) = (bq*fq - cq*eq) * id;
    Q(2,1) = Q(1,2);
    Q(2,2) = (aq*gq - cq^2) * id;
    Q(2,3) = -(aq*fq - cq*bq) * id;
    Q(3,1) = Q(1,3);
    Q(3,2) = Q(2,3);
    Q(3,3) = (aq*eq - bq^2) * id;

    % Schur reduction
    S_red = Spp - Spq * Q * Spq';

    % Hard-coded invD
    invD = [0.0 0.5 0.0;
            0.5 0.0 0.0;
            0.0 0.0 -1.0];

    A_mat = invD * S_red;

    % Eigen-decomposition
    [V, De] = eig(A_mat);
    lam = diag(De);
    [~, idx] = min(abs(lam));
    ap = V(:, idx);

    % Recover linear part
    aq_v = -Q * (Spq' * ap);

    % Full coefficient vector
    a = [ap; aq_v];

    % Normalize
    Cm = zeros(6,6);
    Cm(1,3) = 2;
    Cm(3,1) = 2;
    Cm(2,2) = -1;

    sc = sqrt(abs(a' * Cm * a));
    if sc > 1e-12
        a = a / sc;
    end
end