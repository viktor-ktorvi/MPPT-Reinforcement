clc;
close all;
clear variables;

set(groot, 'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');
%% Sim parameters
sim_time = 2.5;   % simulation time [s]
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

buffer_size = 1;
%% Network parameters

learning_rate = 0.005;
lambda = 0.00001;

% weight initialization
init_options.name = "lecun";
init_options.distribution = "gauss";

% gradient clipping
clip_flg = 0;
clip_norm = 1;
clip_val = 0.5;
%% Network
% layer def
layer_sizes = [3 * buffer_size; 5 * buffer_size; 5 * buffer_size; length(actions)];

% activation functions and their derivatives by layer
activations = {@magic_tanh; @magic_tanh; @sigmoid};
d_activations = {@d_magic_tanh; @d_magic_tanh; @d_sigmoid};

% error derivative
dEdy = @binary_cross_entropy;

model = MultilayerPerceptron(layer_sizes, activations, d_activations, init_options, dEdy, lambda, clip_flg, clip_norm, clip_val);
%% Sim
iterations = 0:Ts:sim_time;
power_array = zeros(length(iterations), 1);
duty_array = zeros(length(iterations), 1);
loss_array = zeros(length(iterations), 1);

duty = 0;

duty_old = 0;

V_buffer = zeros(buffer_size, 1);
I_buffer = zeros(buffer_size, 1);
deg_buffer = ones(buffer_size, 1) * pi;

if mod(length(actions), 2) == 0
    action_old = length(actions) / 2;
else
    action_old = (length(actions) + 1) / 2;
end

for i = 1:length(iterations)

    % measure environment
    V_measured = duty * Voc;
    I_measured = interp1(voltage, current, V_measured,'linear') + randn * Isc * 0.001;
    
    power_array(i) = V_measured * I_measured;
    duty_array(i) = duty;

    % normalize
    I = I_measured / Isc - 0.5;
    V = V_measured / Voc - 0.5;

    % calc changes
    dI = I - I_buffer(1);
    dV = V - V_buffer(1);
    dP = V * I - V_buffer(1) * I_buffer(1);
    

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
    q_new = model.forward_pass([V; V_buffer(1:end-1); I; I_buffer(1:end-1); deg; deg_buffer(1:end-1)]);
    expected_q = R + gamma * max(q_new);
    
    % forward pass
    q_old = model.forward_pass([V_buffer; I_buffer; deg_buffer]);
    
    loss_array(i) = binary_cross_entropy(expected_q, q_old(action_old));
    

    target = q_old;
    target(action_old) = expected_q;

    % backward pass
    model.backward_pass(target);
    
    % weight update
    model.update_weights(learning_rate);
    
%     q = model.forward_pass([V; V_buffer(1:end-1); I; I_buffer(1:end-1); deg; deg_buffer(1:end-1)]);
    % maybe a third forward pass
    [~, argmax]  = max(q_old);

    duty = duty_old + actions(argmax);




    V_buffer = [V; V_buffer(1:end - 1)];
    I_buffer = [I; I_buffer(1:end - 1)];
    deg_buffer = [deg; deg_buffer(1:end - 1)];
    action_old = argmax;

    if duty > 1 || duty < 0
        duty = duty_old;
    
        if mod(length(actions), 2) == 0
            action_old = length(actions) / 2;
        else
            action_old = (length(actions) + 1) / 2;
        end
    end
    duty_old = duty;

end
%% Results
figure;
plot(iterations, loss_array)
set(gca, 'YScale', 'log')
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


