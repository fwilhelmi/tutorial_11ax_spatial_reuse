%%% ***********************************************************************
%%% *                                                                     *
%%% *             Spatial Reuse Operation in IEEE 802.11ax:               *
%%% *          Analysis, Challenges and Research Opportunities            *
%%% *                                                                     *
%%% * Submission to IEEE Surveys & Tutorials                              *
%%% *                                                                     *
%%% * Authors:                                                            *
%%% *   - Francesc Wilhelmi (francisco.wilhelmi@upf.edu)                  *
%%% *   - Sergio Barrachina-Muñoz  (sergio.barrachina@upf.edu)            *
%%% *   - Boris Bellalta (boris.bellalta@upf.edu)                         *
%%% *   - Cristina Cano (ccanobs@uoc.edu)                                 *
%%% * 	- Ioannis Selinis (ioannis.selinis@surrey.ac.uk)                  *
%%% *                                                                     *
%%% * Copyright (C) 2019-2024, and GNU GPLd, by Francesc Wilhelmi         *
%%% *                                                                     *
%%% * Repository:                                                         *
%%% *  https://github.com/fwilhelmi/tutorial_11ax_spatial_reuse           *
%%% ***********************************************************************

%% PART 1 - Generate the data
clear
clc

% Generate constants 
constants_sfctmn_framework
% Set specific configurations
configuration_system_sim_1           

% Set the OBSS_PD and tx power levels to be used by WLAN C
cca_levels_srg = -82:1:-62;
cca_levels_non_srg = -82:1:-62;
tx_power_default = 20;

