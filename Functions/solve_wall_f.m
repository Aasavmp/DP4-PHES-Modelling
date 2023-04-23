function f = solve_wall_f(q, penstock_diameter, penstock_roughness, density, fluid_viscosity, b_useHaaland)
% Function to solve the wall friction factor

    % Get velocity from q
    velocity = (4*q)/(density*pi()*(penstock_diameter^2));

    % Reynolds Number
    Re = (density*velocity*penstock_diameter)/fluid_viscosity;

    % function needed to be solved
    y = @(x) 1/sqrt(x) + 2*log(((penstock_roughness/penstock_diameter)/3.7) + (2.51/(Re*sqrt(x))));

    % Alternative friction
    if b_useHaaland
        y = @(x) 1/sqrt(x) + 3.6*log(((penstock_roughness/penstock_diameter)/3.71)^1.11 + (6.9/(Re)));
    end

    % Set the interval [a, b] and the tolerance (epsilon)
    a = 0.0000000001; % Example value
    b = 100000000000; % Example value
    epsilon = 1e-10; % Example value
    
    % Check that the function changes sign on the interval [a, b]
    if y(a) * y(b) >= 0
        error('The function does not change sign on the interval [a, b]. Choose a different interval.')
    end
    
    % Implement the bisection algorithm
    while abs(b-a) > epsilon
        c = (a + b) / 2;
        if y(c) == 0
            break
        elseif y(c) * y(a) < 0
            b = c;
        else
            a = c;
        end
    end
    
    % Display the result
    f = (a + b) / 2;