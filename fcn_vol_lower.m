function [V_lower_res, l_res_height] = fcn_vol_lower(V_lower_res, q, density, res_length, res_width, l_res_alt)

    if q > 0
        V_lower_res = V_lower_res + (q/density);
    else
        V_lower_res = V_lower_res - (q/density);
    end

    l_res_height = l_res_alt + V_lower_res/(res_length*res_width);