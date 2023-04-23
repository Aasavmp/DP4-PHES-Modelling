%% Model 1 Validation
clear all
clc

b_find_f = 0;
b_power_curves = 0;
b_sens_study = 1;

%% Global
% Fluid Density
density = 997; % kg/m^3
density = 2500;

% Gravitational Accel.
g = 9.81; % m/s^2

% Grid Frequency
grid_frq = 50;

Set_Vol = 2600;

%% Upper Res
% Initial Res. Volume
V_init_u_res = Set_Vol; % m^3

% Res. Width
u_res_width = 13; % m

% Res. Length
u_res_length = 60; % m

% Res. Altitude (at base)
u_res_alt = 202.3; % m above sea level

% Min. Res. Volume allowed
min_u_res_vol = 20;

% Max. Res. Vol. Allowed
max_u_res_vol = Set_Vol;

%% Penstock 1
% Diameter of Penstock Pipe
penstock_diameter_1 = 0.8; % m

% Length of Penstock
penstock_length_1 = 380; % m

% Penstock Roughness
penstock_roughness = 1e-5; % m

% Valve Loss Factor (during generation)
pipe_entry_loss = 0.18;
gate_valve_loss_factor = 0.2; % Fully open: 0.2, Three-Quarters Open: 1.15, Half open: 5.6, Quarter open: 24
fortyfive_bend_loss = 0.4;
bottom_junction_loss = 1.8;
add_loss_factor_gen = pipe_entry_loss + gate_valve_loss_factor + 2*fortyfive_bend_loss + bottom_junction_loss;
% add_loss_factor_gen = 0;

% Valve Loss Factor (during pumping)
add_loss_factor_pump = 2*fortyfive_bend_loss + gate_valve_loss_factor;

% Fluid Viscosity
fluid_viscosity = 1e-3; % Pa s

% Fluid height in pipe
fluid_h_inPen = 0.75 .* penstock_diameter_1;

% Friction Factor override leave empty if no override wanted
friction_factor = 0;

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
turbine_efficiency = 0.69;
% turbine_efficiency = 1;

%% Lower Res
% Initial Res. Volume
V_init_l_res = 20;

% Res. Width
l_res_width = 13; % m

% Res. Length
l_res_length = 60; % m

% Res. Altitude (as base)
l_res_alt = 126.3; % m (above sea level)
% l_res_alt = 0;

% Min. Res. Volume allowed
min_l_res_vol = 20;

% Max. Res. Vol. Allowed
max_l_res_vol = Set_Vol;


%% Pump
% Power of Pump at base
pump_power_start_1 = 1027000;

%% Finding correct friction factor
if b_find_f
    power_output = [];
    f_factor = [];
    volume_flow_rate = [];
    for iFriction = 0.1:0.1:5
        friction_factor = iFriction
        sim_output = sim("PHES_Model_v1.slx");
        power_output(end+1) = sim_output.power_output_kW.Data(end);
        volume_flow_rate(end+1) = sim_output.volume_flow_rate.Data(end);
        f_factor(end+1) = iFriction;
    end
    
    [vol_diff, f_loc_V] = min(abs(volume_flow_rate-0.39));
    [P_diff, f_loc_P] = min(abs(power_output-505));
    f_factor(f_loc_P)
    plot(f_factor, power_output)
    hold on
    yline(505, Label='505 kW')
    ylabel('Power Output [kW]')
    ylim([0, 1000])
    yyaxis("right")
    plot(f_factor, volume_flow_rate)
    yline(0.39, Label='0.39 m^3/s')
    ylim([0, 2])
    ylabel('Volume Flow Rate [m^3/s]')
    xlabel('Friction Factor, (\(f\)) [-]')
    
    xline(2.978, Label='Chosen Friction Factor = 2.978')
    xlim([1, 5])
    legend('Average Power Output', '', 'Average Volume Flow Rate', '', '')
    
    
    save('Friction Factors', "f_factor")
    save('Output Power kW', "power_output")
    save('Volume Flow Rate', "volume_flow_rate")
