function q = fcn_penstock_steadystate(upper_height, lower_height, penstock_diameter, penstock_length, density, g, penstock_roughness, valve_loss_fact)

    penstock_area = (pi() * penstock_diameter^2) /4;

    potential_gain = density * g * (upper_height - lower_height);

%     C_f = solve_wall_f(penstock_diameter, penstock_roughness, penstock_length)/(2*penstock_diameter*density);
    C_f = 1;

    q_squared = (potential_gain * penstock_area^2)/((penstock_length*C_f) + (valve_loss_fact/(2*density)));

    if q_squared > 0
        q = sqrt(q_squared);
    else
        q = 0;
    end