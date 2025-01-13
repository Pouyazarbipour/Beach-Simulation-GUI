%% POUYA ZARBIPOUR LAKPOSHTEH EMAIL: pouyazarbipour@gmail.com

function beachSimulationGUI()
    % Create GUI figure
    fig = uifigure('Name', 'Beach Simulation', 'Position', [100, 100, 400, 600]);

    % Input fields
    uilabel(fig, 'Text', 'Number of Points (n):', 'Position', [20, 550, 150, 22]);
    nField = uieditfield(fig, 'numeric', 'Value', 100, 'Position', [200, 550, 100, 22]);

    uilabel(fig, 'Text', 'Berm Height (B, m):', 'Position', [20, 500, 150, 22]);
    BField = uieditfield(fig, 'numeric', 'Value', 1.0, 'Position', [200, 500, 100, 22]);

    uilabel(fig, 'Text', 'Depth of Closure (h, m):', 'Position', [20, 450, 150, 22]);
    hField = uieditfield(fig, 'numeric', 'Value', 6.0, 'Position', [200, 450, 100, 22]);

    uilabel(fig, 'Text', 'Native Grain Size (d, mm):', 'Position', [20, 400, 150, 22]);
    dField = uieditfield(fig, 'numeric', 'Value', 0.3, 'Position', [200, 400, 100, 22]);

    uilabel(fig, 'Text', 'Fill Grain Size (df, mm):', 'Position', [20, 350, 150, 22]);
    dfField = uieditfield(fig, 'numeric', 'Value', 0.4, 'Position', [200, 350, 100, 22]);

    uilabel(fig, 'Text', 'Fill Width (W, m):', 'Position', [20, 300, 150, 22]);
    WField = uieditfield(fig, 'numeric', 'Value', 50.0, 'Position', [200, 300, 100, 22]);

    % Run simulation button
    runButton = uibutton(fig, 'Text', 'Run Simulation', ...
        'Position', [100, 250, 200, 40], ...
        'ButtonPushedFcn', @(btn, event) runSimulation(fig, ...
            nField.Value, BField.Value, hField.Value, dField.Value, dfField.Value, WField.Value));

    % Axes for plotting
    ax = uiaxes(fig, 'Position', [20, 20, 360, 200]);
    ax.Title.String = 'Beach Profiles';
    ax.XLabel.String = 'Distance (m)';
    ax.YLabel.String = 'Depth (m)';
end

function runSimulation(fig, n, B, h, d, df, W)
    % Compute slope factors
    AN = Acalc(d);
    AF = Acalc(df);

    % Calculate xmax and volume
    xmax_n = (h / AN)^1.5;
    xmax_f = W + (h / AF)^1.5;

    if AF > AN
        xmax = xmax_n;
        volume = calculateVolume(B, W, AN, AF, xmax_n);
    elseif AF == AN
        xmax = xmax_n + W;
        volume = W * (B + h);
    else
        xmax = xmax_f;
        volume = calculateVolume(B, W, AN, AF, xmax_n);
    end

    % Generate profiles
    [hn, hf] = calculateProfiles(n, xmax, W, B, AN, AF);

    % Plot results in GUI axes
    ax = findall(fig, 'Type', 'axes');
    plotProfiles(ax, hn, hf, xmax, volume, AN, AF);
end

function A = Acalc(d)
    % Calculate slope factor based on grain size
    A = 0.0165 * d^3 - 0.2118 * d^2 + 0.5028 * d - 0.0008;
end

function volume = calculateVolume(B, W, AN, AF, xmax_n)
    % Calculate volume based on grain sizes
    volume = B * W + 0.6 * AN * W^(5/3) / (1 - (AN / AF)^1.5)^(2/3);
end

function [hn, hf] = calculateProfiles(n, xmax, W, B, AN, AF)
    % Generate native and fill beach profiles
    dx = xmax / (n - 1);
    hn = zeros(1, n); % Native beach profile
    hf = zeros(1, n); % Fill beach profile

    for i = 1:n
        x = (i - 1) * dx;
        hn(i) = AN * x^(2/3); % Native profile
        
        if x < W
            hf(i) = -B;    % Fill profile (berm)
        else
            hf(i) = AF * (x - W)^(2/3);
        end
    end
end

function plotProfiles(ax, hn, hf, xmax, volume, AN, AF)
    % Plot the profiles and results in the given axes
    x = linspace(0, xmax, length(hn));
    cla(ax); % Clear previous plots
    hold(ax, 'on');

    % Plot native beach profile
    fill(ax, [x, xmax, 0], [hn, 0, 0], [212, 164, 96] / 255, 'EdgeColor', 'none');
    
    % Plot fill beach profile
    fill(ax, [x, xmax, 0], [hf, 0, 0], [1, 0, 1], 'EdgeColor', 'none');

    % Plot ocean
    fill(ax, [xmax, xmax, 0, 0], [0, -10, -10, 0], [0, 0, 1], 'EdgeColor', 'none', 'FaceAlpha', 0.5);

    % Annotate calculated values
    title(ax, sprintf('Volume = %.2f m^3/m | A_N = %.3f | A_F = %.3f', volume, AN, AF));
    hold(ax, 'off');
end
