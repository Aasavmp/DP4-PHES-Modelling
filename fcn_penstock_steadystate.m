function q = fcn_penstock_steadystate(Pump_pressure_gain, potential_gain, penstock_diameter, penstock_length, density, penstock_roughness, add_loss_factor, q, fluid_viscosity)

    penstock_area = (pi() * penstock_diameter^2) /4;

    if q ~= 0
        % This needs to be put into a while loop so that the speed settles
        % to a fixed value
        C_f = solve_wall_f(q, penstock_diameter, penstock_roughness, density, fluid_viscosity)/(2*penstock_diameter*density);
        
        % Left C_f as 1 for now to test model
        C_f = 1;

        q_squared = ((penstock_area^2)/((C_f*penstock_length)+(add_loss_factor/(2*density))))*(Pump_pressure_gain+potential_gain);
    
    else
        q_squared = 0;
    end

    if q_squared > 0
        q = sqrt(q_squared); 
    else
        q = 0;
    end