%% Clean environment
clear;
close all;
clc;

%% Load data
dataFiles = {'ggb/constant.csv', ...
            'ggb/periodic.csv', ...
            'ggb/chaotic_long.csv'};
        
for i = 1:numel(dataFiles)
    data = csvread(dataFiles{i});
    y{i} = data';
end

%% Parameters
theta = 0.7;
N = 500;

%% z1 test
for i = 1:numel(dataFiles)
   [p{i}, q{i}, M{i}] = z1ChaosTest(y{i}, theta, N);
end

%% Plot
titles = {'Constant time series', ...
          'Periodic time series', ...
          'Chaotic time series'};
      
for i = 1:numel(dataFiles)
    subplot(1, 3, i);
    plot(p{i}, q{i});
    title(titles{i});
    xlabel('p_n');
    ylabel('q_n');
    %axis equal;
end