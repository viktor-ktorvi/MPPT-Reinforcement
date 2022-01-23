function W = init_weights(layer_sizes, activations, init_options)
    W = cell(length(layer_sizes) - 1, 1);
    for i = 2:length(layer_sizes)
        
        n_in = layer_sizes(i - 1) + 1;  % plus 1 for bias
        n_out = layer_sizes(i);

        if isequal(activations{i - 1}, @relu)
            if init_options.distribution == "gauss"
                    sigma = sqrt(2 / n_in);
                    
                    W{i - 1} = sigma * randn(layer_sizes(i), layer_sizes(i - 1) + 1);
                
            elseif init_options.distribution == "uniform"
               
                W{i - 1} = (rand(layer_sizes(i), layer_sizes(i - 1) + 1) - 0.5) * 2 * sqrt(6) / sqrt(n_in); 
            end
        else
            if init_options.name == "lecun"
    
                if init_options.distribution == "gauss"
                    sigma = 1 / sqrt(n_in);
                    
                    W{i - 1} = sigma * randn(layer_sizes(i), layer_sizes(i - 1) + 1);
                
                elseif init_options.distribution == "uniform"
                   
                    W{i - 1} = (rand(layer_sizes(i), layer_sizes(i - 1) + 1) - 0.5) * 2 * sqrt(3) / sqrt(n_in); 
                end
    
            elseif init_options.name == "xavier"
                
                if init_options.distribution == "gauss"
                    sigma = sqrt(2 / (n_in + n_out));
                    
                    W{i - 1} = sigma * randn(layer_sizes(i), layer_sizes(i - 1) + 1);
                
                elseif init_options.distribution == "uniform"
                    
                    W{i - 1} = (rand(layer_sizes(i), layer_sizes(i - 1) + 1) - 0.5) * 2 * sqrt(6 / (n_in + n_out));
                end
            end
        end
    end
end

