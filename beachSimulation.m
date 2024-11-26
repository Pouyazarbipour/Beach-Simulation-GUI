function beachSimulation()
    % Procedural implementation of the beachSimulation
    % Parameters
    n = 100;      % Number of points in profile
    B = 1.0;      % Berm height (m)
    h = 6.0;      % Depth of closure (m)
    d = 0.3;      % Native grain size (mm)
    df = 0.4;     % Fill grain size (mm)
    W = 50.0;     % Final fill width (m)

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

    % Plot results
    plotProfiles(hn, hf, xmax, volume, AN, AF);
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

function plotProfiles(hn, hf, xmax, volume, AN, AF)
    % Plot the profiles and results
    x = linspace(0, xmax, length(hn));
    figure;
    hold on;

    % Plot native beach profile
    fill([x, xmax, 0], [hn, 0, 0], [212, 164, 96] / 255, 'EdgeColor', 'none');
    
    % Plot fill beach profile
    fill([x, xmax, 0], [hf, 0, 0], [1, 0, 1], 'EdgeColor', 'none');

    % Plot ocean
    fill([xmax, xmax, 0, 0], [0, -10, -10, 0], [0, 0, 1], 'EdgeColor', 'none', 'FaceAlpha', 0.5);

    % Plot axes and labels
    plot([0, xmax], [0, 0], 'k', 'LineWidth', 1.5); % X-axis
    xlabel('Distance (m)');
    ylabel('Depth (m)');
    title('Beach Profile and Fill Visualization');
    legend('Native Beach', 'Filled Beach', 'Ocean');
    
    % Annotate calculated values
    text(10, -1, sprintf('A_N = %.3f', AN));
    text(xmax / 2, -1, sprintf('A_F = %.3f', AF));
    text(10, -2, sprintf('x_{max} = %.2f m', xmax));
    text(xmax / 2, -2, sprintf('Volume = %.2f m^3/m', volume));
    
    hold off;
end
