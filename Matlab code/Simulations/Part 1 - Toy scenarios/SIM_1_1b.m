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
obss_pd_levels = -82:1:-62;

% Generate wlans object according to the input file
input_file = ['./Input/input_sim_1_1b.csv'];
wlans = generate_wlan_from_file(input_file, false, false, 1, [], []);

% Compute the throughput of the scenario, for each OBSS_PD value
avg_tpt = NaN*ones(1, size(obss_pd_levels, 2));
tpt_wlan_a = NaN*ones(1, size(obss_pd_levels, 2));
tpt_wlan_b = NaN*ones(1, size(obss_pd_levels, 2));
for cca_ix = 1 : size(obss_pd_levels, 2)        
    disp('---------------------------')
    disp([' CCA = ' num2str(obss_pd_levels(cca_ix)) ' / Tx Power = ' num2str(20)])      
    % Set the OBSS_PD to be used by WLAN A
    wlans(1).non_srg_obss_pd = obss_pd_levels(cca_ix);
    wlans(2).non_srg_obss_pd = obss_pd_levels(cca_ix);
    % Call the SFCTMN framework
    [throughput] = function_main_sfctmn(wlans);    
    disp(['Throughput WLAN A in scenario 1 (legacy): ' num2str(throughput(1))])
    disp(['Throughput WLAN B in scenario 1 (legacy): ' num2str(throughput(2))])
    % Store the results to be displayed later
    avg_tpt(cca_ix) = mean(throughput);
    tpt_wlan_a(cca_ix) = throughput(1);     
    tpt_wlan_b(cca_ix) = throughput(2); 
end

% Save the workspace
save('SIM_1_1b.mat')