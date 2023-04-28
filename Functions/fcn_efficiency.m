function efficiency = fcn_efficiency(l_res_height, u_res_height, q, P_t, g)
    h_diff = u_res_height - l_res_height;
    efficiency = P_t/(h_diff*q*g);
end