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

function [] = display_experiment_information( wlans_input )

    % Load the MABs constants
    load('constants_sfctmn_framework.mat')
    load('configuration_agents.mat')
    % Load the MABs constants
    %load('configuration_system.mat')
    %load('constants_thompson_sampling.mat')
        
    disp('+++++++++++++++++++++++++++++++++++++++')
    disp('CONFIGURATION EXPERIMENT:')
    
    disp([LOG_LVL2 'System parameters:'])
    disp([LOG_LVL3 'path_loss_model: ' num2str(path_loss_model)])
    disp([LOG_LVL3 'carrier_frequency (GHz): ' num2str(carrier_frequency)])
    disp([LOG_LVL3 'noise (dBM): ' num2str(NOISE_DBM)])
    disp([LOG_LVL3 'nChannels: ' num2str(nChannels)])
    disp([LOG_LVL3 'dsa_policy_type: ' num2str(dsa_policy_type)])
    
    disp([LOG_LVL2 'Actions:'])
    disp([LOG_LVL3 'channelActions: ' num2str(channelActions)])
    disp([LOG_LVL3 'ccaActions: ' num2str(ccaActions)])
    disp([LOG_LVL3 'txPowerActions: ' num2str(txPowerActions)])
    
    disp([LOG_LVL2 'MABs parameters:'])
    disp([LOG_LVL3 'totalIterations: ' num2str(totalIterations)])
    disp([LOG_LVL3 'minimumIterationToConsider: ' num2str(minimumIterationToConsider)])
    disp([LOG_LVL3 'randomInitialConfiguration: ' num2str(randomInitialConfiguration)])
    disp([LOG_LVL3 'convergenceActivated: ' num2str(convergenceActivated)])
    disp([LOG_LVL4 'numMaxIterationsConvergence: ' num2str(numMaxIterationsConvergence)])
    disp([LOG_LVL4 'allowed_error: ' num2str(allowedError)])
    disp([LOG_LVL4 'epsilon_regret: ' num2str(epsilonRegret)])
    disp([LOG_LVL3 'probabilityOfActing: ' num2str(probabilityOfActing)])
    disp([LOG_LVL3 'clusteringActivated: ' num2str(clusteringActivated)])
    disp([LOG_LVL4 'clusteringType: ' num2str(clusteringType)])
    
    disp([LOG_LVL2 'WLANs:'])
    for i = 1 : size(wlans_input,2)
        display_wlans_information(wlans_input(i));
    end            
       
    disp('+++++++++++++++++++++++++++++++++++++++')
    
end