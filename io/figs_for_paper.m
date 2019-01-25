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

subFiles = {'2-3p.mat', ...
    '4-6p.mat', ...
    '12-18p.mat'};

subTitles = {'5 species', ...
    '10 species', ...
    '30 species'};

NAll = numel(allFiles);
NSub = numel(subFiles);

%% Main body: slices
fig1 = figure;
for i = NSub:-1:1 % Bigger first
    file = subFiles{i};
    
    createFigures(file, 'z1'); hold on;
    title('');
end
legend(subTitles{3:-1:1});
xlabel('\fontsize{14} Competition parameter \epsilon');
ylabel('\fontsize{14} Probability of chaos');
set(fig1, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
saveas(fig1, '..\paper\img\results.png');

%% Main body: Contour plot
fig2 = figure;
contourFig(allFiles, 'z12');

title('\fontsize{16} Estimated probability of chaos');
xlabel('\fontsize{14} Competition parameter \epsilon');
ylabel('\fontsize{14} Number of species (predators + prey)');
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
saveas(fig2, '..\paper\img\contour.png');

%% Main figures (individual)
for i = 1:NAll
    file = allFiles{i};
    resultsArrayLight = loadResults(file);
    
    fig_conclusions_temp = figure;
    subplot(2, 1, 1);
    createFigures(resultsArrayLight, 'z12');
    
    subplot(2, 1, 2);
    createFigures(resultsArrayLight, 'biodsplitbychaos');
    
    set(fig_conclusions_temp, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
    
    name = resultsArrayLight{1,1}.id;
    filename = char(strcat('..\paper\img\', name, '.png'));
    saveas(fig_conclusions_temp, filename);
end

%% Appendix: All slices
% fig3 = figure;
% for i = 1:NAll
%     file = allFiles{i};
%     
%     subplot(NAll, 1, i);
%     createFigures(file, 'z1');
%     
%     % Tweak aesthetics
%     title('');
%     xlabel('');
%     if i == 5
%         ylabel('Estimated probability of chaos');
%     else
%         ylabel('');
%     end
%     legend(allTitles{i});
% end
% xlabel('Competition parameter \epsilon');
% set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);

%% Appendix: all slices 2
fig4 = figure;
for i = NAll:-1:1 % Bigger first
    file = allFiles{i};
    
    createFigures(file, 'z1'); hold on;
    title('');
end
legend(allTitles{NAll:-1:1});
xlabel('\fontsize{14} Competition parameter \epsilon');
ylabel('\fontsize{14} Probability of chaos');
set(fig4, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
saveas(fig4, '..\paper\img\results_all.png');

%% Appendix: chaos detection comparer
fig5 = figure;

subplot(3, 1, 1);
contourFig(allFiles, 'lyaps');
title('\fontsize{16} Using estimated max Lyapunov');
xlabel('');
ylabel('');

subplot(3, 1, 2);
contourFig(allFiles, 'z12');
title('\fontsize{16} Using z1 soft');
xlabel('');
ylabel('\fontsize{16} Number of species (predators + prey)');

subplot(3, 1, 3);
contourFig(allFiles, 'z1');
title('\fontsize{16} Using z1 hard');
xlabel('\fontsize{14} Competition parameter \epsilon');
ylabel('');
set(fig5, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 0.6, 0.99]);
saveas(fig5, '..\paper\img\contours_all.png');

%% Prey count
fig6 = figure;
for i = NAll:-1:1
    file = allFiles{i};
    
    createFigures(file, 'preyCount'); hold on;
end
title('\fontsize{16} Biodiversity');
xlabel('\fontsize{14} Competition parameter \epsilon');
ylabel('\fontsize{14} NPrey');
legend(allTitles{NAll:-1:1});

xlim([-0.8, 0.8]);
set(fig6, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
saveas(fig6, '..\paper\img\biodiversity.png');

%% Evenness
% figure;
% for i = NAll:-1:1
%     file = allFiles{i};
%     
%     subplot(10, 1, i);
%     createFigures(file, 'preyEven');
%     title('');
%     xlabel('');
%     ylabel('');
% end
% %title('\fontsize{16} Prey evenness');
% %xlabel('\fontsize{14} Competition parameter \epsilon');
% %ylabel('\fontsize{14} (Evenness_{without predation} - Evenness)');
% legend(allTitles{NAll:-1:1});
% set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);

%% Combined plot
% fig7 = figure;
% 
% subplot(2, 1, 1);
% for i = NAll:-1:1 % Bigger first
%     file = allFiles{i};
%     
%     createFigures(file, 'z1'); hold on;
%     title('');
% end
% 
% xlabel('');
% ylabel('\fontsize{14} Probability of chaos');
% 
% subplot(2, 1, 2);
% for i = NAll:-1:1
%     file = allFiles{i};
%     
%     createFigures(file, 'preyCount'); hold on;
% end
% title('');
% xlabel('\fontsize{14} Competition parameter \epsilon');
% ylabel('\fontsize{14} (NPrey_{without predation} - NPrey)');
% legend(allTitles{NAll:-1:1});
% 
% xlim([-0.8, 0.8]);
% ylim([0, 16]);
% 
% set(fig7, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 0.8, 0.99]);
% saveas(fig7, '..\paper\img\combined_panel.png');

%% Biodiversity: Chaos vs. non chaos
fig_biodchaosvsregular = figure;
for i = 1:numel(allFiles)
    subplot(2, 5, i);
    createFigures(allFiles{i}, 'biodchaosvsregular');
    title('Biodiversity');
    legend(allTitles{i});
end

set(fig_biodchaosvsregular, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
saveas(fig_biodchaosvsregular, '..\paper\img\biod_chaos_vs_regular.png');

%% Evenness: Chaos vs. non chaos
% fig_evenchaosvsregular = figure;
% for i = 1:numel(allFiles)
%     subplot(2, 5, i);
%     createFigures(allFiles{i}, 'evenchaosvsregular');
%     title('Evenness');
%     legend(allTitles{i});
% end
% 
% set(fig_evenchaosvsregular, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
% saveas(fig_evenchaosvsregular, '..\paper\img\even_chaos_vs_regular.png');

%% Biodiversity: Box and whisker
fig9 = figure;
for i = 1:numel(allFiles)
    subplot(2, 5, i);
    createFigures(allFiles{i}, 'biodboxandwhisker');
    title(allTitles{i});
end

set(fig9, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
saveas(fig9, '..\paper\img\biod_box_and_whisker.png');

%% Biodiversity vs. max Lyap
% fig10 = figure;
% for i = 1:numel(allFiles)
%     subplot(2, 5, i);
%     createFigures(allFiles{i}, 'biodvslyap');
%     title(allTitles{i});
% end
% 
% set(fig10, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
% saveas(fig10, '..\paper\img\biod_vs_lyap.png');

%% Biodiversity: Split in 2
fig_biodsplitbychaos = figure;
for i = 1:numel(allFiles)
    subplot(2, 5, i);
    createFigures(allFiles{i}, 'biodsplitbychaos');
    title(allTitles{i});
end

set(fig_biodsplitbychaos, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
saveas(fig_biodsplitbychaos, '..\paper\img\biod_split_by_chaos.png');

%% Evenness: Split in 2
% fig_evensplitbychaos = figure;
% for i = 1:numel(allFiles)
%     subplot(2, 5, i);
%     createFigures(allFiles{i}, 'evensplitbychaos');
%     title(allTitles{i});
% end
% 
% set(fig_evensplitbychaos, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
% saveas(fig_evensplitbychaos, '..\paper\img\even_split_by_chaos.png');

%% Biodiversity: Split in 2 diff
fig_biodsplitbychaosdiff = figure;
for i = 1:numel(allFiles)
    subplot(2, 5, i);
    createFigures(allFiles{i}, 'biodsplitbychaosdiff');
    title(allTitles{i});
end

set(fig_biodsplitbychaosdiff, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
saveas(fig_biodsplitbychaosdiff, '..\paper\img\biod_split_by_chaos_diff.png');