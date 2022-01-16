function y = forward_pass(x, W, activations, y)
    % forward pass
    y{1} = x;
    for k = 2:length(y)
        y{k} = activations{k-1}(W{k - 1} * y{k - 1});
    end
end

