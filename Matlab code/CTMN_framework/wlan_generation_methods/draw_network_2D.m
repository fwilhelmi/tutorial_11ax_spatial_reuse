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

function draw_network_2D(wlans)
% DrawNetwork3D - Plots a 3D of the network 
%   INPUT: 
%       * wlan - contains information of each WLAN in the map. For instance,
%       wlan(1) corresponds to the first one, so that it has unique
%       parameters (x,y,z,BW,CCA,etc.)

    load('configuration_system.mat')
    
    MaxX = 100;
    MaxY = 100;
    
    for j = 1 : size(wlans, 2)
        x(j)=wlans(j).position_ap(1);
        y(j)=wlans(j).position_ap(2);
        z(j)=wlans(j).position_ap(3);
    end
    
    fig = figure('pos',[450 400 500 350]);
    axes;
    axis([1 20 30 70]);
    set(gca,'fontsize',16);
    labels = num2str((1:size(y' ))','%d');  
    
    for i = 1 : size(wlans, 2)
        scatter(wlans(i).position_ap(1), wlans(i).position_ap(2), 70, [0 0 0], 'filled');
        hold on;   
        scatter(wlans(i).position_sta(1), wlans(i).position_sta(2), 30, [0 0 1], 'filled');
        line([wlans(i).position_ap(1), wlans(i).position_sta(1)], [wlans(i).position_ap(2), wlans(i).position_sta(2)], ...
            [wlans(i).position_ap(3), wlans(i).position_sta(3)], 'Color', [0.4, 0.4, 1.0], 'LineStyle', ':');        
    end
    
    text(x, y, z, labels, 'horizontal', 'left', 'vertical', 'bottom') 
    xlabel('x [meters]', 'fontsize', 14);
    ylabel('y [meters]', 'fontsize', 14);
    zlabel('z [meters]', 'fontsize', 14);
    axis([0 MaxX 0 MaxY])
    
end