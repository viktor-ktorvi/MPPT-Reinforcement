classdef MultilayerPerceptron < handle
% A class that encapsulates an MLP
    
    properties
        layer_sizes
        activations
        d_activations
        W
        dEdy
        y
        dEdW
        lambda
        clip_flg
        clip_norm
        clip_val
    end
    
    methods
        function obj = MultilayerPerceptron(layer_sizes, activations, d_activations, sigma_weights, dEdy, lambda, clip_flg, clip_norm, clip_val)
            obj.layer_sizes = layer_sizes;
            obj.activations = activations;
            obj.d_activations = d_activations;

            obj.W = obj.init_weights(sigma_weights);
            
            obj.dEdy = dEdy;

            obj.y = cell(length(layer_sizes), 1);

            obj.dEdW = cell(length(obj.W), 1);

            obj.lambda = lambda;
            obj.clip_flg = clip_flg;
            obj.clip_norm = clip_norm;
            obj.clip_val = clip_val;

        end
        
        function W = init_weights(obj, sigma_weights)
            W = init_weights(obj.layer_sizes, sigma_weights);
        end
        
        function out = forward_pass(obj, x)
            obj.y = forward_pass(x, obj.W, obj.activations, obj.y);
            out = obj.y{end};
        end

        function obj = backward_pass(obj, target)
            obj.dEdW = backward_pass(target, obj.y, obj.W, obj.dEdy, obj.d_activations, obj.dEdW, obj.lambda);
            
            % gradient clipping
            if obj.clip_flg
                for k = 1:length(obj.dEdW)
                    if norm(obj.dEdW{k}) > obj.clip_norm || isnan(norm(obj.dEdW{k}))

                        obj.dEdW{k}(obj.dEdW{k} > obj.clip_val | isnan(obj.dEdW{k})) = obj.clip_val;
                        obj.dEdW{k}(obj.dEdW{k} <  -obj.clip_val | isnan(obj.dEdW{k})) = -obj.clip_val;

                    end
                end
            end
        end

        function obj = update_weights(obj, learning_rate)
            obj.W = update_weights(obj.W, obj.dEdW, learning_rate);
        end

        function error = train(obj, X, labels, batch_size, learning_rate, loss)
            error = 0;
            for j = 1:batch_size:size(labels, 2)
                range = j:min(j + batch_size - 1, size(X, 2));
        
                % forward pass        
                x = X(:, range);
                out = obj.forward_pass(x);
                
                % backward pass
                target = labels(:, range);
                obj.backward_pass(target);
        
        
                % weight update
                obj.update_weights(learning_rate);
                
                error = error + sum(loss(target, out));
            
            end

        end
    end
end

