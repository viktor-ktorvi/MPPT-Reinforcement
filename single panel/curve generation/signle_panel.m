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
Irradiance = 1000; % W/m^2
T = 25; % 'C
%% Sim
out = sim('single_panel_sim.slx');
voltage = out.voltage.Data;
current = out.current.Data;

save("PV_peaks_" + n, 'voltage', 'current');
%% Plot
% 'MinPeakProminence' of p Wats
[peaks, arg_peaks] = findpeaks(voltage .* current, 'MinPeakProminence', 1); 

figure
plot(voltage, current)
title('IV curve')
xlabel('V [V]')
ylabel('I [A]')

figure
hold on;
plot(voltage, voltage .* current)
plot(voltage(arg_peaks), peaks, 'ro')
title('PV curve')
xlabel('V [V]')
ylabel('P [W]')