clc;
close all;
clear variables;

set(groot, 'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');
%% Parameters
sim_time = 5;   % simulation time [s]
Voc = 43.99; % V
Isc = 5.17; % A
Ts = 1e-3;  % sampling time
max_time_step = 1e-4; % variable step solver max step size
duty_step = 1/400;

% look up table data for mpp's of different irradiances at 25'C
load('../power as a function of irradiance/mpp_versus_irr_data_at_T_25.mat')
%% Q parameters
deg_threshold = deg2rad(5);
wp = 1;
wn = 4;
gamma = 0.9;
alpha = 0.1;
exploration_factor_init = 0.999;

actions = [-duty_step, 0, duty_step];
n_V = 100;
n_I = 100;
%% Irradiance profile

syms Irr(t)
time = [0; 0.6; 0.8; 1] * sim_time;

Irr(t) = piecewise((t >= time(1)) & (t <= time(2)), 500, ...
                   (t >= time(2)) & (t <= time(3)), 400 + (t - time(2)) * (1000 - 500) / (time(3) - time(2)), ...
                   (t >= time(3)) & (t <= time(4)), 800);
figure
fplot(Irr, [0, sim_time])
title('Irradiance profile')
xlabel('t [$s$]')
ylabel('Irradiance [$\frac{W}{m^2}$]')

% open_system('single_panel_mppt_sim.slx');

matlabFunctionBlock('single_panel_mppt_sim/irr_profile', Irr)

% num = 5;
% exec_times = zeros(1, num);
% for i = 1:num
% tic
% sim("single_panel_mppt_sim.slx");
% exec_times(i) = toc;
% end
% 
% fprintf('Avegage execituon time = %2.5f', mean(exec_times));