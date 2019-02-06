%%
close all;
clear;
clc;

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

subFiles = {'4-6p.mat', ...
    '10-15p.mat', ...
    '20-30p.mat'};

subTitles = {'4 + 6 species', ...
    '10 + 15 species', ...
    '20 + 30 species'};

NAll = numel(allFiles);
NSub = numel(subFiles);

%% General settings
set(0, 'DefaultTextInterpreter', 'latex');
set(0, 'DefaultLegendInterpreter', 'latex');
set(0, 'DefaultAxesTickLabelInterpreter', 'latex');

%% Appendix: selected slices
fig1 = figure;
for i = NSub:-1:1 % Bigger first
    file = subFiles{i};
    
    createFigures(file, 'z1'); hold on;
    title('');
end
lgd = legend(subTitles{3:-1:1});
lgd.FontSize = 18;
xlabel('Competition parameter', 'FontSize', 18);
ylabel('Probability of chaos', 'FontSize', 18);
set(fig1, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
saveas(fig1, '..\paper\img\results.png');

%% Appendix: all slices 2
fig4 = figure;
for i = NAll:-1:1 % Bigger first
    file = allFiles{i};
    
    createFigures(file, 'z1'); hold on;
    title('');
    xlabel('');
end
xlabel('Competition parameter', 'FontSize', 18);
ylabel('Probability of chaos', 'FontSize', 18);
lgd = legend(allTitles{NAll:-1:1});
lgd.FontSize = 18;

xlim([-0.8, 0.8]);
set(fig4, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
saveas(fig4, '..\paper\img\results_all.png');

%% Appendix: chaos detection comparer
fig5 = figure;

subplot(3, 1, 1);
contourFig(allFiles, 'lyaps');
title('Using estimated max Lyapunov', 'FontSize', 16);
xlabel('');
ylabel('');

subplot(3, 1, 2);
contourFig(allFiles, 'z12');
title('Using z1 soft', 'FontSize', 16);
xlabel('');
ylabel('Number of species (predators + prey)', 'FontSize', 16);

subplot(3, 1, 3);
contourFig(allFiles, 'z1');
title('Using z1 hard', 'FontSize', 16);
xlabel('Competition parameter', 'FontSize', 14);
ylabel('');
set(fig5, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 0.6, 0.99]);
saveas(fig5, '..\paper\img\contours_all.png');

%% Appendix biodiversity split in 3
fig_biodsplitbydynamics = figure;
for i = 1:numel(allFiles)
    subplot(2, 5, i);
    createFigures(allFiles{i}, 'biodsplitbydynamics');
    legend('off'); % Only one legend will be shown, at the last panel
    title(allTitles{i});
    
    % Tweak aesthetics
    if((i == 1) || (i == 6)) % Minimize use of ylabel
        ylabel('Prey biodiversity');
    else
        ylabel('');
    end
    
    if(i >= 6) % Minimize use of xlabel
        xlabel('Competition parameter');
    else
        xlabel('');
    end
    
end
legend({'Group: regular dynamics', 'Group: chaotic dynamics', 'Total'}, 'Location', 'southeast');

set(fig_biodsplitbydynamics, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
saveas(fig_biodsplitbydynamics, '..\paper\img\biod_split_by_dynamics.png');

%% Appendix: biodiversity box and whisker
fig9 = figure;
for i = 1:numel(allFiles)
    subplot(2, 5, i);
    createFigures(allFiles{i}, 'biodboxandwhisker');
    title(allTitles{i});
    
    % Tweak aesthetics
    if((i == 1) || (i == 6)) % Minimize use of ylabel
        ylabel('Prey biodiversity');
    else
        ylabel('');
    end
    
    if(i >= 6) % Minimize use of xlabel
        xlabel('Dynamic regime');
    else
        xlabel('');
    end
end

set(fig9, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
saveas(fig9, '..\paper\img\biod_box_and_whisker.png');

%% Restore default settings
set(0, 'DefaultTextInterpreter', 'default');
set(0, 'DefaultLegendInterpreter', 'default');
set(0, 'DefaultAxesTickLabelInterpreter', 'default');