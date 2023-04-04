function [V_upper_res, u_res_height] = fcn_vol_upper(V_upper_res, q, density, res_length, res_width, u_res_alt)
    % Function that takes the mass flow rate, q and initial reservoir vol
    % Returns the current reservoir vol and height of fluid

    if q >= 0
        V_upper_res = V_upper_res - (q/density);
        if V_upper_res <= 0
            V_upper_res = V_upper_res + (q/density);
        end
    else
        V_upper_res = V_upper_res + (q/density);
    end

    u_res_height = u_res_alt + (V_upper_res/(res_length*res_width));

end