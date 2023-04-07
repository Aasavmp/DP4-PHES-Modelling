penstock_roughness = 1e-5;
penstock_diameter = 1;
Re = 1.7740e+05;
% Re = 30;

y = @(x) 1/sqrt(x) + 2*log(((penstock_roughness/penstock_diameter)/3.7) + (2.51/(Re*sqrt(x))));

f = fzero(y, 0.3)

% Define the function
y = @(x) 1/sqrt(x) + 2.*log(((penstock_roughness./penstock_diameter)./3.7) + (2.51/(Re.*sqrt(x))));

%% Newton Raphson
% Define the initial guess
x0 = 1;

% Set a tolerance level for the error
tol = 1e-6;

% Set a maximum number of iterations
maxiter = 1000;

% Initialize the iteration counter and error
iter = 0;
err = inf;

% Iterate until the error is below the tolerance level or the maximum number of iterations is reached
while err > tol && iter < maxiter
    % Calculate the function and its derivative at the current guess
    fx = y(x0);
    fxprime = -1/(2*x0^(3/2)) - (2*2.51*Re^(-1/2))/((penstock_roughness/penstock_diameter)/3.7 + (2.51/(Re*sqrt(x0)))^2);
    
    % Update the guess using the Newton-Raphson formula
    x1 = x0 - fx/fxprime;
    
    % Calculate the error between the old and new guesses
    err = abs(x1 - x0);
    
    % Update the iteration counter and the guess
    iter = iter + 1;
    x0 = x1;
end

% Output the result
disp(['The root is approximately ' num2str(x0) ' after ' num2str(iter) ' iterations']);

%% Bisection Method
% Set the interval [a, b] and the tolerance (epsilon)
a = 0.000000001; % Example value
b = 100; % Example value
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
root = (a + b) / 2;
fprintf('The root is approximately %f.\n', root);