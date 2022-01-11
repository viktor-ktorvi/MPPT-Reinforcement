clc;
close all;
clear variables;

set(groot, 'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');
%% Parameters
sim_time = 1;   % simulation time
n = 1;  % number of panels
Voc = 43.99;
ramp_slope = n * Voc / sim_time;  % n times Voc of one minus Vd
Ts = 1e-4;  % sampling time
tau = 1e-7;
max_time_step = 1e-4; % variable step solver max step size
duty_step = 1/400;
P_max = 175.087; % W
%% Sim
% out = sim('single_panel_mppt_sim.slx');