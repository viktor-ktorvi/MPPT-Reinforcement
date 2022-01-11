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
Irr = 50:50:1300;
mppt_array = zeros(length(Irr), 1);
for i = 1:length(Irr)
    Irradiance = Irr(i);
    out = sim('../curve generation/single_panel_sim.slx');
    voltage = out.voltage.Data;
    current = out.current.Data;
    
    % 'MinPeakProminence' of p Wats
    [peaks, arg_peaks] = findpeaks(voltage .* current, 'MinPeakProminence', 1);
    mppt_array(i) = max(peaks);
end
%% Plot

c = polyfit(Irr,mppt_array,1);
line_est = polyval(c,Irr);

figure
plot(Irr, mppt_array, 'ro');
hold on;
plot(Irr, line_est, 'b');
title('Maximum power point as a function of irradiance')
xlabel('Irradiance [$\frac{W}{m^2}$]')
ylabel('MPP [$W$]')

