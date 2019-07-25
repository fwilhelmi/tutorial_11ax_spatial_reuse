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
%cca_levels_non_srg = -78;
tx_power_default = 20;

% Generate wlans object according to the input file
input_file = './Input/input_sim_1_2.csv';
wlans = generate_wlan_from_file(input_file, false, false, 1, [], []);
num_wlans = size(wlans,2);

% Compute the throughput of the scenario, for each OBSS_PD value
avg_tpt_per_tpc_and_cca_value = NaN*ones(size(cca_levels_srg, 2), size(cca_levels_non_srg, 2));
min_tpt_per_tpc_and_cca_value = NaN*ones(size(cca_levels_srg, 2), size(cca_levels_non_srg, 2));
ind_tpt_per_tpc_and_cca_value_w1 = NaN*ones(size(cca_levels_srg, 2), size(cca_levels_non_srg, 2));
ind_tpt_per_tpc_and_cca_value_w2 = NaN*ones(size(cca_levels_srg, 2), size(cca_levels_non_srg, 2));
ind_tpt_per_tpc_and_cca_value_w3 = NaN*ones(size(cca_levels_srg, 2), size(cca_levels_non_srg, 2));
sinr_wlan_a = NaN*ones(size(cca_levels_srg, 2), size(cca_levels_non_srg, 2));
sinr_wlan_b = NaN*ones(size(cca_levels_srg, 2), size(cca_levels_non_srg, 2));
sinr_wlan_c = NaN*ones(size(cca_levels_srg, 2), size(cca_levels_non_srg, 2));

for cca_ix = 1 : size(cca_levels_srg, 2) 
    for cca_ix_aux = 1 : size(cca_levels_non_srg, 2)    
        disp('---------------------------')
        disp([' SRG_PD = ' num2str(cca_levels_srg(cca_ix)) ' / NON_SRG_PD = ' num2str(cca_levels_non_srg(cca_ix_aux))])        
        % Set the OBSS_PD and the tx power to be used by all the WLANs  
        for i = 1 : num_wlans
        %i = 1;
            wlans(i).srg_obss_pd = cca_levels_srg(cca_ix);
            wlans(i).non_srg_obss_pd = cca_levels_non_srg(cca_ix_aux);
            wlans(i).tx_power = tx_power_default;   
        end
        % Call the SFCTMN framework
        [throughput] = function_main_sfctmn(wlans);
        disp(['Average throughput in scenario 3: ' num2str(mean(throughput))])
        disp(['Min throughput in scenario 3: ' num2str(min(throughput))])
        disp(['Throughput WLAN A in scenario 3: ' num2str(throughput(1))])
        disp(['Throughput WLAN B in scenario 3: ' num2str(throughput(2))])
        disp(['Throughput WLAN C in scenario 3: ' num2str(throughput(3))])
        % Store the results to be displayed later
        avg_tpt_per_tpc_and_cca_value(cca_ix, cca_ix_aux) = mean(throughput);
        min_tpt_per_tpc_and_cca_value(cca_ix, cca_ix_aux) = min(throughput);
        ind_tpt_per_tpc_and_cca_value_w1(cca_ix, cca_ix_aux) = throughput(1);     
        ind_tpt_per_tpc_and_cca_value_w2(cca_ix, cca_ix_aux) = throughput(2); 
        ind_tpt_per_tpc_and_cca_value_w3(cca_ix, cca_ix_aux) = throughput(3); 
        sinr_wlan_a(cca_ix, cca_ix_aux) = average_sinr_per_wlan(1);     
        sinr_wlan_b(cca_ix, cca_ix_aux) = average_sinr_per_wlan(2); 
        sinr_wlan_c(cca_ix, cca_ix_aux) = average_sinr_per_wlan(3); 
    end
end

%% PART 2 - Save workspace
save('SIM_1_2.mat')