%%
cclear;

%%
% files = {'2-3d_lw.mat', '4-6d_lw.mat', '6-9d_lw.mat', '8-12d_lw.mat', '10-15d_lw.mat', ... 
%          '12-18d_lw.mat', '14-21d_lw.mat', '16-24d_lw.mat', '18-27d_lw.mat', '20-30d_lw.mat'};
     
% files = {'2-3n.mat', '4-6n.mat', '6-9n.mat', '8-12n.mat', '10-15n.mat', '12-18n.mat', '14-21n.mat', '16-24n.mat', '18-27n.mat', '20-30n.mat'};

files = {'2-3m.mat', '4-6m.mat', '6-9m.mat', '8-12m.mat', '10-15m.mat', '12-18m.mat', '14-21m.mat', '16-24m.mat', '18-27m.mat', '20-30m.mat'};

%% Estimated probability of chaos
% for i = 1:numel(files)
%     resultsArray = loadResults(files{i});
%     figure('units', 'normalized', 'outerposition', [0 0 1 1]);
%     subplot(2, 1, 1);
%     createFigures(resultsArray, 'comparer');
%     subplot(2, 1, 2);
%     createFigures(resultsArray, 'summary');
% end

%% Contour plot
figure;
contourFig(files);
title('Probability of chaos');
xlabel('Competition parameter');
ylabel('Number of interacting species');