end

%% power vs Height curve
if b_power_curves
    power_output = {};
    mass_flow_rate = {};
    volume_flow_rate = {};
    c_height_diff = 0:10:380;
    for i_height = c_height_diff
        u_res_alt = i_height
        sim_output = sim("PHES_Model_v1.slx");
        power_output{end+1} = sim_output.power_output_kW.Data;
        mass_flow_rate{end+1} = sim_output.mass_flow_rate.Data;
        volume_flow_rate{end+1} = sim_output.volume_flow_rate.Data;
    end

    for i_height = 1:length(c_height_diff)
        d_power_output(:,i_height) = power_output{1, i_height}(2:end);
        avg_power_output(1,i_height) = mean(d_power_output(:,i_height));
        max_power_output(1,i_height) = abs(max(d_power_output(:,i_height))-avg_power_output(1,i_height));
        min_power_output(1,i_height) = abs(min(d_power_output(:,i_height))-avg_power_output(1,i_height));
        d_mass_flow_rate(:,i_height) = mass_flow_rate{1, i_height}(2:end);
        avg_mass_flow_rate(:,i_height) = mean(d_mass_flow_rate(:,i_height));
        d_volume_flow_rate(:,i_height) = volume_flow_rate{1, i_height}(2:end);
    end

    % Validated against P=pQHgn
    estimated_power_out = 0.39.*g.*turbine_efficiency.*density.*c_height_diff.*1e-3;
    output_error = abs(estimated_power_out - avg_power_output);
    plot(c_height_diff, avg_power_output)
%     errorbar(c_height_diff, avg_power_output - min_power_output, zeros(1, length(min_power_output)), min_power_output, 'v')
    hold on
%     errorbar(c_height_diff, avg_power_output, zeros(1, length(min_power_output)), max_power_output)
    plot(c_height_diff, estimated_power_out)
%     plot(c_height_diff, output_error)
    xlabel('Height Difference (\(\Delta h\)) [m]')
    ylabel('Power Output [kW]')

    percent_error = ((avg_power_output-estimated_power_out)./avg_power_output);
    yyaxis('right')
    plot(c_height_diff, smooth(percent_error))
    legend('Model 1 Power Output', 'Estimated Power', 'Percentage Error (\(%\))')


%     plot(76.5, 505, 'x', 'MarkerSize',10, 'LineWidth',3, 'Color', 'r')

    save('Output Power kW', "power_output")
    save('Volume Flow Rate', "volume_flow_rate")
    save('Mass Flow Rate', "mass_flow_rate")

end

%% Sensitivity Study
if b_sens_study
    power_output = {};
    mass_flow_rate = {};
    volume_flow_rate = {};
    height_difference = {};
%     c_height_diff = 0:1:100;
    counter = 1;
    c_prop_array = 0.95e-3:0.005e-3:1.05e-3;
    for i = 1
%         friction_factor = i;
        number = 1;
        for i_prop = c_prop_array
            fluid_viscosity = i_prop
            sim_output = sim("PHES_Model_v1.slx");
            power_output{counter, number} = sim_output.power_output_kW.Data;
            mass_flow_rate{counter, number} = sim_output.mass_flow_rate.Data;
            volume_flow_rate{counter, number} = sim_output.volume_flow_rate.Data;
            height_difference{counter, number} = sim_output.height_difference.Data;
            number = number+1;
        end
        counter = counter + 1;
    end

