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

% Specify the possible OBSS PD values
obss_pd_levels = -82:1:-62;

% PART 1 - Load and process the results from Komondor

path_legacy = "output_komondor/ultra-dense/traffic_load_10000/script_output.txt";
path_hybrid = "output_komondor/hybrid_scenarios/mixed/script_output.txt";
path_all_sr = "output_komondor/hybrid_scenarios/total/script_output.txt";
paths = {path_legacy, path_hybrid, path_all_sr};

% Define simulation parameters
num_wlans = 9;
sim_time = 10e3;
num_deployments = 50;

for p = 1 : size(paths, 2)

    file_name = paths{p};   % Indicate the path of the input file
    delimiterIn = ';';      % Delimiter used in the input file
    headerlinesIn = 0;      % Lines belonging to headers

    % Import the data from the corresponding output file
    A = importdata(file_name,delimiterIn,headerlinesIn);

    for i = 1 : num_wlans
        throughput_per_wlan_komondor{p,i} = A.data(:, i)';
        throughput_per_wlan_komondor{p,i} = reshape(throughput_per_wlan_komondor{p,i}, [size(obss_pd_levels,2), 50]);
        time_in_channel_per_wlan_komondor{p,i} = A.data(:, i+num_wlans)';
        time_in_channel_per_wlan_komondor{p,i} = reshape(time_in_channel_per_wlan_komondor{p,i}, [size(obss_pd_levels,2), 50]);
        delay_per_wlan_komondor{p,i} = A.data(:, i+(2*num_wlans))';
        delay_per_wlan_komondor{p,i} = reshape(delay_per_wlan_komondor{p,i}, [size(obss_pd_levels,2), 50]);
        delay_per_wlan_komondor{p,i}(isnan(delay_per_wlan_komondor{p,i})) = sim_time;   % Replace NaN for the simulation time (transmissions could not be held)
    end
    
    for i = 1 : num_wlans
        if i == 1 % WLAN A
            % Throughput
            [max1, ix1] = max(throughput_per_wlan_komondor{i});
            max_tpt_wlan_a{p} = mean(max1);            
            % Channel occupation
            for x = 1 : 50
                channel_occupancy_wlan_a(x) = time_in_channel_per_wlan_komondor{i}(ix1(x), x);
            end
            max_time_channel_wlan_a{p} = mean(channel_occupancy_wlan_a);
            %[max2, ix2] = max(time_in_channel_per_wlan_komondor{i});
%                max_time_channel_wlan_a{p} = mean(max2);            
            % Delay
            [max3, ix3] = min(delay_per_wlan_komondor{i});
            min_delay_wlan_a{p} = mean(max3);            
        else % Rest of WLANs
            for x = 1 : 50
                throughput_others(x) = throughput_per_wlan_komondor{i}(ix1(x), x);
                occupancy_others(x) = time_in_channel_per_wlan_komondor{i}(ix1(x), x);
                delay_others(x) = delay_per_wlan_komondor{i}(ix3(x), x);
            end
            mean_tpt(i-1) = mean(throughput_others);
            default_mean_tpt(i-1) = mean(throughput_per_wlan_komondor{i}(21,:));
            %max_mean_occupancy(i-1) = mean(throughput_per_wlan_komondor{i}(ix2));
            mean_occupancy(i-1) = mean(occupancy_others);
            default_mean_occupancy(i-1) = mean(time_in_channel_per_wlan_komondor{i}(21,:));
            mean_delay(i-1) = mean(delay_others);
            default_mean_delay(i-1) = mean(delay_per_wlan_komondor{i}(21,:));
        end        
        default_tpt_per_wlan{p,i} = throughput_per_wlan_komondor{p,i}(21,:);
        default_time_channel_per_wlan{p,i} = time_in_channel_per_wlan_komondor{p,i}(21,:);
        default_delay_per_wlan{p,i} = delay_per_wlan_komondor{p,i}(21,:);                        
    end
       
    % AVERAGE MAX AND DEFAULT PERFORMANCE (EXCEPT WLAN A)
    % Throughput
    max_tpt_average{p} = mean(mean(mean_tpt));    
    % Channel occupation
    max_time_channel_average{p} = mean(mean(mean_occupancy));    
    % Delay
    min_delay_average{p} = mean(mean(mean_delay));   
    
    % Compute the average performance (except for A)
    tpt_array = [];
    for i = 2 : num_wlans
        tpt_array(i-1) = mean(default_tpt_per_wlan{p, i});
        occupancy_array(i-1) = mean(default_time_channel_per_wlan{p, i});
        delay_array(i-1) = mean(default_delay_per_wlan{p, i});
    end
    default_tpt_average{p} = mean(tpt_array);
    default_time_channel_average{p} = mean(occupancy_array);
    default_delay_average{p} = mean(delay_array);
    
    % Compute the average improvements with respect to the static situation
    mean_improvement_throughput_wlan_a{p} = max_tpt_wlan_a{p} - default_tpt_per_wlan{p, 1};
    mean_improvement_average_throughput{p} = max_tpt_average{p} - default_tpt_average{p};        
    mean_improvement_time_in_channel_wlan_a{p} = max_time_channel_wlan_a{p} - default_time_channel_per_wlan{p, 1};        
    mean_improvement_average_time_in_channel{p} = max_time_channel_average{p} - default_time_channel_average{p};        
    mean_improvement_delay_wlan_a{p} = min_delay_wlan_a{p} - default_delay_per_wlan{p, 1};
    mean_improvement_average_delay{p} = min_delay_average{p} - default_delay_average{p};
   
