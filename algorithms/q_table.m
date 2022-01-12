function duty = q_table(I_measured, V_measured, Voc, Isc, deg_threshold, wp, wn, n_V, n_I, actions, alpha, gamma, exploration_factor_init)
    
    % normalize
    I = I_measured / Isc;
    V = V_measured / Voc;
    
    % init
    persistent I_old V_old deg_old duty_old Q_table action_old exploration_factor
    if isempty(I_old)
        I_old = 0;
        V_old = 0;
        deg_old = 2;
        duty_old = 0;
        exploration_factor = exploration_factor_init;

        Q_table = zeros(n_V, n_I, 2, length(actions));
        
        % pick the middle action as an initialization
        if mod(length(actions), 2) == 0
            action_old = length(actions) / 2;
        else
            action_old = (length(actions) + 1) / 2;
        end
    end
    
    % calc changes
    dI = I - I_old;
    dV = V - V_old;
    dP = V * I - V_old * I_old;
    
    % see where deg is (are we close to the MPP or not?)
    deg = atan(dI / dV) + atan(I / V);
    
    if abs(deg) > deg_threshold
        deg = 2;    % far form the MPP
    else
        deg = 1;    % close to the MPP
    end
    
    % calc reward
    if dP > 0
        R = wp * dP;
    else
        R = wn * dP;
    end
    
    V_index = round(interp1([0,1], [1, n_V], V));
    V_old_index = round(interp1([0,1], [1, n_V], V_old));

    I_index = round(interp1([0,1], [1, n_I], I));
    I_old_index = round(interp1([0,1], [1, n_I], I_old));
    
    % update Q
    Q_table(V_old_index, I_old_index, deg_old, action_old) = (1 - alpha) * ... 
    Q_table(V_old_index, I_old_index, deg_old, action_old) + ...
        alpha * (R + gamma * max(Q_table(V_index, I_index, deg, :)));

    
    % exploration VS exploitation
    if rand < exploration_factor
        action_old = randi(length(actions));
    else
        [~, argmax] = max(Q_table(V_index, I_index, deg, :));
        action_old = argmax;
    end

    duty = duty_old + actions(action_old);

    if duty > 1 || duty < 0
        duty = duty_old;
    end

    % update old values
    V_old = V;
    I_old = I;
    deg_old = deg;
    duty_old = duty;
    exploration_factor = exploration_factor * exploration_factor_init;
end

