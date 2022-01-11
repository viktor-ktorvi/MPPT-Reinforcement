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
Ts = 1e-3;  % sampling time
max_time_step = 1e-4; % variable step solver max step size
duty_step = 1/400;

% look up table data for mpp's of different irradiances at 25'C
load('../power as a function of irradiance/mpp_versus_irr_data_at_T_25.mat')