end

%% PART 2 - Plot the results

% Set font type
set(0,'defaultUicontrolFontName','Helvetica');
set(0,'defaultUitableFontName','Helvetica');
set(0,'defaultAxesFontName','Helvetica');
set(0,'defaultTextFontName','Helvetica');
set(0,'defaultUipanelFontName','Helvetica');

% - Plots CDF

% 1 - PERFORMANCE OF WLAN A

% Process the results for WLAN A

%   * Throughput of A - SR
[max_tpt_A(1,:), ix1] = max(throughput_per_wlan_komondor{1,1});
[max_tpt_A(2,:), ix2] = max(throughput_per_wlan_komondor{2,1});
[max_tpt_A(3,:), ix3] = max(throughput_per_wlan_komondor{3,1});
[f_tpt_A_legacy_SR,x_tpt_A_legacy_SR] = ecdf(max_tpt_A(1,:));
[f_tpt_A_mixed_SR,x_tpt_A_mixed_SR] = ecdf(max_tpt_A(2,:));
[f_tpt_A_all_SR,x_tpt_A_all_SR] = ecdf(max_tpt_A(3,:));
%   * Throughput of A - default
[f_tpt_A_legacy_default,x_tpt_A_legacy_default] = ecdf(default_tpt_per_wlan{1,1});
[f_tpt_A_mixed_default,x_tpt_A_mixed_default] = ecdf(default_tpt_per_wlan{2,1});
[f_tpt_A_all_default,x_tpt_A_all_default] = ecdf(default_tpt_per_wlan{3,1});
%   * Occupancy of A - SR
for i = 1 : 50
    max_occupancy(1,i) = time_in_channel_per_wlan_komondor{1,1}(ix1(i),i);
    max_occupancy(2,i) = time_in_channel_per_wlan_komondor{2,1}(ix2(i),i);
    max_occupancy(3,i) = time_in_channel_per_wlan_komondor{3,1}(ix3(i),i);
end
[f_occupancy_A_legacy_SR,x_occupancy_A_legacy_SR] = ecdf(max_occupancy(1,:));
[f_occupancy_A_mixed_SR,x_occupancy_A_mixed_SR] = ecdf(max_occupancy(2,:));
[f_occupancy_A_all_SR,x_occupancy_A_all_SR] = ecdf(max_occupancy(3,:));
%   * Occupancy of A - default
[f_occupancy_A_legacy_default,x_occupancy_A_legacy_default] = ecdf(default_time_channel_per_wlan{1,1});
[f_occupancy_A_mixed_default,x_occupancy_A_mixed_default] = ecdf(default_time_channel_per_wlan{2,1});
[f_occupancy_A_all_default,x_occupancy_A_all_default] = ecdf(default_time_channel_per_wlan{3,1});
%   * Delay of A - SR
[min_delay_A(1,:), ix1] = min(delay_per_wlan_komondor{1,1});
[min_delay_A(2,:), ix2] = min(delay_per_wlan_komondor{2,1});
[min_delay_A(3,:), ix3] = min(delay_per_wlan_komondor{3,1});
[f_delay_A_legacy_SR,x_delay_A_legacy_SR] = ecdf(min_delay_A(1,:));
[f_delay_A_mixed_SR,x_delay_A_mixed_SR] = ecdf(min_delay_A(2,:));
[f_delay_A_all_SR,x_delay_A_all_SR] = ecdf(min_delay_A(3,:));
%   * Throughput of A - default
[f_delay_A_legacy_default,x_delay_A_legacy_default] = ecdf(default_delay_per_wlan{1,1});
[f_delay_A_mixed_default,x_delay_A_mixed_default] = ecdf(default_delay_per_wlan{2,1});
[f_delay_A_all_default,x_delay_A_all_default] = ecdf(default_delay_per_wlan{3,1});

