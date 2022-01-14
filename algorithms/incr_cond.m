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

    % I think that the equality checks are useless but the flowcharts say
    % so, they can't hurt
    
    % doesn't work
    if dV == 0
        if dI == 0
            duty = duty_old;
        elseif dI > 0
            duty = duty_old - duty_step;
        else
            duty = duty_old + duty_step;
        end
    else
        if dI / dV == I / V
            duty = duty_old;
        elseif dI / dV > - I / V
            duty = duty_old + duty_step;
        else
            duty = duty_old - duty_step;
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

