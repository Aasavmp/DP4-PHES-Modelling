function q = fcn_penstock_steadystate(pressure_gain, penstock_diameter, penstock_length, density, penstock_roughness, add_loss_factor, fluid_viscosity)

    penstock_area = (pi() * penstock_diameter^2) / 4;

    q_diff = inf;
    q_res = 1e-10;
    q_0 = 0.00001;

    iter = 1;

    b_useHaaland = 0;

    while q_diff > q_res
        % Solve wall friction first 
        f = solve_wall_f(q_0, penstock_diameter, penstock_roughness, density, fluid_viscosity, b_useHaaland);
        C_f = f/(2*penstock_diameter*density);

        % Solve for q
        q_squared = ((penstock_area^2)/((C_f*penstock_length)+(add_loss_factor/(2*density))))*(pressure_gain);

        if q_squared > 0
            q_1 = sqrt(q_squared); 
        else
            q_1 = 0;
        end
    
        q_diff = abs(q_1 - q_0);

        q_0 = q_1;

        iter = iter + 1;
    end

    q = q_0;