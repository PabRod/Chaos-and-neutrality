function contourFig(files)

competition_pars = resultsAsMatrix(files{1}, 'competition_par');
summaries = NaN(numel(files), numel(competition_pars));
nSpecies = NaN(1, numel(files));
for i = 1:numel(files)
    resultsArrayLocation = files{i};
    clear resultsArray;
    resultsArray = loadResults(resultsArrayLocation); 
    nSpecies(i) = sum(resultsArray{1,1}.dims);
    [~, ~, ~, ~, summary, ~] = computeProbabilities(resultsArray);
    summaries(i, :) = summary;
end

%% Plot
levels = [.0, .1, .2, .3, .4, .5, .6, .7, .8, .9, .95, .975, 0.99, 1];
[c, h] = contourf(competition_pars, nSpecies, summaries, levels);
xlim([-1 1]);
clabel(c, h);

end