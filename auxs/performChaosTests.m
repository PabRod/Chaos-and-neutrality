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
        % Check stability
        ys = resultsArray{i,j}.timeseries.ys;
        nsteps = size(ys, 1);
        ys_subset = ys(round(2*nsteps/3):end ,:); % Use only the last 2/3 of the time series
        stable = isStable(ys_subset);
        resultsArray{i,j}.chaosTests.isstable = stable;
        
        if(stable)
            % If is stable, it cannot be chaotic
            resultsArray{i,j}.chaosTests.lyapunov = false;
            resultsArray{i,j}.chaosTests.z1 = false;
            resultsArray{i,j}.chaosTests.z12 = false;
        else
            % Run different tests for chaos
            resultsArray{i,j}.chaosTests.lyapunov = isChaos(resultsArray{i,j}, 'lyapunov');
            resultsArray{i,j}.chaosTests.z1 = isChaos(resultsArray{i,j}, 'z1');
            resultsArray{i,j}.chaosTests.z12 = isChaos(resultsArray{i,j}, 'z12');
        end
        
        resultsArray{i,j}.chaosTests.dynamics = decideDynamics(resultsArray{i,j});
        
        counter = counter + 1;

    end
end

%% Update results
updatedResults = resultsArray;

end

function dyn = decideDynamics(result)
    if result.chaosTests.isstable
        dyn = string('stable');
    elseif result.chaosTests.z12
        dyn = string('chaotic');
    else
        dyn = string('cyclic');
    end
end