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
types_scenario_density = ["sparse/", "semi-dense/", "dense/", "ultra-dense/"];

% Specify the number of different traffic loads
NUM_TYPES_TRAFFIC_LOAD = 3;
types_traffic_load = ["traffic_load_1000/", "traffic_load_5000/", "traffic_load_10000/"];

num_wlans = 9;

for s = 1 : NUM_TYPES_DENSITY
%for s = 3 : 3

    for t = 1 : NUM_TYPES_TRAFFIC_LOAD
        
        %%%% NO AGGREGATION

        % Indicate the path of the input file
        file_name = "output_komondor/no_aggregation/" + types_scenario_density{s} + types_traffic_load{t} + "script_output.txt";
        delimiterIn = ';';                  % Delimiter used in the input file
        headerlinesIn = 0;                  % Lines belonging to headers

        % Import the data from the output file
        A = importdata(file_name,delimiterIn,headerlinesIn);
        
        for i = 1 : num_wlans
            throughput_per_wlan_komondor{i} = A.data(:, i)';
            throughput_per_wlan_komondor{i} = reshape(throughput_per_wlan_komondor{i}, [size(obss_pd_levels,2), 50]);
            time_in_channel_per_wlan_komondor{i} = A.data(:, i+num_wlans)';
            time_in_channel_per_wlan_komondor{i} = reshape(time_in_channel_per_wlan_komondor{i}, [size(obss_pd_levels,2), 50]);
            delay_per_wlan_komondor{i} = A.data(:, i+(2*num_wlans))';
            delay_per_wlan_komondor{i} = reshape(delay_per_wlan_komondor{i}, [size(obss_pd_levels,2), 50]);
        end
        
        % Compute the maximum mean improvements for each OBSS/PD threshold
        mean_tpt = zeros(num_wlans-1, size(obss_pd_levels,2));
        mean_occupancy = zeros(num_wlans-1, size(obss_pd_levels,2));
        mean_delay = zeros(num_wlans-1, size(obss_pd_levels,2));
        for i = 1 : num_wlans 
            if i == 1 % WLAN A
                % Throughput
                [val1, ix1] = max(throughput_per_wlan_komondor{i});
                max_tpt_wlan_a{s,t} = mean(val1);
                default_tpt_wlan_a{s,t} = mean(throughput_per_wlan_komondor{i}(21,:));
                % Channel occupation
                %[val2, ix2] = max(time_in_channel_per_wlan_komondor{i});
                for x = 1 : 50
                    channel_occupancy_wlan_a(x) = time_in_channel_per_wlan_komondor{i}(ix1(x), x);
                end
                max_time_channel_wlan_a{s,t} = mean(channel_occupancy_wlan_a);
                default_time_channel_wlan_a{s,t} = mean(time_in_channel_per_wlan_komondor{i}(21,:));
                % Delay
                [val3, ix3] = min(delay_per_wlan_komondor{i});
                min_delay_wlan_a{s,t} = mean(val3);
                default_delay_wlan_a{s,t} = mean(delay_per_wlan_komondor{i}(21,:));
            else % Rest of WLANs
                for x = 1 : 50
                    throughput_others(x) = throughput_per_wlan_komondor{i}(ix1(x), x);
                    occupancy_others(x) = time_in_channel_per_wlan_komondor{i}(ix1(x), x);
                    delay_others(x) = delay_per_wlan_komondor{i}(ix3(x), x);
                end
                max_mean_tpt(i-1) = mean(throughput_others);
                default_mean_tpt(i-1) = mean(throughput_per_wlan_komondor{i}(21,:));
                %max_mean_occupancy(i-1) = mean(throughput_per_wlan_komondor{i}(ix2));
                max_mean_occupancy(i-1) = mean(occupancy_others);
                default_mean_occupancy(i-1) = mean(time_in_channel_per_wlan_komondor{i}(21,:));
                min_mean_delay(i-1) = mean(delay_others);
                default_mean_delay(i-1) = mean(delay_per_wlan_komondor{i}(21,:));
            end
        end
        
        % AVERAGE MAX AND DEFAULT PERFORMANCE (EXCEPT WLAN A)
        % Throughput
        max_tpt_average{s,t} = mean(max_mean_tpt);
        default_tpt_average{s,t} = mean(default_mean_tpt);
        % Channel occupation
        max_time_channel_average{s,t} = mean(max_mean_occupancy);
        default_time_channel_average{s,t} = mean(default_mean_occupancy);
        % Delay
        min_delay_average{s,t} = mean(min_mean_delay);
        default_delay_average{s,t} = mean(default_mean_delay);
        
        %%%% AGGREGATION
        
        % Indicate the path of the input file
        file_name_agg = "output_komondor/" + types_scenario_density{s} + types_traffic_load{t} + "script_output.txt";
        delimiterIn = ';';                  % Delimiter used in the input file
        headerlinesIn = 0;                  % Lines belonging to headers

        % Import the data from the output file
        A = importdata(file_name_agg,delimiterIn,headerlinesIn);
        
        for i = 1 : num_wlans
            throughput_per_wlan_komondor{i} = A.data(:, i)';
            throughput_per_wlan_komondor{i} = reshape(throughput_per_wlan_komondor{i}, [size(obss_pd_levels,2), 50]);
            time_in_channel_per_wlan_komondor{i} = A.data(:, i+num_wlans)';
            time_in_channel_per_wlan_komondor{i} = reshape(time_in_channel_per_wlan_komondor{i}, [size(obss_pd_levels,2), 50]);
            delay_per_wlan_komondor{i} = A.data(:, i+(2*num_wlans))';
            delay_per_wlan_komondor{i} = reshape(delay_per_wlan_komondor{i}, [size(obss_pd_levels,2), 50]);
        end
        
        % Compute the maximum mean improvements for each OBSS/PD threshold
        mean_tpt = zeros(num_wlans-1, size(obss_pd_levels,2));
        mean_occupancy = zeros(num_wlans-1, size(obss_pd_levels,2));
        mean_delay = zeros(num_wlans-1, size(obss_pd_levels,2));
        for i = 1 : num_wlans 
            if i == 1 % WLAN A
                % Throughput
                [val1, ix1] = max(throughput_per_wlan_komondor{i});
                max_tpt_wlan_a_agg{s,t} = mean(val1);
                default_tpt_wlan_a_agg{s,t} = mean(throughput_per_wlan_komondor{i}(21,:));
                % Channel occupation
                %[val2, ix2] = max(time_in_channel_per_wlan_komondor{i});
                for x = 1 : 50
                    channel_occupancy_wlan_a(x) = time_in_channel_per_wlan_komondor{i}(ix1(x), x);
                end
                max_time_channel_wlan_a_agg{s,t} = mean(channel_occupancy_wlan_a);
                default_time_channel_wlan_a_agg{s,t} = mean(time_in_channel_per_wlan_komondor{i}(21,:));
                % Delay
                [val3, ix3] = min(delay_per_wlan_komondor{i});
                min_delay_wlan_a_agg{s,t} = mean(val3);
                default_delay_wlan_a_agg{s,t} = mean(delay_per_wlan_komondor{i}(21,:));
            else % Rest of WLANs
                for x = 1 : 50
                    throughput_others(x) = throughput_per_wlan_komondor{i}(ix1(x), x);
                    occupancy_others(x) = time_in_channel_per_wlan_komondor{i}(ix1(x), x);
                    delay_others(x) = delay_per_wlan_komondor{i}(ix3(x), x);
                end
                max_mean_tpt(i-1) = mean(throughput_others);
                default_mean_tpt(i-1) = mean(throughput_per_wlan_komondor{i}(21,:));
                %max_mean_occupancy(i-1) = mean(throughput_per_wlan_komondor{i}(ix2));
                max_mean_occupancy(i-1) = mean(occupancy_others);
                default_mean_occupancy(i-1) = mean(time_in_channel_per_wlan_komondor{i}(21,:));
                min_mean_delay(i-1) = mean(delay_others);
                default_mean_delay(i-1) = mean(delay_per_wlan_komondor{i}(21,:));
            end
        end
        
        % AVERAGE MAX AND DEFAULT PERFORMANCE (EXCEPT WLAN A)
        % Throughput
        max_tpt_average_agg{s,t} = mean(max_mean_tpt);
        default_tpt_average_agg{s,t} = mean(default_mean_tpt);
        % Channel occupation
        max_time_channel_average_agg{s,t} = mean(max_mean_occupancy);
        default_time_channel_average_agg{s,t} = mean(default_mean_occupancy);
        % Delay
        min_delay_average_agg{s,t} = mean(min_mean_delay);
        default_delay_average_agg{s,t} = mean(default_mean_delay);
       
    end
    
