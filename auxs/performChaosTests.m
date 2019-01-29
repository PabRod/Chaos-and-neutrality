function updatedResults = performChaosTests(resultsArrayLocation)
%DISPLAYRESULTS Updates the resultsArray with the results of 3 chaos tests

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
        % Run different tests for chaos
        resultsArray{i,j}.chaosTests.lyapunov = isChaos(resultsArray{i,j}, 'lyapunov');
        resultsArray{i,j}.chaosTests.z1 = isChaos(resultsArray{i,j}, 'z1');
        resultsArray{i,j}.chaosTests.z12 = isChaos(resultsArray{i,j}, 'z12');
        resultsArray{i,j}.chaosTests.constant = isStable(resultsArray{i,j}.timeseries.ys);
        counter = counter + 1;

    end
end

%% Update results
updatedResults = resultsArray;

end