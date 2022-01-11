clc;
close all;
clear variables;

set(groot, 'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');
%% Parameters
sim_time = 1;   % simulation time
n = 1;  % number of panels
ramp_slope = n * 43.99 / sim_time;  % n times Voc of one minus Vd
Ts = 1e-4;  % sampling time
max_time_step = 1e-4; % variable step solver max step size
Irradiance = 500; % W/m^2
T = 25; % 'C
%% Sim
irr_data = 50:50:1300;
mpp_data = zeros(length(irr_data), 1);
for i = 1:length(irr_data)
    Irradiance = irr_data(i);
    out = sim('../curve generation/single_panel_sim.slx');
    voltage = out.voltage.Data;
    current = out.current.Data;
    
    % 'MinPeakProminence' of p Wats
    [peaks, arg_peaks] = findpeaks(voltage .* current, 'MinPeakProminence', 1);
    mpp_data(i) = max(peaks);
end

save("mpp_versus_irr_data_at_T_" + T, 'irr_data', 'mpp_data');
%% Plot

c = polyfit(irr_data, mpp_data, 1);
line_est = polyval(c, irr_data);

figure
plot(irr_data, mpp_data, 'ro');
hold on;
plot(irr_data, line_est, 'b');
title('Maximum power point as a function of irradiance')
xlabel('Irradiance [$\frac{W}{m^2}$]')
ylabel('MPP [$W$]')