end

% Set font type
set(0,'defaultUicontrolFontName','Helvetica');
set(0,'defaultUitableFontName','Helvetica');
set(0,'defaultAxesFontName','Helvetica');
set(0,'defaultTextFontName','Helvetica');
set(0,'defaultUipanelFontName','Helvetica');

%% PART 2 - Plot the results

for i = 3 : 3%NUM_TYPES_DENSITY
% CHANNEL OCCUPANCY
data1 = [default_time_channel_wlan_a{i,1} max_time_channel_wlan_a{i,1} default_time_channel_wlan_a_agg{i,1} max_time_channel_wlan_a_agg{i,1}; ...
   default_time_channel_wlan_a{i,2} max_time_channel_wlan_a{i,2} default_time_channel_wlan_a_agg{i,2} max_time_channel_wlan_a_agg{i,2}; ...
   default_time_channel_wlan_a{i,3} max_time_channel_wlan_a{i,3} default_time_channel_wlan_a_agg{i,3} max_time_channel_wlan_a_agg{i,3}];

data2 = [default_time_channel_average{i,1} max_time_channel_average{i,1} default_time_channel_average_agg{i,1} max_time_channel_average_agg{i,1}; ...
    default_time_channel_average{i,2} max_time_channel_average{i,2} default_time_channel_average_agg{i,2} max_time_channel_average_agg{i,2}; ...
    default_time_channel_average{i,3} max_time_channel_average{i,3} default_time_channel_average_agg{i,3} max_time_channel_average_agg{i,3}];

