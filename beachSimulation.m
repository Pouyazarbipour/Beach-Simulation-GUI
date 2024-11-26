function beachSimulation()
    % Main Function to Run the Simulation

    % Input Data
    n = 100;
    din = 0.3; % Native Grain size
    dfin = 0.4; % Fill Grain size
    Win = 50.0; % Final Fill Width
    Bin = 1.0; % Berm Height
    hin = 6.0; % Depth of Closure

    % Calculate Profiles and Bathymetry
    [bathn, bathf, xmax, volume] = calculateBeach(n, din, dfin, Win, Bin, hin);

    % Plot Results
    plotBeach(bathn, bathf, xmax, volume);
end

% Supporting Functions
function bathymetry = createBathymetry(npts, dx, he, sl)
    % Create Bathymetry Structure
    bathymetry.NPTS = npts;
    bathymetry.DX = dx;
    bathymetry.h = he;
    bathymetry.slope = sl;
end

function [bathn, bathf, xmax, volume] = calculateBeach(n, din, dfin, Win, Bin, hin)
    % Calculate Beach Profiles and Metrics
    AN = Acalc(din);
    AF = Acalc(dfin);

    xmaxn = (hin / AN)^1.5;
    xmaxf = Win + (hin / AF)^1.5;

    hn = zeros(1, n);
    hf = zeros(1, n);

    if AF > AN
        yi = Win / (1 - (AN / AF)^1.5);
        hi = AN * yi^(2/3);
        if hi < hin
            xmax = xmaxn;
            volume = Bin * Win + 0.6 * AN * Win^(5/3) / (1 - (AN / AF)^1.5)^(2/3);
            [hn, hf] = calculateProfiles(n, xmaxn, Win, AN, AF, Bin);
        else
            xmax = xmaxf;
            volume = Bin * Win + 0.6 * hin * xmaxn * ((Win / xmaxn + (AN / AF)^1.5)^(5/3) - (AN / AF)^1.5);
            [hn, hf] = calculateProfiles(n, xmaxf, Win, AN, AF, Bin);
        end
    elseif AF == AN
        xmax = xmaxn + Win;
        volume = Win * (Bin + hin);
        [hn, hf] = calculateProfiles(n, xmax, Win, AN, AF, Bin);
    else
        xmax = xmaxf;
        volume = Bin * Win + 0.6 * hin * xmaxn * ((Win / xmaxn + (AN / AF)^1.5)^(5/3) - (AN / AF)^1.5);
        [hn, hf] = calculateProfiles(n, xmaxf, Win, AN, AF, Bin);
    end

    bathn = createBathymetry(n, xmax / (n - 1), hn, AN);
    bathf = createBathymetry(n, xmax / (n - 1), hf, AF);
end

function [hn, hf] = calculateProfiles(n, xmax, W, AN, AF, Bin)
    % Calculate Profiles for Native and Fill Beaches
    dx = xmax / (n - 1);
    hn = zeros(1, n);
    hf = zeros(1, n);
    for i = 1:n
        x = (i - 1) * dx;
        hn(i) = AN * x^0.6666;
        if x < W
            hf(i) = -Bin;
        else
            hf(i) = AF * (x - W)^0.6666;
        end
    end
end

function A = Acalc(d)
    % Calculate A based on Grain Size
    A = 0.0165 * d^3 - 0.2118 * d^2 + 0.5028 * d - 0.0008;
end

function plotBeach(bathn, bathf, xmax, volume)
    % Plot the Beach Profiles
    figure;
    hold on;

    % Original Beach Profile
    plot(linspace(0, xmax, bathn.NPTS), bathn.h, 'r', 'DisplayName', 'Original Beach');

    % Fill Beach Profile
    plot(linspace(0, xmax, bathf.NPTS), bathf.h, 'b', 'DisplayName', 'Fill Beach');

    % Display Results
    title('Beach Profiles');
    xlabel('Distance (m)');
    ylabel('Depth (m)');
    legend;

    % Display Metrics
    fprintf('A_N = %.3f\n', bathn.slope);
    fprintf('A_F = %.3f\n', bathf.slope);
    fprintf('x_max = %.2f\n', xmax);
    fprintf('Volume = %.2f m^3/m\n', volume);

    hold off;
end
