function [V_upper_res, u_res_height] = fcn_vol_upper(V_upper_res, q, density, res_length, res_width, u_res_alt, max_u_res_vol, min_u_res_vol)
    % Function that takes the mass flow rate, q and initial reservoir vol
    % Returns the current reservoir vol and height of fluid

    if V_upper_res >= min_u_res_vol && V_upper_res <= max_u_res_vol
        V_upper_res = V_upper_res - (q/density);
        if V_upper_res <= min_u_res_vol
            V_upper_res = min_u_res_vol;
        end
        if V_upper_res >= max_u_res_vol
            V_upper_res = max_u_res_vol;
        end
    end

    u_res_height = u_res_alt + (V_upper_res/(res_length*res_width));

end