% Plot performance WLAN A

fig = figure('pos',[450 400 800 350]);
subplot(1,3,1)
plot(x_tpt_A_legacy_default, f_tpt_A_legacy_default,'g--','linewidth',1.5,'markersize',8)
hold on
plot(x_tpt_A_legacy_SR, f_tpt_A_legacy_SR,'g-','linewidth',1.5)
plot(x_tpt_A_mixed_default, f_tpt_A_mixed_default,'b--','linewidth',1.5,'markersize',8)
plot(x_tpt_A_mixed_SR, f_tpt_A_mixed_SR,'b-','linewidth',1.5)
plot(x_tpt_A_all_default, f_tpt_A_all_default,'r--','linewidth',1.5,'markersize',8)
plot(x_tpt_A_all_SR, f_tpt_A_all_SR,'r-','linewidth',1.5)
xlabel('Throughput, \Gamma_A [Mbps]')
ylabel('Empirical CDF(\Gamma_A)')
set(gca, 'FontSize', 18)
grid on
grid minor
ax = gca;
ax.GridAlpha = 0.5;
% OCCUPANCY
subplot(1,3,2)
plot(x_occupancy_A_legacy_default, f_occupancy_A_legacy_default,'g--','linewidth',1.5,'markersize',8)
hold on
plot(x_occupancy_A_legacy_SR, f_occupancy_A_legacy_SR,'g-','linewidth',1.5)
plot(x_occupancy_A_mixed_default, f_occupancy_A_mixed_default,'b--','linewidth',1.5,'markersize',8)
plot(x_occupancy_A_mixed_SR, f_occupancy_A_mixed_SR,'b-','linewidth',1.5)
plot(x_occupancy_A_all_default, f_occupancy_A_all_default,'r--','linewidth',1.5,'markersize',8)
plot(x_occupancy_A_all_SR, f_occupancy_A_all_SR,'r-','linewidth',1.5)
xlabel('Occupancy, \rho_A [%]')
ylabel('Empirical CDF(\rho_A)')
set(gca, 'FontSize', 18)
grid on
grid minor
ax = gca;
ax.GridAlpha = 0.5;
% DELAY
subplot(1,3,3)
plot(x_delay_A_legacy_default, f_delay_A_legacy_default,'g--','linewidth',1.5,'markersize',8)
hold on
plot(x_delay_A_legacy_SR, f_delay_A_legacy_SR,'g-','linewidth',1.5)
plot(x_delay_A_mixed_default, f_delay_A_mixed_default,'b--','linewidth',1.5,'markersize',8)
plot(x_delay_A_mixed_SR, f_delay_A_mixed_SR,'b-','linewidth',1.5)
plot(x_delay_A_all_default, f_delay_A_all_default,'r--','linewidth',1.5,'markersize',8)
plot(x_delay_A_all_SR, f_delay_A_all_SR,'r-','linewidth',1.5)
xlabel('Delay, d_A [ms]')
ylabel('Empirical CDF(d_A)')
set(gca, 'FontSize', 18)
xlim([0,50])
grid on
grid minor
ax = gca;
ax.GridAlpha = 0.5;  % Make grid lines less transparent.
hlegend = legend('A^{Default} (legacy)','A^{SR} (legacy)','A^{Default} (mixed)', ...
    'A^{SR} (mixed)', 'A^{Default} (all)', 'A^{SR} (all)');
hlegend.NumColumns=3;
save_figure( fig, 'SIM_2_3_1', './Simulations/Output/Random/' )

% 2 - PERFORMANCE OF THE OTHERS

% Process the results for the others

%   * Throughput of the others - SR
sum_tpt_1 = zeros(1,50);
sum_tpt_2 = zeros(1,50);
sum_tpt_3 = zeros(1,50);
for i = 1 : num_wlans-1
    for x = 1 : 50
        tpt_array_1(x) = throughput_per_wlan_komondor{1,i+1}(ix1(x),x);
        tpt_array_2(x) = throughput_per_wlan_komondor{2,i+1}(ix1(x),x);
        tpt_array_3(x) = throughput_per_wlan_komondor{3,i+1}(ix1(x),x);
    end
    sum_tpt_1 = sum_tpt_1 + tpt_array_1;
    sum_tpt_2 = sum_tpt_2 + tpt_array_2;
    sum_tpt_3 = sum_tpt_3 + tpt_array_3;
