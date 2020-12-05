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

% Set the OBSS_PD and tx power levels to be used by WLAN A
obss_pd_level_1 = -82;
obss_pd_level_2 = -70;
obss_pd_level_3 = -78;

% Generate wlans object according to the input file
input_file = ['Input/input_sim_1_1_test.csv'];
wlans = generate_wlan_from_file(input_file, false, false, 1, [], []);

% Compute the throughput of the scenario, for each OBSS_PD value
avg_tpt_1 = NaN*ones(1, size(obss_pd_level_1, 2));
tpt_wlan_a1 = NaN*ones(1, size(obss_pd_level_1, 2));
tpt_wlan_b1 = NaN*ones(1, size(obss_pd_level_1, 2));
sinr_wlan_a = NaN*ones(1, size(obss_pd_level_1, 2));
sinr_wlan_b = NaN*ones(1, size(obss_pd_level_1, 2));
for cca_ix = 1 : size(obss_pd_level_1, 2)        
    disp('---------------------------')
    disp([' CCA = ' num2str(obss_pd_level_1(cca_ix)) ' / Tx Power = ' num2str(20)])      
    % Set the OBSS_PD to be used by WLAN A
    wlans(1).non_srg_obss_pd = obss_pd_level_1(cca_ix);
    % Call the SFCTMN framework
    [throughput, average_sinr_per_wlan] = function_main_sfctmn(wlans);    
    disp(['Throughput WLAN A in scenario 1 (legacy): ' num2str(throughput(1))])
    disp(['Throughput WLAN B in scenario 1 (legacy): ' num2str(throughput(2))])
    % Store the results to be displayed later
    avg_tpt_1(cca_ix) = mean(throughput);
    tpt_wlan_a1(cca_ix) = throughput(1);     
    tpt_wlan_b1(cca_ix) = throughput(2); 
    sinr_wlan_a(cca_ix) = average_sinr_per_wlan(1);     
    sinr_wlan_b(cca_ix) = average_sinr_per_wlan(2); 
end

% Compute the throughput of the scenario, for each OBSS_PD value
avg_tpt_2 = NaN*ones(1, size(obss_pd_level_2, 2));
tpt_wlan_a2 = NaN*ones(1, size(obss_pd_level_2, 2));
tpt_wlan_b2 = NaN*ones(1, size(obss_pd_level_2, 2));
sinr_wlan_a = NaN*ones(1, size(obss_pd_level_2, 2));
sinr_wlan_b = NaN*ones(1, size(obss_pd_level_2, 2));
for cca_ix = 1 : size(obss_pd_level_2, 2)        
    disp('---------------------------')
    disp([' CCA = ' num2str(obss_pd_level_2(cca_ix)) ' / Tx Power = ' num2str(20)])      
    % Set the OBSS_PD to be used by WLAN A
    wlans(1).non_srg_obss_pd = obss_pd_level_2(cca_ix);
    wlans(2).non_srg_obss_pd = obss_pd_level_2(cca_ix);
    % Call the SFCTMN framework
    [throughput, average_sinr_per_wlan] = function_main_sfctmn(wlans);    
    disp(['Throughput WLAN A in scenario 1 (legacy): ' num2str(throughput(1))])
    disp(['Throughput WLAN B in scenario 1 (legacy): ' num2str(throughput(2))])
    % Store the results to be displayed later
    avg_tpt_2(cca_ix) = mean(throughput);
    tpt_wlan_a2(cca_ix) = throughput(1);     
    tpt_wlan_b2(cca_ix) = throughput(2); 
    sinr_wlan_a(cca_ix) = average_sinr_per_wlan(1);     
    sinr_wlan_b(cca_ix) = average_sinr_per_wlan(2); 
end

% Compute the throughput of the scenario, for each OBSS_PD value and the
% optimal power
avg_tpt_3 = NaN*ones(1, size(obss_pd_level_2, 2));
tpt_wlan_a3 = NaN*ones(1, size(obss_pd_level_2, 2));
tpt_wlan_b3 = NaN*ones(1, size(obss_pd_level_2, 2));
sinr_wlan_a = NaN*ones(1, size(obss_pd_level_2, 2));
sinr_wlan_b = NaN*ones(1, size(obss_pd_level_2, 2));
for cca_ix = 1 : size(obss_pd_level_2, 2)        
    disp('---------------------------')
    disp([' CCA = ' num2str(obss_pd_level_3(cca_ix)) ' / Tx Power = ' num2str(20)])      
    % Set the OBSS_PD to be used by WLAN A
    wlans(1).non_srg_obss_pd = obss_pd_level_3(cca_ix);
    wlans(2).non_srg_obss_pd = obss_pd_level_3(cca_ix);
    % Call the SFCTMN framework
    [throughput, average_sinr_per_wlan] = function_main_sfctmn(wlans);    
    disp(['Throughput WLAN A in scenario 1 (legacy): ' num2str(throughput(1))])
    disp(['Throughput WLAN B in scenario 1 (legacy): ' num2str(throughput(2))])
    % Store the results to be displayed later
    avg_tpt_3(cca_ix) = mean(throughput);
    tpt_wlan_a3(cca_ix) = throughput(1);     
    tpt_wlan_b3(cca_ix) = throughput(2); 
    sinr_wlan_a(cca_ix) = average_sinr_per_wlan(1);     
    sinr_wlan_b(cca_ix) = average_sinr_per_wlan(2); 
end

bar([tpt_wlan_a1, tpt_wlan_b1;tpt_wlan_a2, tpt_wlan_b2; tpt_wlan_a3, tpt_wlan_b3])
grid on
grid minor
ylabel('Throughput [Mbps]')
xticklabels({'Legacy', 'OBSS/PD-based SR', 'Optimal TxPw'})
set(gca,'FontSize',18)
legend({'BSS_A', 'BSS_B'})

% Save the workspace
%save('SIM_TEST.mat')