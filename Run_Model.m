clear all
clc

%% Global
% Fluid Density
density = 997; % kg/m^3

% Gravitational Accel.
g = 9.81; % m/s^2

% Grid Frequency
grid_frq = 50;

%% Upper Res
% Initial Res. Volume
V_init = 27; % m^3

% Res. Width
u_res_width = 3; % m

% Res. Length
u_res_length = 3; % m

% Res. Altitude (at base)
u_res_alt = 200; % m above sea level

%% Penstock 1
% Diameter of Penstock Pipe
penstock_diameter_1 = 1; % m

% Length of Penstock
penstock_length_1 = 20; % m

% Penstock Roughness
penstock_roughness = 1e-5; % m

% Valve Loss Factor (during generation)
valve_loss_factor_gen = 1; 

% Valve Loss Factor (during pumping)
valve_loss_factor_pump = 1;

%% Turbine
% Inlet Guide Vane Angle
alpha_1 = 45; % deg

% Inlet Radius of Runner
R_1 = 1; % m

% Outlet Radius of Runner
R_2 = 0.5; % m

% Inlet Cross-sectional Area
A_1 = pi() * R_1^2; % m^2

% Outlet Cross-sectional Area
A_2 = pi() * R_2^2; % m^2

% Rotor Inlet Blade Angle wrt outer rotor perpendicular direction of vel.
beta_1 = 60; % deg

% Outlet Blade Angle wrt inner rotor perpendicular direction of vel.
beta_2 = 150; % deg

% Rotational Speed required
omega = 2*pi()*grid_frq; % rad/s

% Shock Loss Factor
K_1 = 0;

% Whirl Loss Factor
K_2 = 0;

% Friction Loss Factor
K_3 = 0;

%% Lower Res
% Res. Width
l_res_width = 3; % m

% Res. Length
l_res_length = 3; % m

% Res. Altitude (as base)
l_res_alt = 100; % m (above sea level)

%% Pump
% Power of Pump at base
pump_power_start_1 = 0;

%% Run Sim
sim("PHES_Model.slx")