end
[f_tpt_others_legacy_SR,x_tpt_others_legacy_SR] = ecdf(sum_tpt_1/(num_wlans-1));
[f_tpt_others_mixed_SR,x_tpt_others_mixed_SR] = ecdf(sum_tpt_2/(num_wlans-1));
[f_tpt_others_all_SR,x_tpt_others_all_SR] = ecdf(sum_tpt_3/(num_wlans-1));
%   * Throughput of the others - default
sum_default_tpt_1 = zeros(1,50);
sum_default_tpt_2 = zeros(1,50);
sum_default_tpt_3 = zeros(1,50);
for i = 1 : num_wlans-1
    sum_default_tpt_1 = sum_default_tpt_1 + default_tpt_per_wlan{1,i+1};
    sum_default_tpt_2 = sum_default_tpt_1 + default_tpt_per_wlan{2,i+1};
    sum_default_tpt_3 = sum_default_tpt_1 + default_tpt_per_wlan{3,i+1};
end
[f_tpt_others_legacy_default,x_tpt_others_legacy_default] = ecdf(sum_default_tpt_1/(num_wlans-1));
[f_tpt_others_mixed_default,x_tpt_others_mixed_default] = ecdf(sum_default_tpt_2/(num_wlans-1));
[f_tpt_others_all_default,x_tpt_others_all_default] = ecdf(sum_default_tpt_3/(num_wlans-1));
%   * Occupancy of the others - SR
sum_occupancy_1 = zeros(1,50);
sum_occupancy_2 = zeros(1,50);
sum_occupancy_3 = zeros(1,50);
for i = 1 : num_wlans-1
    for x = 1 : 50
        occupancy_array_1(x) = time_in_channel_per_wlan_komondor{1,i+1}(ix1(x),x);
        occupancy_array_2(x) = time_in_channel_per_wlan_komondor{2,i+1}(ix1(x),x);
        occupancy_array_3(x) = time_in_channel_per_wlan_komondor{3,i+1}(ix1(x),x);
    end
    sum_occupancy_1 = sum_occupancy_1 + occupancy_array_1;
    sum_occupancy_2 = sum_occupancy_2 + occupancy_array_2;
    sum_occupancy_3 = sum_occupancy_3 + occupancy_array_3;
end
[f_occupancy_others_legacy_SR,x_occupancy_others_legacy_SR] = ecdf(sum_occupancy_1/(num_wlans-1));
[f_occupancy_others_mixed_SR,x_occupancy_others_mixed_SR] = ecdf(sum_occupancy_2/(num_wlans-1));
[f_occupancy_others_all_SR,x_occupancy_others_all_SR] = ecdf(sum_occupancy_3/(num_wlans-1));
%   * Occupancy of the others - default
sum_default_occupancy_1 = zeros(1,50);
sum_default_occupancy_2 = zeros(1,50);
sum_default_occupancy_3 = zeros(1,50);
for i = 1 : num_wlans-1
    sum_default_occupancy_1 = sum_default_occupancy_1 + default_time_channel_per_wlan{1,i+1};
    sum_default_occupancy_2 = sum_default_occupancy_1 + default_time_channel_per_wlan{2,i+1};
    sum_default_occupancy_3 = sum_default_occupancy_1 + default_time_channel_per_wlan{3,i+1};
end
[f_occupancy_others_legacy_default,x_occupancy_others_legacy_default] = ecdf(sum_default_occupancy_1/(num_wlans-1));
[f_occupancy_others_mixed_default,x_occupancy_others_mixed_default] = ecdf(sum_default_occupancy_2/(num_wlans-1));
[f_occupancy_others_all_default,x_occupancy_others_all_default] = ecdf(sum_default_occupancy_3/(num_wlans-1));
%   * Delay of the others - SR
sum_delay_1 = zeros(1,50);
sum_delay_2 = zeros(1,50);
sum_delay_3 = zeros(1,50);
for i = 1 : num_wlans-1
    for x = 1 : 50
        delay_array_1(x) = delay_per_wlan_komondor{1,i+1}(ix3(x),x);
        delay_array_2(x) = delay_per_wlan_komondor{2,i+1}(ix3(x),x);
        delay_array_3(x) = delay_per_wlan_komondor{3,i+1}(ix3(x),x);
    end
    sum_delay_1 = sum_delay_1 + delay_array_1;
    sum_delay_2 = sum_delay_2 + delay_array_2;
    sum_delay_3 = sum_delay_3 + delay_array_3;
