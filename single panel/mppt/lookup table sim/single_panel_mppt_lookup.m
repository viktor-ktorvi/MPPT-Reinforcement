clc;
close all;
clear variables;

set(groot, 'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');

%% Parameters
sim_time = 2;   % simulation time [s]
Voc = 43.99; % V
Isc = 5.17; % A
Ts = 1e-3;  % sampling time
max_time_step = 1e-3; % variable step solver max step size
duty_step = 1/400;

T = 25; % 'C
Irradiance = 1000; % W/m^2

% look up table data for mpp's of different irradiances at 25'C
load('../../power as a function of irradiance/mpp_versus_irr_data_at_T_25.mat')
load('../../curve generation/pv_curve_T_25_Irr_1000.mat')
%% Q parameters
deg_threshold = deg2rad(5);
wp = 1; % positive reward weight
wn = 4; % negative reward weight
gamma = 0.9;    % discount factor
alpha = 0.1;    % learning rate
exploration_factor_init = 0.9999;

% how to make this more general? Like explore more when things have changed

actions = (-1:1) * duty_step;
n_V = 100;
n_I = 100;
%% Irradiance profile



%% Sim
out = sim('single_panel_mppt_lookup_sim.slx');
%%
figure;
hold on
% grid on
plot(out.power, 'LineWidth', 2)
plot(out.mpp, 'LineWidth', 2)
title("Maximum power point tracking")
xlabel('t [$s$]')
ylabel('P [$W$]')
legend('generated power', 'maximum power point', 'Location','southeast')

%% Execution time analysis 
% num = 5;
% exec_times = zeros(1, num);
% for i = 1:num
% tic
% sim("single_panel_mppt_lookup_sim.slx");
% exec_times(i) = toc;
% end
% 
% fprintf('Avegage execituon time = %2.5f', mean(exec_times));