% Load and adapt results from Komondor
file_name = "output_komondor/script_output_toy_scenario_2_new.txt";  % File containing the data to be plotted
delimiterIn = ';';                  % Delimiter used in the input file
headerlinesIn = 0;                  % Lines belonging to headers
%   * Import the data from the output file
A = importdata(file_name,delimiterIn,headerlinesIn);
%   * Flip data to follow the order [-82 to -62]
throughput_wlan_a_komondor = fliplr(A.data(:, 1)');
throughput_wlan_b_komondor = fliplr(A.data(:, 2)');
throughput_wlan_c_komondor = fliplr(A.data(:, 3)');

% Reshape array from 1D to 2D (we have 50 scenarios, each row is an independent scenario) 
throughput_wlan_a_komondor = reshape(throughput_wlan_a_komondor, [100, size(cca_levels_non_srg,2)*size(cca_levels_srg,2)]);
throughput_wlan_b_komondor = reshape(throughput_wlan_b_komondor, [100, size(cca_levels_non_srg,2)*size(cca_levels_srg,2)]);
throughput_wlan_c_komondor = reshape(throughput_wlan_c_komondor, [100, size(cca_levels_non_srg,2)*size(cca_levels_srg,2)]);

% Compute the average
mean_tpt_per_cca_value_wlan_a = mean(throughput_wlan_a_komondor);
mean_tpt_per_cca_value_wlan_b = mean(throughput_wlan_b_komondor);
mean_tpt_per_cca_value_wlan_c = mean(throughput_wlan_c_komondor);

% Reshape the array to 21 x 21
mean_tpt_per_cca_value_wlan_a = reshape(mean_tpt_per_cca_value_wlan_a, [size(cca_levels_non_srg,2), size(cca_levels_srg,2)]);
mean_tpt_per_cca_value_wlan_b = reshape(mean_tpt_per_cca_value_wlan_b, [size(cca_levels_non_srg,2), size(cca_levels_srg,2)]);
mean_tpt_per_cca_value_wlan_c = reshape(mean_tpt_per_cca_value_wlan_c, [size(cca_levels_non_srg,2), size(cca_levels_srg,2)]);

min_tpt_per_tpc_and_cca_value = zeros(size(cca_levels_srg,2), size(cca_levels_non_srg,2));
for i = 1 : size(cca_levels_srg,2)
    for j = 1 : size(cca_levels_non_srg,2)
        min_tpt_per_tpc_and_cca_value(i,j) = min([mean_tpt_per_cca_value_wlan_a(i,j) ...
            mean_tpt_per_cca_value_wlan_b(i,j), mean_tpt_per_cca_value_wlan_c(i,j)]);
    end
end

% Compute the RMSE between the results from SFCTMN and Komondor
% 2 - Load the results of SIM_1_2 (CTMNs)
load('output_sfctmn/SIM_1_2.mat')

% WLAN A
E1 = ind_tpt_per_tpc_and_cca_value_w1-mean_tpt_per_cca_value_wlan_a;
SQE1  = E1.^2;
MSE1  = mean(SQE1(:));
RMSE1 = sqrt(MSE1);
% WLAN A
E2 = ind_tpt_per_tpc_and_cca_value_w2-mean_tpt_per_cca_value_wlan_b;
SQE2  = E2.^2;
MSE2  = mean(SQE2(:));
RMSE2 = sqrt(MSE2);
% WLAN A
E3 = ind_tpt_per_tpc_and_cca_value_w3-mean_tpt_per_cca_value_wlan_c;
SQE3  = E3.^2;
MSE3  = mean(SQE3(:));
RMSE3 = sqrt(MSE3);

disp('RMSE of the throughput of each WLAN:')
disp(['    - WLAN_A ' num2str(RMSE1)])
disp(['    - WLAN_B ' num2str(RMSE2)])
disp(['    - WLAN_C ' num2str(RMSE3)])

%% PART 2 - Plot the results
% 1 - Set font type
set(0,'defaultUicontrolFontName','Helvetica');
set(0,'defaultUitableFontName','Helvetica');
set(0,'defaultAxesFontName','Helvetica');
set(0,'defaultTextFontName','Helvetica');
set(0,'defaultUipanelFontName','Helvetica');


% PLOT THE INDIVIDUAL THROUGHPUTS (ALL TOGETHER) - OUTPUT SFCTMN
fig = figure('pos',[450 400 700 500]);
title('SFCTMN')
axes;
axis([1 20 30 70]);
subplot(2,2,1) % upper subplot 
surf(ind_tpt_per_tpc_and_cca_value_w1)
hold on
set(gca, 'FontSize', 18)
xlabel('SRG OBSS PD (dBm)','fontsize', 15)
ylabel('non-SRG OBSS PD (dBm)','fontsize', 15)
zlabel('\Gamma_A (Mbps)','fontsize', 16)
axis([0, size(cca_levels_srg, 2), 1, size(cca_levels_srg, 2), 0, 53])
xticks(1:5:size(cca_levels_srg, 2))
xticklabels(cca_levels_srg(1:5:size(cca_levels_srg,2)))
yticks(1:5:size(cca_levels_srg, 2))
yticklabels(cca_levels_srg(1:5:size(cca_levels_srg,2)))
individual_legacy_tpt = ind_tpt_per_tpc_and_cca_value_w1(cca_levels_srg == -82, cca_levels_non_srg == -82) * ... 
    ones(size(cca_levels_srg,2), size(cca_levels_srg,2));
surf(individual_legacy_tpt, 'FaceAlpha', 0.1, 'EdgeColor', 'r', 'LineWidth', 1.0);
grid on
grid minor
subplot(2,2,2) % upper subplot 
surf(ind_tpt_per_tpc_and_cca_value_w2)
hold on
set(gca, 'FontSize', 18)
xlabel('SRG OBSS PD (dBm)','fontsize', 15)
ylabel('non-SRG OBSS PD (dBm)','fontsize', 15)
zlabel('\Gamma_B (Mbps)','fontsize', 16)
axis([0, size(cca_levels_srg, 2), 1, size(cca_levels_srg, 2), 0, 53])
xticks(1:5:size(cca_levels_srg, 2))
xticklabels(cca_levels_srg(1:5:size(cca_levels_srg,2)))
yticks(1:5:size(cca_levels_srg, 2))
yticklabels(cca_levels_srg(1:5:size(cca_levels_srg,2)))
individual_legacy_tpt = ind_tpt_per_tpc_and_cca_value_w2(cca_levels_srg == -82, cca_levels_non_srg == -82) * ... 
    ones(size(cca_levels_srg,2), size(cca_levels_srg,2));
surf(individual_legacy_tpt, 'FaceAlpha', 0.1, 'EdgeColor', 'r', 'LineWidth', 1.0);
grid on
grid minor
% Throughput WLAN C
subplot(2,2,3) % upper subplot 
surf(ind_tpt_per_tpc_and_cca_value_w3)
hold on
set(gca, 'FontSize', 18)
xlabel('SRG OBSS PD (dBm)','fontsize', 15)
ylabel('non-SRG OBSS PD (dBm)','fontsize', 15)
zlabel('\Gamma_C (Mbps)','fontsize', 16)
axis([0, size(cca_levels_srg, 2), 1, size(cca_levels_srg, 2), 0, 53])
xticks(1:5:size(cca_levels_srg, 2))
xticklabels(cca_levels_srg(1:5:size(cca_levels_srg,2)))
yticks(1:5:size(cca_levels_srg, 2))
yticklabels(cca_levels_srg(1:5:size(cca_levels_srg,2)))
individual_legacy_tpt = ind_tpt_per_tpc_and_cca_value_w3(cca_levels_srg == -82, cca_levels_non_srg == -82) * ... 
    ones(size(cca_levels_srg,2), size(cca_levels_srg,2));
surf(individual_legacy_tpt, 'FaceAlpha', 0.1, 'EdgeColor', 'r', 'LineWidth', 1.0);
grid on
grid minor
% Max-min throughput
subplot(2,2,4) % upper subplot 
surf(min_tpt_per_tpc_and_cca_value)
hold on
set(gca, 'FontSize', 18)
xlabel('SRG OBSS PD (dBm)','fontsize', 15)
ylabel('non-SRG OBSS PD (dBm)','fontsize', 15)
zlabel('min(\Gamma) (Mbps)','fontsize', 16)
axis([0, size(cca_levels_srg, 2), 1, size(cca_levels_srg, 2), 0, 53])
xticks(1:5:size(cca_levels_srg, 2))
xticklabels(cca_levels_srg(1:5:size(cca_levels_srg,2)))
yticks(1:5:size(cca_levels_srg, 2))
yticklabels(cca_levels_srg(1:5:size(cca_levels_srg,2)))
grid on
grid minor
% Save Figure
save_figure( fig, 'SIM_1_2_sfctmn', './Simulations/Output/Toy_scenario_2/' )

% PLOT THE INDIVIDUAL THROUGHPUTS (ALL TOGETHER) - OUTPUT Komondor
fig = figure('pos',[450 400 700 500]);
title('Komondor')
axes;
axis([1 20 30 70]);
subplot(2,2,1) % upper subplot 
surf(mean_tpt_per_cca_value_wlan_a)
hold on
set(gca, 'FontSize', 18)
xlabel('SRG OBSS PD (dBm)','fontsize', 15)
ylabel('non-SRG OBSS PD (dBm)','fontsize', 15)
zlabel('\Gamma_A (Mbps)','fontsize', 16)
axis([0, size(cca_levels_srg, 2), 1, size(cca_levels_srg, 2), 0, 53])
xticks(1:5:size(cca_levels_srg, 2))
xticklabels(cca_levels_srg(1:5:size(cca_levels_srg,2)))
yticks(1:5:size(cca_levels_srg, 2))
yticklabels(cca_levels_srg(1:5:size(cca_levels_srg,2)))
individual_legacy_tpt = mean_tpt_per_cca_value_wlan_a(cca_levels_srg == -82, cca_levels_non_srg == -82) * ... 
    ones(size(cca_levels_srg,2), size(cca_levels_srg,2));
surf(individual_legacy_tpt, 'FaceAlpha', 0.1, 'EdgeColor', 'r', 'LineWidth', 1.0);
grid on
grid minor
subplot(2,2,2) % upper subplot 
surf(mean_tpt_per_cca_value_wlan_b)
hold on
set(gca, 'FontSize', 18)
xlabel('SRG OBSS PD (dBm)','fontsize', 15)
ylabel('non-SRG OBSS PD (dBm)','fontsize', 15)
zlabel('\Gamma_B (Mbps)','fontsize', 16)
axis([0, size(cca_levels_srg, 2), 1, size(cca_levels_srg, 2), 0, 53])
xticks(1:5:size(cca_levels_srg, 2))
xticklabels(cca_levels_srg(1:5:size(cca_levels_srg,2)))
yticks(1:5:size(cca_levels_srg, 2))
yticklabels(cca_levels_srg(1:5:size(cca_levels_srg,2)))
individual_legacy_tpt = mean_tpt_per_cca_value_wlan_b(cca_levels_srg == -82, cca_levels_non_srg == -82) * ... 
    ones(size(cca_levels_srg,2), size(cca_levels_srg,2));
surf(individual_legacy_tpt, 'FaceAlpha', 0.1, 'EdgeColor', 'r', 'LineWidth', 1.0);
grid on
grid minor
% Throughput WLAN C
subplot(2,2,3) % upper subplot 
surf(mean_tpt_per_cca_value_wlan_c)
hold on
set(gca, 'FontSize', 18)
xlabel('SRG OBSS PD (dBm)','fontsize', 15)
ylabel('non-SRG OBSS PD (dBm)','fontsize', 15)
zlabel('\Gamma_C (Mbps)','fontsize', 16)
axis([0, size(cca_levels_srg, 2), 1, size(cca_levels_srg, 2), 0, 53])
xticks(1:5:size(cca_levels_srg, 2))
xticklabels(cca_levels_srg(1:5:size(cca_levels_srg,2)))
yticks(1:5:size(cca_levels_srg, 2))
yticklabels(cca_levels_srg(1:5:size(cca_levels_srg,2)))
individual_legacy_tpt = mean_tpt_per_cca_value_wlan_c(cca_levels_srg == -82, cca_levels_non_srg == -82) * ... 
    ones(size(cca_levels_srg,2), size(cca_levels_srg,2));
surf(individual_legacy_tpt, 'FaceAlpha', 0.1, 'EdgeColor', 'r', 'LineWidth', 1.0);
grid on
grid minor
% Max-min throughput
subplot(2,2,4) % upper subplot 
surf(min_tpt_per_tpc_and_cca_value)
hold on
set(gca, 'FontSize', 18)
xlabel('SRG OBSS PD (dBm)','fontsize', 15)
ylabel('non-SRG OBSS PD (dBm)','fontsize', 15)
zlabel('min(\Gamma) (Mbps)','fontsize', 16)
axis([0, size(cca_levels_srg, 2), 1, size(cca_levels_srg, 2), 0, 53])
xticks(1:5:size(cca_levels_srg, 2))
xticklabels(cca_levels_srg(1:5:size(cca_levels_srg,2)))
yticks(1:5:size(cca_levels_srg, 2))
yticklabels(cca_levels_srg(1:5:size(cca_levels_srg,2)))
individual_legacy_tpt = mean_tpt_per_cca_value_wlan_c(cca_levels_srg == -82, cca_levels_non_srg == -82) * ... 
    ones(size(cca_levels_srg,2), size(cca_levels_srg,2));
surf(individual_legacy_tpt, 'FaceAlpha', 0.1, 'EdgeColor', 'r', 'LineWidth', 1.0);
grid on
grid minor
% Save Figure
save_figure( fig, 'SIM_1_2_komondor', './Simulations/Output/Toy_scenario_2/' )