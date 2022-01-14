clc;
close all;
clear variables;

set(groot, 'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');

% TODO temp profile
%% Parameters
sim_time = 2;   % simulation time [s]
Voc = 43.99; % V
Isc = 5.17; % A
Ts = 1e-4;  % sampling time
max_time_step = 1e-4; % variable step solver max step size
duty_step = 1/400;
T = 25; % 'C TODO make a temperature profile

% look up table data for mpp's of different irradiances at 25'C
load('../power as a function of irradiance/mpp_versus_irr_data_at_T_25.mat')
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

syms Irr(t)
time = [0; 0.2; 0.4; 0.6; 0.7; 0.9; 1] * sim_time;

Irr(t) = piecewise((t >= time(1)) & (t <= time(2)), 500, ...
                   (t >= time(2)) & (t <= time(3)), 400 + (t - time(2)) * (1000 - 500) / (time(3) - time(2)), ...
                   (t >= time(3)) & (t <= time(4)), 800, ...
                   (t >= time(4)) & (t <= time(5)), 800 + (t - time(4)) * (300 - 800) / (time(5) - time(4)), ...
                   (t >= time(5)) & (t <= time(6)), 300 + (t - time(5)) * (1000 - 300) / (time(6) - time(5)), ...
                   (t >= time(6)) & (t <= time(7)), 1000);
figure
fplot(Irr, [0, sim_time])
title('Irradiance profile')
xlabel('t [$s$]')
ylabel('Irradiance [$\frac{W}{m^2}$]')

% uncomment if next line throws an error
% open_system('single_panel_mppt_sim.slx');

matlabFunctionBlock('single_panel_mppt_sim/irr_profile', Irr)

%% Sim
out = sim('single_panel_mppt_sim.slx');
%%
figure;
hold on
% grid on
plot(out.power, 'LineWidth', 2)
plot(out.mpp, 'LineWidth', 2)
title("Maximum power point tracking" + newline + "Q table")
xlabel('t [$s$]')
ylabel('P [$W$]')
legend('generated power', 'maximum power point', 'Location','southeast')

%% Execution time analysis 
% num = 5;
% exec_times = zeros(1, num);
% for i = 1:num
%     tic
%     sim("single_panel_mppt_sim.slx");
%     exec_times(i) = toc;
% end
% 
% fprintf('Avegage execituon time = %2.5f', mean(exec_times));