%     power_output_reduced = cellfun(@(c) c(c~=0), power_output, 'UniformOutput',0);
    iRow = 1;
    for i_prop = 1:length(c_prop_array)
        d_power_output(:,i_prop) = power_output{iRow, i_prop}(2:end);
        avg_power_output(1,i_prop) = mean(d_power_output(:,i_prop));
        max_power_output(1,i_prop) = abs(max(d_power_output(:,i_prop))-avg_power_output(1,i_prop));
        min_power_output(1,i_prop) = abs(min(d_power_output(:,i_prop))-avg_power_output(1,i_prop));
        d_mass_flow_rate(:,i_prop) = mass_flow_rate{iRow, i_prop}(2:end);
        avg_mass_flow_rate(:,i_prop) = mean(d_mass_flow_rate(:,i_prop));
        d_volume_flow_rate(:,i_prop) = volume_flow_rate{iRow, i_prop}(2:end);
        avg_volume_flow_rate(:, i_prop) = mean(d_volume_flow_rate(:,i_prop));
        d_height_diff(:,i_prop) = height_difference{iRow, i_prop}(2:end);
        avg_height_diff(:, i_prop) = mean(d_height_diff(:,i_prop));
%         inclination_angle(:, i_prop) = asin(avg_height_diff(:, i_prop)/c_prop_array(i_prop)) .* (180/pi());
    end

    sensitivity = 0;
    for i_sens = 2:length(c_prop_array)
        sensitivity(end + 1) = (avg_power_output(i_sens)-avg_power_output(i_sens-1))/(c_prop_array(i_sens)-c_prop_array(i_sens-1));
    end

%     save('Sensitivity', "sensitivity")
%     save('Power Output kW', "d_power_output")
%     save('Penstock Length', "c_prop_array")
%     save('Height Diff', "d_height_diff")
%     save('Inclination Angle', "inclination_angle")

     % Validated against P=pQHgn
    estimated_power_out = 0.39 .* g .* turbine_efficiency .* density .* c_prop_array .*1e-3;
%     output_error = -100.*(estimated_power_out - avg_power_output)./estimated_power_out;
%     plot(c_prop_array, avg_power_output + max_power_output)
%     errorbar(c_prop_array, avg_power_output, min_power_output, max_power_output)
    hold on
    plot(c_prop_array.*1000, smooth(avg_power_output))
    ylabel('Power Output [kW]')
%     yyaxis right
%     plot(c_prop_array, smooth(estimated_power_out))
    xlabel('Penstock Diameter [mm]')
    yyaxis right
    plot(c_prop_array.*1000, sensitivity./1000)
    ylabel('Sensitivity [kW/mm)]')
    legend('Average Power Output', 'Power Sensitivity')
%     xlim([])
%     plot(c_prop_array, avg_power_output - min_power_output)
    plot(c_prop_array, estimated_power_out)
%     errorbar(inclination_angle, avg_power_output, zeros(1, length(min_power_output)), max_power_output)
%     plot(c_prop_array, estimated_power_out)
    xlabel('Density [kg/m\(^3\)]')
    ylabel('Power Output [kW]')

%     percent_error = ((avg_power_output-estimated_power_out)./avg_power_output);
%     yyaxis('right')
%     plot(c_prop_array, inclination_angle)
%     plot(c_prop_array, sensitivity)
%     plot(c_prop_array, avg_mass_flow_rate)
%     ylim([0, 0.5])
%     ylabel('Power Sensitivity [kW/kg/m\(^3\)]')
    xlim([500, 4000])
    
%     plot(f_factor, power_output)
%     hold on
%     yline(505, Label='505 kW')
%     ylabel('Power Output [kW]')
%     ylim([0, 1000])
%     yyaxis("right")
%     plot(f_factor, volume_flow_rate)
%     yline(0.39, Label='0.39 m^3/s')
%     ylim([0, 2])
%     ylabel('Volume Flow Rate [m^3/s]')
%     xlabel('Friction Factor, (\(f\)) [-]')
%     xline(f_factor(1,f_loc_V), Label=['Chosen Friction Factor = ', num2str(f_factor(f_loc_P))])
%     
    
%     save('Friction Factors', "f_factor")
%     save('Output Power kW', "power_output")
%     save('Volume Flow Rate', "volume_flow_rate")
end
