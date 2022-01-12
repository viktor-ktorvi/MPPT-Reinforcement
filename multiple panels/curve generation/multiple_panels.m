clc;
close all;
clear variables;

set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');
%% Sim parameters
sim_time = 1;   % simulation time
n = 3;  % number of panels

ramp_slope = 127 / sim_time;

Ts = 1e-3;  % sampling time
max_time_step = 1e-4; % variable step solver max step size

irradiances = [600, 1000, 100]; % W/m^2
T = 25; % 'C

filter_time_constant = 1e-4; % s
%% Sim
out = sim('multiple_panels_sim.slx');
voltage = out.voltage.Data;
current = out.current.Data;

% 'MinPeakProminence' of p Wats
[peaks, arg_peaks] = findpeaks(voltage .* current, 'MinPeakProminence', 1); 
[biggest_peak, arg_biggest_peak] = max(peaks);

%% Plot
figure
plot(voltage, current)
title('IV curve')
xlabel('V [V]')
ylabel('I [A]')

figure
hold on;
plot(voltage, voltage .* current)
plot(voltage(arg_peaks), peaks, 'bo')
plot(voltage(arg_peaks(arg_biggest_peak)), biggest_peak, 'ro')
title('PV curve')
xlabel('V [V]')
ylabel('P [W]')

%% Execution time analysis 
% num = 5;
% exec_times = zeros(1, num);
% for i = 1:num
% tic
% sim("multiple_panels_sim.slx");
% exec_times(i) = toc;
% end
% 
% fprintf('Avegage execituon time = %2.5f', mean(exec_times));