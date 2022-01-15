function duty = incr_cond(I, V, duty_step)
    
    persistent I_old V_old duty_old
    if isempty(I_old)
        I_old = 0;
        V_old = 0;
        duty_old = 0;
    end

    % differences
    dV = V - V_old;
    dI = I - I_old;

    if dV == 0
        if dI == 0
            duty = duty_old;
        elseif dI > 0
            duty = duty_old - duty_step;
        else
            duty = duty_old + duty_step;
        end
    else
        % there should, maybe, be a check to see if V is 0, just to avoid 
        % dividing with 0
        if dI / dV == I / V     
            duty = duty_old;
        elseif dI / dV > - I / V
            duty = duty_old + duty_step;
        else
            duty = duty_old - duty_step;
        end
    end

    % make sure the duty cycle is between 0 and 1
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

