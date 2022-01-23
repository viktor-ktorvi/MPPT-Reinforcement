clc;
close all;
clear variables;

set(groot, 'defaulttextinterpreter', 'latex');  
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');  
set(groot, 'defaultLegendInterpreter', 'latex');
%% Parameters
start = 0;
step = 0.01;
stop = 100 * 2 * pi;
%% Network parameters

learning_rate = 0.01;
lambda = 0.01;

% weight initialization
init_options.name = "xavier";
init_options.distribution = "gauss";

% gradient clipping
clip_flg = 1;
clip_norm = 1;
clip_val = 0.1;
%% Network
% layer def
layer_sizes = [1; 20; 20; 1];

% activation functions and their derivatives by layer
activations = {@magic_tanh; @magic_tanh; @linear};
d_activations = {@d_magic_tanh; @d_magic_tanh; @d_linear};

% error derivative
dEdy = @d_mse;

model = MultilayerPerceptron(layer_sizes, activations, d_activations, init_options, dEdy, lambda, clip_flg, clip_norm, clip_val);

%% Data
input = (start:step:stop)';
target_sequence = zeros(length(input), 1);

% output
output_sequence = zeros(length(input), 1);

% training
counter = 1;

for x = start:step:stop

    target = sin(x) + sin(2 * x) + randn * 0.01;
    target_sequence(counter) = target;
    
    % forward pass
    output_sequence(counter) = model.forward_pass(x);
    
    % backward pass
    model.backward_pass(target);

    % weight update
    model.update_weights(learning_rate);
    

    counter = counter + 1;
end

figure
plot(input, target_sequence)
hold on
plot(input, output_sequence)
title("Online learning of a timeseries")
xlabel('t [$s$]')
ylabel('y')
legend('target', 'nn output')