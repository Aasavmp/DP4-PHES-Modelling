function [useful_torque, useful_work, shock_loss, whirl_loss, friction_loss, total_work] = turbine_eqn(q, density, alpha_1, R_1, R_2, A_1, A_2, beta_1, beta_2, omega, K_1, K_2, K_3)

    useful_torque = q*((R_1*(q/(density*A_1))*cot(alpha_1)) - R_2*((omega*R_2)+((q/(density*A_2))*cot(beta_2))));

    useful_work = useful_torque * omega;

    cot_gamma_1 = cot(alpha_1) - (omega*R_1*density*A_1)/q;
    shock_loss = K_1*(q/density)*(cot_gamma_1-cot(beta_1))^2;

    cot_alpha_2 = cot(beta_2) + (omega*R_2*density*A_2)/q;
    whirl_loss = K_2*(q/density)*(cot_alpha_2^2);

    friction_loss = K_3*(q/density)^2;

    total_work = useful_work + shock_loss + whirl_loss + friction_loss;