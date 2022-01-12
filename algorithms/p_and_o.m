% @p_and_o - a function implementing the Perturb and Observe MPPT algorithm
function duty = p_and_o(I, V, duty_step)
    
    persistent I_old V_old duty_old
    if isempty(I_old)
        I_old = 0;
        V_old = 0;
        duty_old = 0;
    end
    
    % differences
    dV = V - V_old;
    dP = V * I - V_old * I_old;

    duty = duty_old; % init duty in case dV = 0 or dP = 0, no change

    if dV > 0
        if dP > 0
            duty = duty_old + duty_step;
        else
            duty = duty_old - duty_step;
        end
    else
        if dP > 0
            duty = duty_old - duty_step;
        else
            duty = duty_old + duty_step;
        end
    end
    
    % make sure duty cycle between 0 and 1
    if duty <= 0
        duty = duty_step;
    end

    if duty >= 1
        duty = 1 - duty_step;
    end
    
    % update the old values
    duty_old = duty;
    V_old = V;
    I_old = I;
end