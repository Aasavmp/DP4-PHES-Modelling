function q = fcn_pump_steady_state(pump_power_start, pump_power_end, upper_height, lower_height, penstock_diameter, penstock_length, density, g, penstock_roughness, valve_loss_factor)

    penstock_area = (pi() * penstock_diameter^2) /4;

    potential_gain = density * g * (upper_height - lower_height);

    Pump_pressure_gain = pump_power_start-pump_power_end;

    %     C_f = solve_wall_f(penstock_diameter, penstock_roughness, penstock_length)/(2*penstock_diameter*density);
    C_f = 1;

    q_squared = ((penstock_area^2)/((C_f*penstock_length)+(valve_loss_factor/(2*density))))*(Pump_pressure_gain-potential_gain);

    if q_squared > 0
        q = sqrt(q_squared); 
    else
        q = 0;
    end