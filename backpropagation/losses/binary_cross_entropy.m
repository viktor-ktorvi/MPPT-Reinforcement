function error = binary_cross_entropy(t,y)
    error = -sum(t .* log(y) + (1 - t) .* log(1 - y));
end

