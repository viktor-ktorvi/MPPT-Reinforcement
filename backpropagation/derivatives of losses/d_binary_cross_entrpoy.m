function d = d_binary_cross_entrpoy(t, y)
    d = -(t ./ y - (1 - t) ./ (1 - y));
end

