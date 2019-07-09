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

function wlans = generate_wlan_randomly ( numWlans, randomInitialConf, drawMap )
% GenerateNetwork3D - Generates a 3D network 
%   OUTPUT: 
%       * wlan - contains information of each WLAN in the map. For instance,
%       wlan(1) corresponds to the first one, so that it has unique
%       parameters (x,y,z,BW,CCA,etc.)
%   INPUT: 
%       * nWlans: number of WLANs on the studied environment

    % Load system & TS configuration
    load('configuration_system.mat')
        
    % Generate wlan structures
    wlans = [];
    
    % Map size
    map_width = 100;    % map's width in meters
    map_height = 100;   % map's height in meters
    
    min_range = [1 1 0];
    max_range = [5 5 0];
    
    nChannels = 1;
    txPowerActions = 1:20;
    ccaActions = -82:-62;

    for w = 1 : numWlans
        % WLAN code
        wlans(w).code = w;   
        % Initial configuration
        if randomInitialConf % Random
            wlans(w).primary = datasample(nChannels, 1);            % Pick primary channel
            wlans(w).tx_power = datasample(txPowerActions, 1);      % Pick transmission power
            wlans(w).cca = datasample(ccaActions, 1);               % Pick CCA level
        else % Greedy configuration
            wlans(w).primary = min(nChannels);              % Pick primary channel
            wlans(w).tx_power = max(txPowerActions);        % Pick transmission power
            wlans(w).cca = min(ccaActions);                 % Pick CCA level
        end
        
        % Channels range (for Channel Bonding purposes - does not apply here)
        wlans(w).range = [wlans(w).primary wlans(w).primary];  % pick range

        % Position AP
        if w == 1
            wlans(w).x = map_width/2;
            wlans(w).y = map_height/2;
            wlans(w).z = 0; 
        else
            wlans(w).x = map_width * rand();
            wlans(w).y = map_height * rand();
            wlans(w).z = 0; 
        end
        wlans(w).position_ap = [wlans(w).x  wlans(w).y  wlans(w).z];
        
        % Position STA 
        %   - Determine the distance in each of the directions
        x_distance = min_range(1) + rand(1,1)*(max_range(1)-min_range(1));
        y_distance = min_range(2) + rand(1,1)*(max_range(2)-min_range(2));
        z_distance = min_range(3) + rand(1,1)*(max_range(3)-min_range(3));   
        %   - Assign to which direction to locate the STA
        if(rand() < 0.5), xc = x_distance;  else, xc = -x_distance; end
        if(rand() < 0.5), yc = y_distance;  else, yc = -y_distance; end
        if(rand() < 0.5), zc = z_distance;  else, zc = -z_distance; end
        %   - Assign determined value
        wlans(w).xn = min(abs(wlans(w).x+xc), map_width);  
        wlans(w).yn = min(abs(wlans(w).y+yc), map_height);
        wlans(w).zn = min(abs(wlans(w).z+zc), 0);
        xn(w)=wlans(w).xn;
        yn(w)=wlans(w).yn;
        zn(w)=wlans(w).zn;        
        wlans(w).position_sta = [wlans(w).xn  wlans(w).yn  wlans(w).zn];

        wlans(w).lambda = 14815;         % Pick lambda
        
        %wlans(w).lambda = input_data(w,INPUT_FIELD_LAMBDA);         % Pick lambda
        wlans(w).bandwidth = BANDWITDH_PER_CHANNEL;
                
        wlans(w).states = [];   % Instantiate states for later use          
        wlans(w).widths = [];   % Instantiate acceptable widhts item for later use
                
        wlans(w).legacy = 0;
        
        wlans(w).cw = 16;

         % Spatial Reuse operation
        if w == 1   
            wlans(w).bss_color = 1;
        else
            wlans(w).bss_color = 0;
        end
        wlans(w).srg = -1;    
        wlans(w).obss_pd = -82;
        wlans(w).obss_pd_min = -82;        
        wlans(w).obss_pd_max = -62;
        wlans(w).srg_obss_pd = -82;   
        wlans(w).non_srg_obss_pd = -82;
        wlans(w).tx_pwr_ref = 21;
        
    end
      
    if drawMap, draw_network_3D(wlans); end

end