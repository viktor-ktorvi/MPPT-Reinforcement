clc;
close all;
clear variables;

set(groot, 'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');
%% Parameters
sim_time = 1;   % simulation time
Voc = 43.99; % V

ramp_slope = Voc / sim_time;

% gamma correction allows for a denser sampling at the knee of the curve 
% as well se the stepp part
gamma_correction = 1/5;

% a scaling factor that 
k = Voc / (ramp_slope * sim_time) ^ gamma_correction;  

Ts = 0.5e-4;  % sampling time
max_time_step = 1e-4; % variable step solver max step size
Irradiance = 1000; % W/m^2
T = 25; % 'C
%% Sim
out = sim('single_panel_sim.slx');
voltage = out.voltage.Data;
current = out.current.Data;

save("pv_curve_T_" + T + "_Irr_" + Irradiance, 'voltage', 'current');
%% Plot
% 'MinPeakProminence' of p Wats
[peaks, arg_peaks] = findpeaks(voltage .* current, 'MinPeakProminence', 5 ); 

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