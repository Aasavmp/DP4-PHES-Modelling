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
V_init_u_res = 2600; % m^3

% Res. Width
u_res_width = 13; % m

% Res. Length
u_res_length = 60; % m

% Res. Altitude (at base)
u_res_alt = 202.3; % m above sea level

% Min. Res. Volume allowed
min_u_res_vol = 20;

% Max. Res. Vol. Allowed
max_u_res_vol = 2600;

%% Penstock 1
% Diameter of Penstock Pipe
penstock_diameter_1 = 0.8; % m

% Length of Penstock
penstock_length_1 = 380; % m

% Penstock Roughness
penstock_roughness = 1e-5; % m

% Valve Loss Factor (during generation)
add_loss_factor_gen = 1; 

% Valve Loss Factor (during pumping)
add_loss_factor_pump = 1;

% Fluid Viscosity
fluid_viscosity = 1e-3; % Pa s

%% Turbine
% Inlet Guide Vane Angle
alpha_1 = 12; % deg

% Inlet Radius of Runner
R_1 = 1; % m

% Outlet Radius of Runner
R_2 = 0.5; % m

% Inlet Cross-sectional Area
A_1 = (pi() * penstock_diameter_1^2) / 4; % m^2

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

% Turbine Efficiency for simple model
turbine_efficiency = 0.9;

%% Lower Res
% Initial Res. Volume
V_init_l_res = 20;

% Res. Width
l_res_width = 13; % m

% Res. Length
l_res_length = 60; % m

% Res. Altitude (as base)
l_res_alt = 126.3; % m (above sea level)

% Min. Res. Volume allowed
min_l_res_vol = 20;

% Max. Res. Vol. Allowed
max_l_res_vol = 2600;


%% Pump
% Power of Pump at base
pump_power_start_1 = 1027000;

%% Run Sim
% sim("PHES_Model_v1.slx")

