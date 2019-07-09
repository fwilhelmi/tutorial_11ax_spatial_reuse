%%% ***********************************************************************
%%% *      A Tutorial on the Spatial Reuse Operation in IEEE 802.11ax:    *
%%% *         Work Done, Challenges and Research Opportunities            *
%%% * Submission to ...                                                   *
%%% * Authors:                                                            *
%%% *   - Francesc Wilhelmi (francisco.wilhelmi@upf.edu)                  *
%%% *   - Boris Bellalta (boris.bellalta@upf.edu)                         *
%%% *   - Cristina Cano (ccanobs@uoc.edu)                                 *
%%% * 	- Ioannis Selinis (ioannis.selinis@surrey.ac.uk)                  *
%%% *   - Sergio Barrachina-Muñoz  (sergio.barrachina@upf.edu)            *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi         *
%%% * Repository:                                                         *
%%% *  bitbucket.org/fwilhelmi/overview_ieee80211ax_spatial_reuse/        *
%%% ***********************************************************************
clear
clc

% Generate constants 
constants_sfctmn_framework_sim_0
% Set specific configurations
configuration_system_sim_0         

% Generate wlans object according to the input file
input_file = './Input/basic_validation/input_validation_2a.csv';
wlans = generate_wlan_from_file(input_file, false, false, 1, [], []); 
[throughput] = function_main_sfctmn(wlans);
% disp('Average Throughput:')
% disp(mean(throughput))
% disp('Throughput per WLAN A:')
% disp(throughput(1))   
throughput