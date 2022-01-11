clc;
close all;
clear variables;

set(groot, 'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');
%% Parameters
sim_time = 5;   % simulation time
Voc = 43.99;
Ts = 1e-3;  % sampling time
max_time_step = 1e-4; % variable step solver max step size
duty_step = 1/400;

% look up table data for mpp's of different irradiances at 25'C
load('../power as a function of irradiance/mpp_versus_irr_data_at_T_25.mat')
%% Irradiance profile

syms Irr(t)
time = [0; 0.3; 0.6; 1] * sim_time;


square = @(t1, t2) heaviside(t - t1) - heaviside(t - t2);

% Irr(t) = 500 * square(time(1), time(2)) + ...
%     t * (1000 - 500) / (0.6 - 0.3) * square(time(2), time(3)) + ...
%     1000 * square(time(3), time(4));

Irr(t) = piecewise((t >= time(1)) & (t <= time(2)), 500, ...
                   (t >= time(2)) & (t <= time(3)), t * (1000 - 600) / (time(3) - time(2)), ...
                   (t >= time(3)) & (t <= time(4)), 800);
figure
fplot(Irr, [0, sim_time])
title('Irradiance profile')
xlabel('t [$s$]')
ylabel('Irradiance [$\frac{W}{m^2}$]')

open_system('single_panel_mppt_sim.slx');

matlabFunctionBlock('single_panel_mppt_sim/irr_profile', Irr)

num = 5;
exec_times = zeros(1, num);
for i = 1:num
tic
sim("single_panel_mppt_sim.slx");
exec_times(i) = toc;
end

fprintf('Avegage execituon time = %2.5f', mean(exec_times));