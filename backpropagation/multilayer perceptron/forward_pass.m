function y = forward_pass(x, W, activations, y)
    % forward pass
    y{1} =  x;
    for k = 2:length(y)
        y{k - 1} = [ones(1, size(x, 2)); y{k - 1}]; % concatenate ones for the bias in the lenght of the batch_size
        y{k} = activations{k-1}(W{k - 1} * y{k - 1});
    end
end

