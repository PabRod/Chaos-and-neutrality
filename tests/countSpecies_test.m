%%
close all;
clear;
clc;

%%
load('temp.mat');

%%
results = resultsArray{1, 4};
ts = results.timeseries.ts;

threshold = 0.1;
[nPreySpeciesAlive, nPredSpeciesAlive ] = countSpecies(results, threshold);
nSpeciesAlive = nPreySpeciesAlive + nPredSpeciesAlive;

plot(ts, results.timeseries.ys);
hold on;
plot(ts, nSpeciesAlive , 'Color', 'k');
plot([ts(1), ts(end)], mean(nSpeciesAlive)*[1, 1], 'Color', 'k', 'LineStyle', '--');
plot([ts(1), ts(end)], mean(nSpeciesAlive)*[1, 1] + std(nSpeciesAlive)*[1 1], 'Color', 'k', 'LineStyle', '--');
plot([ts(1), ts(end)], mean(nSpeciesAlive)*[1, 1] - std(nSpeciesAlive)*[1 1], 'Color', 'k', 'LineStyle', '--');