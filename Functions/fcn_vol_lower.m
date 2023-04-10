function [V_lower_res, l_res_height] = fcn_vol_lower(V_lower_res, q, density, res_length, res_width, l_res_alt, max_l_res_vol, min_l_res_vol)

    if V_lower_res <= max_l_res_vol && V_lower_res >= min_l_res_vol
        V_lower_res = V_lower_res + (q/density);
        if V_lower_res >= max_l_res_vol
            V_lower_res = max_l_res_vol;
        end
        if V_lower_res <= min_l_res_vol
            V_lower_res = min_l_res_vol;
        end
    end

    l_res_height = l_res_alt + V_lower_res/(res_length*res_width);