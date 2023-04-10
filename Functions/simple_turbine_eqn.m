function power_output = simple_turbine_eqn(q, g, u_res_height, l_res_height, efficiency)
    power_output = q*g*(u_res_height-l_res_height)*efficiency;
end