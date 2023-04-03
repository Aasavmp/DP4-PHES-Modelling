function f = solve_wall_f(penstock_diameter, penstock_roughness, velocity, desnity, fluid_viscosity)
% Function to solve the wall friction factor

    % Reynolds Number
    Re = (desnity*velocity*penstock_diameter)/fluid_viscosity;

%     1/sqrt(x) + 2*log(((penstock_roughness/penstock_diameter)/3.7) + (2.51/(Re*sqrt(x)))) = 0