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

%% PART 1 Load the results

% 1 - Generate constants 
constants_sfctmn_framework
configuration_system_sim_1        

% 2 - Load the results of SIM_1_1 (CTMNs)
load('output_sfctmn/SIM_1_1.mat')

% 3 - Load and adapt results from Komondor
file_name = "output_komondor/script_output_1_1_komondor_new.txt";  % File containing the data to be plotted
delimiterIn = ';';                  % Delimiter used in the input file
headerlinesIn = 0;                  % Lines belonging to headers
%   * Import the data from the output file
A = importdata(file_name,delimiterIn,headerlinesIn);
%   * Flip data to follow the order [-82 to -62]
throughput_wlan_a_komondor = fliplr(A.data(:, 1)');
throughput_wlan_b_komondor = fliplr(A.data(:, 2)');

%% PART 2 - Plot the results
% 1 - Set font type
set(0,'defaultUicontrolFontName','Helvetica');
set(0,'defaultUitableFontName','Helvetica');
set(0,'defaultAxesFontName','Helvetica');
set(0,'defaultTextFontName','Helvetica');
set(0,'defaultUipanelFontName','Helvetica');

% 2 - Plot average throughput
fig = figure('pos',[450 400 500 350]);
axes;
axis([1 20 30 70]);
%   * WLAN A (SFCTMN)
plot(1:size(obss_pd_levels,2), tpt_wlan_a, '--', 'LineWidth', 4.0, 'MarkerSize', 12)
set(gca, 'FontSize', 18)
xlabel('OBSS PD (dBm)','fontsize', 18)
ylabel('\Gamma (Mbps)','fontsize', 18)
xticks(1:2:size(obss_pd_levels, 2))
xticklabels(obss_pd_levels(1:2:size(obss_pd_levels,2)))
hold on
%   * WLAN A (Komondor)
plot(1:size(obss_pd_levels,2), throughput_wlan_a_komondor, 'bx', 'LineWidth', 3.0, 'MarkerSize', 12)
%   * WLAN B (SFCTMN)
plot(1:size(obss_pd_levels,2), tpt_wlan_b, 'g--', 'LineWidth', 3.0, 'MarkerSize', 12)
%   * WLAN B (Komondor)
plot(1:size(obss_pd_levels,2), throughput_wlan_b_komondor, 'go', 'LineWidth', 3.0, 'MarkerSize', 12)
%   * Default (WLAN A)
%average_legacy_tpt = tpt_wlan_a(obss_pd_levels == -82) * ones(1, size(obss_pd_levels,2));
%plot(1:size(obss_pd_levels,2), average_legacy_tpt, 'kx', 'LineWidth', 2.0, 'MarkerSize', 10);
%   * Default (WLAN B)
%individual_legacy_tpt = tpt_wlan_b(obss_pd_levels == -82) * ones(1, size(obss_pd_levels,2));
%plot(1:size(obss_pd_levels,2), individual_legacy_tpt, 'ko', 'LineWidth', 2.0, 'MarkerSize', 10);
%   * Legend
grid on
grid minor
axis([1, size(obss_pd_levels, 2), 0, 65])
yyaxis left
%   * Plot the tx power in the other yaxis
tx_power_a = apply_power_restriction(obss_pd_levels, wlans(1).tx_pwr_ref);
tx_power_b = apply_power_restriction(min(obss_pd_levels)*ones(1, size(obss_pd_levels, 2)), wlans(2).tx_pwr_ref);
yyaxis right
plot(1:size(obss_pd_levels,2), tx_power_a, 'x', 'LineWidth', 2.0, 'MarkerSize', 12);
hold on
plot(1:size(obss_pd_levels,2), tx_power_b, 'o', 'LineWidth', 2.0, 'MarkerSize', 12);
hlegend = legend({'WLAN_A (SFCTMN)', 'WLAN_A (Komondor)', 'WLAN_B (SFCTM)', 'WLAN_B (Komondor)', ...
   'Tx Power (WLAN_A)', 'Tx Power (WLAN_B)'});
hlegend.NumColumns=3;
ylim([0 21])
ylabel('Tx Power (dBm)')
ax = gca;
ax.GridAlpha = 0.5;  % Make grid lines less transparent.

% 3 - Save Figure
save_figure( fig, 'SIM_1_1', './Simulations/Output/Toy_scenario_1/' )