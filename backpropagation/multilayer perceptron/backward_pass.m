function dEdW = backward_pass(target, y, W, dEdy, d_activations, dEdW, lambda)
    h = dEdy(target, y{end});
    for k = length(y):-1:2
        h = h .* d_activations{k-1}(y{k});

        % this removing of the bias so that the dimensions fit
        % was written at 1am and is very sus
        if k ~= length(y)
            y{k}(1, :) = []; % lose the ones
            h(1, :) = [];
        end
        dEdW{k - 1} = h * y{k - 1}' + lambda * dOmegadW(W{k - 1});
        
        h = W{k-1}' * h;
    end
end

