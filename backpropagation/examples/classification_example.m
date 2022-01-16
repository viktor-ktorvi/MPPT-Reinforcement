clc;
close all;
clear variables;

set(groot, 'defaulttextinterpreter', 'latex');  
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');  
set(groot, 'defaultLegendInterpreter', 'latex');
%% Remarks
% I'm not 100 % sure in the implementation. Gradient clipping is almost
% always active, gradient's are almost always clipped if you look at them.
% ReLU gives exploding gradients almost always and it seems that clipping
% doesn't help.
%% Generating data

num_A = 300;
num_B = 400;


ma = [-2; -1] + 10;
sa = 2;

mb = [1.5; 3] + 10;
sb = 1;

data = [ma + sa * randn(2, num_A), mb + sb * randn(2, num_B)];
%% Labeling 
la = [ones(1, num_A); zeros(1, num_A)];
lb = [zeros(1, num_B); ones(1, num_B)];
labels = [la, lb];

%% Shuffling 
permutation = randperm(size(labels, 2));

data = data(:, permutation);
labels = labels(:, permutation);

%% Splitting
split_index = round(0.7 * size(data, 2));

data_train = data(:, 1:split_index);
labels_train = labels(:, 1:split_index);

data_test = data(:, split_index:end);
labels_test = labels(:, split_index:end);


figure
hold on
axis equal
scatter(data_train(1, labels_train(1, :) == 1), data_train(2, labels_train(1, :) == 1))
scatter(data_train(1, labels_train(1, :) == 0), data_train(2, labels_train(1, :) == 0))

title('Classes')
xlabel('$x_1$')
ylabel('$x_2$')
legend('class A', 'class B')
%% Normalizing

train_mean = mean(data_train, 2);
train_std = std(data_train');

data_train_norm = (data_train - train_mean) ./ train_std';
data_test_norm = (data_test - train_mean) ./ train_std';        

figure
hold on
axis equal
scatter(data_train_norm(1, labels_train(1, :) == 1), data_train_norm(2, labels_train(1, :) == 1))
scatter(data_train_norm(1, labels_train(1, :) == 0), data_train_norm(2, labels_train(1, :) == 0))

title('Normalized data')
xlabel('$x_1$')
ylabel('$x_2$')
legend('class A', 'class B')

X_train_norm = [ones(1, size(data_train_norm, 2)); data_train_norm];
X_test_norm = [ones(1, size(data_test_norm, 2)); data_test_norm];

X = X_train_norm;

%% Network parameters

learning_rate = 0.01;
lambda = 0.05;
epochs = 100;
batch_size = 64;

% gradient clipping
clip_flg = 1;
clip_norm = 1;
clip_val = 0.5;

% weight initialization
sigma_weights = 0.1;

%% Network

% layer def
layer_sizes = [size(X, 1); 4; 6; size(labels, 1)];

% activation functions and their derivatives by layer
activations = {@tanh; @tanh; @tanh; @sigmoid};
d_activations = {@d_tanh; @d_tanh; @d_tanh; @d_sigmoid};


% error derivative
dEdy = @d_binary_cross_entrpoy;

model = MultilayerPerceptron(layer_sizes, activations, d_activations, sigma_weights, dEdy, lambda, clip_flg, clip_norm, clip_val);


%% Training
error_array = zeros(epochs, 1);
for i = 1:epochs
    error = model.train(X, labels_train, batch_size, learning_rate, @binary_cross_entropy);
    % The error doesn't decrease forever, it reaches a minimum and then
    % starts increasing. Not sure if it's an error

    fprintf("Epoch = %d Error = %2.5f\n", i, error)
    error_array(i) = error;
end

figure
plot(error_array)
title('Training error')
xlabel('Epoch [num]')
ylabel('Error')


%% Results
range = 1:size(labels_test, 2); % which samples to test on
[accuracy, prediction, ground_truth] = classification_accuracy(model, X_test_norm, labels_test, range);
fprintf("\nTest accuracy = %2.2f %%\n", 100 * accuracy)

figure
axis equal
hold on
scatter(data_test(1, prediction == 1), data_test(2, prediction == 1), 'b')
scatter(data_test(1, prediction == 2), data_test(2, prediction == 2), 'r')

title('Test results')
xlabel('$x_1$')
ylabel('$x_2$')
legend('predicted A', 'predicted B')