fig = figure('pos',[450 400 500 350]);
axes;
axis([1 20 30 70]);
subplot(1,2,1)
bar(data1)
hold on 
bar(data2,'LineStyle','--','FaceColor','none','linewidth',2.0) 
set(gca, 'FontSize', 18)
xlabel('Traffic load (pkt/s)','fontsize', 20)
ylabel('Channel occupancy (%)','fontsize', 20)
axis([0, 4, 0, 100])
xticks(1:4)
xticklabels({'1,000', '2,000', '10,000'})
legend({'BSS_A (CCA/CS - NoAgg)', 'BSS_A (SR - NoAgg)', 'BSS_A (CCA/CS - Agg)', 'BSS_A (SR - Agg)', ...
    'Others (CCA/CS - NoAgg)', 'Others (SR - NoAgg)','Others (CCA/CS - Agg)', 'Others (SR - Agg)'})
title(types_scenario_density{i})
grid on
grid minor
% Save Figure
%save_figure( fig, ['SIM_2_2_1_' num2str(i)], './Simulations/Output/Random/' )

% THROUGHPUT
data1 = [default_tpt_wlan_a{i,1} max_tpt_wlan_a{i,1} default_tpt_wlan_a_agg{i,1} max_tpt_wlan_a_agg{i,1}; ...
   default_tpt_wlan_a{i,2} max_tpt_wlan_a{i,2} default_tpt_wlan_a_agg{i,2} max_tpt_wlan_a_agg{i,2}; ...
   default_tpt_wlan_a{i,3} max_tpt_wlan_a{i,3} default_tpt_wlan_a_agg{i,3} max_tpt_wlan_a_agg{i,3}];

data2 = [default_tpt_average{i,1} max_tpt_average{i,1} default_tpt_average_agg{i,1} max_tpt_average_agg{i,1}; ...
    default_tpt_average{i,2} max_tpt_average{i,2} default_tpt_average_agg{i,2} max_tpt_average_agg{i,2}; ...
    default_tpt_average{i,3} max_tpt_average{i,3} default_tpt_average_agg{i,3} max_tpt_average_agg{i,3}];

data1(:,2)-data1(:,1)
data1(:,4)-data1(:,3)

data2(:,2)-data2(:,1)
data2(:,4)-data2(:,3)

% fig = figure('pos',[450 400 500 350]);
% axes;
% axis([1 20 30 70]);
subplot(1,2,2)
bar(data1)
hold on 
bar(data2,'LineStyle','--','FaceColor','none','linewidth',2.0) 
set(gca, 'FontSize', 18)
xlabel('Traffic load (pkt/s)','fontsize', 20)
ylabel('Throughtput (Mbps)','fontsize', 20)
axis([0, 4, 0, 100])
xticks(1:4)
xticklabels({'1,000', '2,000', '10,000'})
legend({'BSS_A (CCA/CS - NoAgg)', 'BSS_A (SR - NoAgg)', 'BSS_A (CCA/CS - Agg)', 'BSS_A (SR - Agg)', ...
    'Others (CCA/CS - NoAgg)', 'Others (SR - NoAgg)','Others (CCA/CS - Agg)', 'Others (SR - Agg)'})
title(types_scenario_density{i})
grid on
grid minor
% Save Figure
%save_figure( fig, ['SIM_2_2_2_' num2str(i)], './Simulations/Output/Random/' )
end

%% PART 3 - Save the workspace
save('./Simulations/Output/Random/SIM_2_2.mat')