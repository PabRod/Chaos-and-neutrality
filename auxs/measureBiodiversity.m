function updatedResults = measureBiodiversity(resultsArrayLocation, summarize)
%MEASUREBIODIVERSITY Updates the resultsArray with biodiversity indices

%% Load results
resultsArray = loadResults(resultsArrayLocation);

%% Measure biodiversity using different criterions
% Pre-allocate containers
[rows, cols] = size(resultsArray);
N = rows.*cols;
competition_pars = zeros(1, cols);

counter = 1;
for j = 1:cols
    competition_pars(j) = resultsArray{1,j}.competition_par;
    for i = 1:rows
        % Extract and measure current result
        result = resultsArray{i,j};
        nPrey = result.dims(1);
        nPred = result.dims(2);
        
        % Extract time series
        ys = result.timeseries.ys;
        ysPrey = ys(:, 1:nPrey);
        ysPred = ys(:, nPrey+1:nPrey+nPred);
        
        % Measure biodiversity
        % Number of non extinct species
        threshold = 1e-2;
        resultsArray{i,j}.biodiversity.nPreySpeciesAlive2 = countNonExtinct(ysPrey, threshold);
        resultsArray{i,j}.biodiversity.nPredSpeciesAlive2 = countNonExtinct(ysPred, threshold);
        resultsArray{i,j}.biodiversity.nSpeciesAlive2 = resultsArray{i,j}.biodiversity.nPreySpeciesAlive2 + ...
                                                        resultsArray{i,j}.biodiversity.nPredSpeciesAlive2;
                                       
        % Mean biomass
        resultsArray{i,j}.biodiversity.preyBiomass = [sum(mean(ysPrey)), mean(std(ysPrey))];
        resultsArray{i,j}.biodiversity.predBiomass = [sum(mean(ysPred)), mean(std(ysPrey))];
        resultsArray{i,j}.biodiversity.biomass = resultsArray{i,j}.biodiversity.preyBiomass + ...
                                                 resultsArray{i,j}.biodiversity.predBiomass;
                      
        % Evenness
        evennessAll = evenness(resultsArray{i,j}, 'all', summarize);
        evennessPrey = evenness(resultsArray{i,j}, 'preyonly', summarize);
        evennessPrey_c = evenness(resultsArray{i,j}, 'preyonly_c', summarize);
        evennessPred = evenness(resultsArray{i,j}, 'predonly', summarize);
        resultsArray{i,j}.biodiversity.evenness = evennessAll;
        resultsArray{i,j}.biodiversity.evennessPrey = evennessPrey;
        resultsArray{i,j}.biodiversity.evennessPrey_c = evennessPrey_c;
        resultsArray{i,j}.biodiversity.evennessPred = evennessPred;
        
        counter = counter + 1;
    end
end

%% Update results
updatedResults = resultsArray;

end

function ns = countNonExtinct(ys, threshold)
    nTot = size(ys, 2); % Time goes row-wise, specie goes column-wise
    ns = nTot - sum(all(ys <= threshold));
end