end
[f_delay_others_legacy_SR,x_delay_others_legacy_SR] = ecdf(sum_delay_1/(num_wlans-1));
[f_delay_others_mixed_SR,x_delay_others_mixed_SR] = ecdf(sum_delay_2/(num_wlans-1));
[f_delay_others_all_SR,x_delay_others_all_SR] = ecdf(sum_delay_3/(num_wlans-1));
%   * Performance of other - default
sum_default_delay_1 = zeros(1,50);
sum_default_delay_2 = zeros(1,50);
sum_default_delay_3 = zeros(1,50);
for i = 1 : num_wlans-1
    sum_default_delay_1 = sum_default_delay_1 + default_delay_per_wlan{1,i+1};
    sum_default_delay_2 = sum_default_delay_1 + default_delay_per_wlan{2,i+1};
    sum_default_delay_3 = sum_default_delay_1 + default_delay_per_wlan{3,i+1};
end
[f_delay_others_legacy_default,x_delay_others_legacy_default] = ecdf(sum_default_delay_1/(num_wlans-1));
[f_delay_others_mixed_default,x_delay_others_mixed_default] = ecdf(sum_default_delay_2/(num_wlans-1));
[f_delay_others_all_default,x_delay_others_all_default] = ecdf(sum_default_delay_3/(num_wlans-1));

% Plot performance Others

fig = figure('pos',[450 400 800 350]);
subplot(1,3,1)
plot(x_tpt_others_legacy_default, f_tpt_others_legacy_default,'g--','linewidth',1.5,'markersize',8)
hold on
plot(x_tpt_others_legacy_SR, f_tpt_others_legacy_SR,'g-','linewidth',1.5)
plot(x_tpt_others_mixed_default, f_tpt_others_mixed_default,'b--','linewidth',1.5,'markersize',8)
plot(x_tpt_others_mixed_SR, f_tpt_others_mixed_SR,'b-','linewidth',1.5)
plot(x_tpt_others_all_default, f_tpt_others_all_default,'r--','linewidth',1.5,'markersize',8)
plot(x_tpt_others_all_SR, f_tpt_others_all_SR,'r-','linewidth',1.5)
xlabel('Throughput, \Gamma_O [Mbps]')
ylabel('Empirical CDF(\Gamma_O)')
set(gca, 'FontSize', 18)
grid on
grid minor
ax = gca;
ax.GridAlpha = 0.5;
% OCCUPANCY
subplot(1,3,2)
plot(x_occupancy_others_legacy_default, f_occupancy_others_legacy_default,'g--','linewidth',1.5,'markersize',8)
hold on
plot(x_occupancy_others_legacy_SR, f_occupancy_others_legacy_SR,'g-','linewidth',1.5)
plot(x_occupancy_others_mixed_default, f_occupancy_others_mixed_default,'b--','linewidth',1.5,'markersize',8)
plot(x_occupancy_others_mixed_SR, f_occupancy_others_mixed_SR,'b-','linewidth',1.5)
plot(x_occupancy_others_all_default, f_occupancy_others_all_default,'r--','linewidth',1.5,'markersize',8)
plot(x_occupancy_others_all_SR, f_occupancy_others_all_SR,'r-','linewidth',1.5)
xlabel('Occupancy, \rho_O [%]')
ylabel('Empirical CDF(\rho_O)')
set(gca, 'FontSize', 18)
grid on
grid minor
ax = gca;
ax.GridAlpha = 0.5;
% DELAY
subplot(1,3,3)
plot(x_delay_others_legacy_default, f_delay_others_legacy_default,'g--','linewidth',1.5,'markersize',8)
hold on
plot(x_delay_others_legacy_SR, f_delay_others_legacy_SR,'g-','linewidth',1.5)
plot(x_delay_others_mixed_default, f_delay_others_mixed_default,'b--','linewidth',1.5,'markersize',8)
plot(x_delay_others_mixed_SR, f_delay_others_mixed_SR,'b-','linewidth',1.5)
plot(x_delay_others_all_default, f_delay_others_all_default,'r--','linewidth',1.5,'markersize',8)
plot(x_delay_others_all_SR, f_delay_others_all_SR,'r-','linewidth',1.5)
xlabel('Delay, d_O [ms]')
ylabel('Empirical CDF(d_O)')
set(gca, 'FontSize', 18)
xlim([0,200])
grid on
grid minor
ax = gca;
ax.GridAlpha = 0.5;  % Make grid lines less transparent.
hlegend = legend('O^{Default} (legacy)','O^{SR} (legacy)','O^{Default} (mixed)', ...
    'O^{SR} (mixed)', 'O^{Default} (all)', 'O^{SR} (all)');
hlegend.NumColumns=3;
save_figure( fig, 'SIM_2_3_2', './Simulations/Output/Random/' )

%% PART 3 - Save the workspace
save('./Simulations/Output/Random/SIM_2_3_alternative.mat')