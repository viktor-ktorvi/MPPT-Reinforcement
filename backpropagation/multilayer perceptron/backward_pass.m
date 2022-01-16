function dEdW = backward_pass(target, y, W, dEdy, d_activations, dEdW, lambda)
    h = dEdy(target, y{end});
    for k = length(y):-1:2
        h = h .* d_activations{k-1}(y{k});

        dEdW{k - 1} = h * y{k - 1}' + lambda * dOmegadW(W{k - 1});

        h = W{k-1}' * h;
    end
end

