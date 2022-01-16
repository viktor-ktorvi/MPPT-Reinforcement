function W = update_weights(W, dEdW, alpha)
    % weight update
    for k = 1:length(W)
        W{k} = W{k} - alpha * dEdW{k};
    end
end

