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
        nPrey = resultsArray{i,j}.dims(1);
        nPred = resultsArray{i,j}.dims(2);
        
        % Extract time series
        ys = resultsArray{i,j}.timeseries.ys;
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
        resultsArray{i,j}.biodiversity.predBiomass = [sum(mean(ysPred)), mean(std(ysPred))];
        resultsArray{i,j}.biodiversity.biomass = resultsArray{i,j}.biodiversity.preyBiomass + ...
                                                 resultsArray{i,j}.biodiversity.predBiomass;
        
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