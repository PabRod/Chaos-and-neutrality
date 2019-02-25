%%
close all;
clear;
clc;

%% Figs folder
figs_folder = '.\'; % '..\paper\img\';

%%
allFiles = {'2-3p.mat', ...
    '4-6p.mat', ...
    '6-9p.mat', ...
    '8-12p.mat', ...
    '10-15p.mat', ...
    '12-18p.mat', ...
    '14-21p.mat', ...
    '16-24p.mat', ...
    '18-27p.mat', ...
    '20-30p.mat'};

allTitles = {'2 + 3 species', ...
    '4 + 6 species', ...
    '6 + 9 species', ...
    '8 + 12 species', ...
    '10 + 15 species', ...
    '12 + 18 species', ...
    '14 + 21 species', ...
    '16 + 24 species', ...
    '18 + 27 species', ...
    '20 + 30 species'};

bestFile = '8-12p.mat';
bestTitle = '8 + 12 species';

NAll = numel(allFiles);

%% General settings
set(0, 'DefaultTextInterpreter', 'latex');
set(0, 'DefaultLegendInterpreter', 'latex');
set(0, 'DefaultAxesTickLabelInterpreter', 'latex');

%% Best file
fig_best = figure;

resultsArrayLight = loadResults(bestFile);

subplot(2, 3, [1, 2]);
createFigures(resultsArrayLight, 'dynamics');
title('A. Long-term dynamics');
xlim([-0.8, 0.8]);

subplot(2, 3, [3]);
createFigures(resultsArrayLight, 'biodboxandwhisker');
title('B. Effect of dynamics on biodiversity');

subplot(2, 3, [4, 5]);
createFigures(resultsArrayLight, 'biodsplitbydynamics');
title('C. Detailed overview of prey biodiversity');
xlim([-0.8, 0.8]);

subplot(2, 3, [6]);
createFigures(resultsArrayLight, 'biomass');
hold on;
createFigures(resultsArrayLight, 'predbiomass');
title('D. Biomasses');
legend({'Prey', 'Predators'});

set(fig_best, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
saveas(fig_best, strcat(figs_folder, 'best.png'));

%% Main body: Contour plot
fig2 = figure;
contourFig(allFiles, 'z12');

title('Estimated probability of chaos', 'FontSize', 16);
xlabel('Competition parameter', 'FontSize', 14);
ylabel('Number of species (predators + prey)', 'FontSize', 14);
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
saveas(fig2,  strcat(figs_folder, 'contour.png'));

%% Restore default settings
set(0, 'DefaultTextInterpreter', 'default');
set(0, 'DefaultLegendInterpreter', 'default');
set(0, 'DefaultAxesTickLabelInterpreter', 'default');