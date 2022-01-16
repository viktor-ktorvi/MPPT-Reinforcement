function d = d_sigmoid(x)
    d = exp(-x) ./ (1 + exp(-x)) .^ 2;
end

