clc;
close all;
clear variables;

set(groot, 'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');
%% Sim parameters
sim_time = 1.75;   % simulation time [s]
Ts = 1e-4;  % sampling time
Voc = 43.99; % V
Isc = 5.17; % A
duty_step = 1/400;

load('../curve generation/pv_curve_T_25_Irr_1000.mat')

P_max = max(voltage .* current);
%% Q parameters
wp = 1; % positive reward weight
wn = 4; % negative reward weight
gamma = 0.9;    % discount factor
actions = (-1:1) * duty_step;
%% Network parameters

learning_rate = 0.001;
lambda = 0.0000;

sigma_weights = 0.5;

% gradient clipping
clip_flg = 0;
clip_norm = 1;
clip_val = 0.5;
%% Network
% layer def
layer_sizes = [3; 10; 10; length(actions)];

% activation functions and their derivatives by layer
activations = {@relu; @relu; @linear};
d_activations = {@d_relu; @d_relu; @d_linear};

% error derivative
dEdy = @d_mse;

model = MultilayerPerceptron(layer_sizes, activations, d_activations, sigma_weights, dEdy, lambda, clip_flg, clip_norm, clip_val);
%% Sim
iterations = 0:Ts:sim_time;
power_array = zeros(length(iterations), 1);
duty_array = zeros(length(iterations), 1);
loss_array = zeros(length(iterations), 1);

duty = 0;

% TODO stop putting in deg and put in V, I, dV, dI, and save dV_old and
% dI_old

I_old = 0;
V_old = 0;
deg_old = 1;
duty_old = 0;

for i = 1:length(iterations)

    % measure environment
    V_measured = duty * Voc;
    I_measured = interp1(voltage, current, V_measured,'linear') + randn * Isc * 0.001;
    
    power_array(i) = V_measured * I_measured;
    duty_array(i) = duty;

    % maybe subtract 0.5 to center around 0
    I = I_measured / Isc - 0.5;
    V = V_measured / Voc - 0.5;

    % calc changes
    dI = I - I_old;
    dV = V - V_old;
    dP = V * I - V_old * I_old;
    

    % see where deg is (are we close to the MPP or not?)
    deg = atan2(dI, dV) + atan2(I, V);
    if isnan(deg)
        fprintf('deg is nan')
    end
    
    % calc reward
    if dP > 0
        R = wp * dP;
    else
        R = wn * dP;
    end
    

    % Bellman equation
    q_star_t = model.forward_pass([V; I; deg]);
    q_star_t1 = R + gamma * max(q_star_t);
    
    % forward pass
    q_t1 = model.forward_pass([V_old; I_old; deg_old]);
    
    loss_array(i) = 0.5 * sum((q_t1 - q_star_t1).^2);
    % backward pass
    model.backward_pass(q_star_t1);
    
    % weight update
    model.update_weights(learning_rate);
    
    % maybe a third forward pass, but that might be too much
    [~, argmax]  = max(q_star_t);

    duty = duty_old + actions(argmax);


    if duty > 1 || duty < 0
        duty = duty_old;
    end

    V_old = V;
    I_old = I;
    deg_old = deg;
    duty_old = duty;
end
%% Results
figure;
plot(iterations, loss_array)
title("Loss")
xlabel('t [$s$]')
ylabel('loss')

figure;
plot(iterations, duty_array)
title("Duty cycle")
xlabel('t [$s$]')
ylabel('d')

figure;
hold on;
yline(P_max, 'Color', 'b');
plot(iterations, power_array, 'r')
title("Power vs MPP")
xlabel('t [$s$]')
ylabel('P [$W$]')


