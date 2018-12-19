function [ nPreySpeciesAlive, nPredSpeciesAlive, nPreySpeciesAlive_c, nSpeciesAlive] = countSpecies(result, threshold, summarize)
%COUNTSPECIES Counts the number of alive species
%   Returns a vector with the number of alive (non extinct) species, 
%   classified as predator and prey species, at each time

if nargin == 2
    summarize = false;
end

%% Extract the time series
ys = result.timeseries.ys;
ys_c = result.timeseries.ys_c;

%% Separate prey and predators
nPrey = result.dims(1);
nPred = result.dims(2);

ysPrey = ys(:, 1:nPrey);
ysPred = ys(:, nPrey+1:nPrey+nPred);

%% Count the non extinct species
nPreySpeciesAlive = sum(ysPrey' >= threshold);
nPredSpeciesAlive = sum(ysPred' >= threshold);
nPreySpeciesAlive_c = sum(ys_c' >= threshold);
nSpeciesAlive = nPreySpeciesAlive + nPredSpeciesAlive;

if summarize
    nPreySpeciesAlive = [mean(nPreySpeciesAlive), std(nPreySpeciesAlive)];
    nPredSpeciesAlive = [mean(nPredSpeciesAlive), std(nPredSpeciesAlive)];
    nPreySpeciesAlive_c = [mean(nPreySpeciesAlive_c), std(nPreySpeciesAlive_c)];
    nSpeciesAlive = [mean(nSpeciesAlive), std(nSpeciesAlive)];
end

end

