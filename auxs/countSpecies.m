function [ nPreySpeciesAlive, nPredSpeciesAlive ] = countSpecies(result, threshold)
%COUNTSPECIES Counts the number of alive species
%   Returns a vector with the number of alive (non extinct) species, 
%   classified as predator and prey species, at each time

%% Extract the time series
ys = result.timeseries.ys;

%% Separate prey and predators
nPrey = result.dims(1);
nPred = result.dims(2);

ysPrey = ys(:, 1:nPrey);
ysPred = ys(:, nPrey+1:nPrey+nPred);

%% Count the non extinct species
nPreySpeciesAlive = sum(ysPrey' >= threshold);
nPredSpeciesAlive = sum(ysPred' >= threshold);

end

