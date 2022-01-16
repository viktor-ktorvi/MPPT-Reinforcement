function W = init_weights(layer_sizes, sigma)
    W = cell(length(layer_sizes) - 1, 1);
    for i = 2:length(layer_sizes)
        W{i - 1} = sigma * randn(layer_sizes(i), layer_sizes(i - 1));
    end
end

