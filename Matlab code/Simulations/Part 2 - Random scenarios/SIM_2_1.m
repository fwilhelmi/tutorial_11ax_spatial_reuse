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

clear
clc

% Generate constants 
constants_sfctmn_framework_sim_2
% Set specific configurations
configuration_system_sim_2           

% Set the OBSS_PD and tx power levels to be used by WLAN A
obss_pd_levels = -82:1:-62;

% PART 1 - Load results from Komondor

% Dense & Low traffic load
% Specify the number and types of scenarios according to density
NUM_TYPES_DENSITY = 4;
types_scenario_density = {"sparse/", "semi-dense/", "dense/", "ultra-dense/"};

% Specify the number of different traffic loads
NUM_TYPES_TRAFFIC_LOAD = 3;
types_traffic_load = {"traffic_load_1000/", "traffic_load_5000/", "traffic_load_10000/"};

num_wlans = 9;

for s = 1 : NUM_TYPES_DENSITY
    
    for t = 1 : NUM_TYPES_TRAFFIC_LOAD

        % Indicate the path of the input file
        file_name = "output_komondor/no_aggregation/" + types_scenario_density{s} + types_traffic_load{t} + "script_output.txt";
        delimiterIn = ';';                  % Delimiter used in the input file
        headerlinesIn = 0;                  % Lines belonging to headers

        % Import the data from the output file
        A = importdata(file_name,delimiterIn,headerlinesIn);
        
        for i = 1 : num_wlans
            throughput_per_wlan_komondor{i} = A.data(:, i)';
            throughput_per_wlan_komondor{i} = reshape(throughput_per_wlan_komondor{i}, [size(obss_pd_levels,2), 50]);
        end
        
        % Compute the maximum mean improvements for each OBSS/PD threshold
        mean_tpt = zeros(num_wlans-1, size(obss_pd_levels,2));
        for i = 1 : num_wlans 
            if i == 1 % WLAN A
                % Throughput
                [val1, ix1] = max(throughput_per_wlan_komondor{i});
                max_tpt_wlan_a{s,t} = mean(val1);
                default_tpt_wlan_a{s,t} = mean(throughput_per_wlan_komondor{i}(21,:));
            else % Rest of WLANs
                for x = 1 : 50
                    throughput_others(x) = throughput_per_wlan_komondor{i}(ix1(x), x);
                end
                tpt_others_sr(i-1) = mean(throughput_others);
                tpt_others_default(i-1) = mean(throughput_per_wlan_komondor{i}(21,:));
%                 max_mean_tpt(i-1) = mean(throughput_per_wlan_komondor{i}(ix1));
%                 default_mean_tpt(i-1) = mean(throughput_per_wlan_komondor{i}(21,:));
            end
        end
        
        % AVERAGE MAX AND DEFAULT PERFORMANCE (EXCEPT WLAN A)
        % Throughput
        max_tpt_average{s,t} = mean(tpt_others_sr);
        default_tpt_average{s,t} = mean(tpt_others_default);

        % Compute the average improvements with respect to the static situation
        mean_improvement_throughput_wlan_a{s,t} = max_tpt_wlan_a{s,t} - default_tpt_wlan_a{s,t};
        mean_improvement_average_throughput{s,t} = max_tpt_average{s,t} - default_tpt_average{s,t};        
        
    end
    
end

% Set font type
set(0,'defaultUicontrolFontName','Helvetica');
set(0,'defaultUitableFontName','Helvetica');
set(0,'defaultAxesFontName','Helvetica');
set(0,'defaultTextFontName','Helvetica');
set(0,'defaultUipanelFontName','Helvetica');

%% PART 1 - NETWORK DENSITY: Plot the mean throughput achieved in each density (WLAN_A and average)
% Prepare data
data1 = [default_tpt_wlan_a{1,3} max_tpt_wlan_a{1,3}; ...
    default_tpt_wlan_a{2,3} max_tpt_wlan_a{2,3}; ...
    default_tpt_wlan_a{3,3} max_tpt_wlan_a{3,3}; ...
    default_tpt_wlan_a{4,3} max_tpt_wlan_a{4,3}];
data2 = [default_tpt_average{1,3} max_tpt_average{1,3}; ...
    default_tpt_average{2,3} max_tpt_average{2,3}; ...
    default_tpt_average{3,3} max_tpt_average{3,3}; ...
    default_tpt_average{4,3} max_tpt_average{4,3}];
% Plot the figure
fig = figure('pos',[450 400 500 350]);
axes;
axis([1 20 30 70]);
bar(data1)
hold on 
bar(data2, 'LineStyle', '--', 'FaceColor', 'none', 'linewidth', 2.0) 
hold off
set(gca, 'FontSize', 18)
xlabel('Network density','fontsize', 20)
ylabel('Mean throughput (Mbps)','fontsize', 20)
axis([0, 5, 0, 90])
xticks(1:4)
xticklabels({'Sparse', 'Semi-dense', 'Dense', 'Ultra-dense'})
legend({'WLAN_A (CCA/CS)', 'WLAN_A (SR)', 'Others (CCA/CS)', 'Others (SR)'})
grid on
grid minor
% Save Figure
save_figure( fig, 'SIM_2_1', './Simulations/Output/Random/' )

%% PART 3 - Save the workspace
save('./Simulations/Output/Random/SIM_2_1.mat')
