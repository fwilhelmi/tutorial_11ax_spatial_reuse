%%% *********************************************************************
%%% * Spatial-Flexible CTMN for WLANs                                   *
%%% * Author: Sergio Barrachina-Munoz (sergio.barrachina@upf.edu)       *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Sergio Barrachina-Munoz *
%%% * GitHub repository: https://github.com/sergiobarra/SFCTMN          *
%%% * More info on https://www.upf.edu/en/web/sergiobarrachina          *
%%% *********************************************************************

%%% File description: script for generating the system configuration

path_loss_model = PATH_LOSS_AX_RESIDENTIAL;         % Path loss model index
access_protocol_type = ACCESS_PROTOCOL_IEEE80211;   % Access protocol type
flag_hardcode_distances = true;                     % Allows hardcoding distances from main_sfctmn.m file
carrier_frequency = 5;                              % Carrier frequency [GHz] (2.4 or 5) GHz
NOISE_DBM = -95;                                    % Ambient noise [dBm]
BANDWITDH_PER_CHANNEL = 20e6;
SINGLE_USER_SPATIAL_STREAMS = 1;
IEEE_AX_MAX_PPDU_DURATION = 5484 * 0.000001;

% DSA policy type (SFCTMN)
dsa_policy_type = DSA_POLICY_ONLY_MAX;

CW_DEFAULT = 16;

save('configuration_system.mat');  % Save system configuration into current folder