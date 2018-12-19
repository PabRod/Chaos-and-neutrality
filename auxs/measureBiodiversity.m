function updatedResults = measureBiodiversity(resultsArrayLocation, summarize)
%MEASUREBIODIVERSITY Updates the resultsArray with biodiversity indices

%% Load results
resultsArray = loadResults(resultsArrayLocation);

%% Charachterize chaos using different tests
% Pre-allocate containers
[rows, cols] = size(resultsArray);
N = rows.*cols;
competition_pars = zeros(1, cols);

counter = 1;
for j = 1:cols
    competition_pars(j) = resultsArray{1,j}.competition_par;
    for i = 1:rows
        threshold = 1e-2;
        [nPreySpeciesAlive, nPredSpeciesAlive, nPreySpeciesAlive_c, nSpeciesAlive] = countSpecies(resultsArray{i,j}, threshold, summarize);
        resultsArray{i,j}.biodiversity.nPreySpeciesAlive = nPreySpeciesAlive;
        resultsArray{i,j}.biodiversity.nPredSpeciesAlive = nPredSpeciesAlive;
        resultsArray{i,j}.biodiversity.nPreySpeciesAlive_c = nPreySpeciesAlive_c;
        resultsArray{i,j}.biodiversity.nSpeciesAlive = nSpeciesAlive;
        
        evennessAll = evenness(resultsArray{i,j}, 'all', summarize);
        evennessPrey = evenness(resultsArray{i,j}, 'preyonly', summarize);
        evennessPred = evenness(resultsArray{i,j}, 'predonly', summarize);
        resultsArray{i,j}.biodiversity.evenness = evennessAll;
        resultsArray{i,j}.biodiversity.evennessPrey = evennessPrey;
        resultsArray{i,j}.biodiversity.evennessPred = evennessPred;
        
        counter = counter + 1;
    end
end

%% Update results
updatedResults = resultsArray;

end