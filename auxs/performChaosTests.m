function updatedResults = performChaosTests(resultsArrayLocation, visual)
%DISPLAYRESULTS Updates the resultsArray with the results of 4 chaos tests

%% Set defaults
if nargin == 1
    visual = false;
end

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
        
        if visual
            % This test is manual and thus, time consuming. We want to
            % avoid it easily.
            fprintf('Case %i of %i \n', counter, N);
            if isChaos_z12(i,j)
                resultsArray{i,j}.chaosTests.visual = isChaos(resultsArray{i,j}, 'visual');
            else
                resultsArray{i,j}.chaosTests.visual = 0;
            end
        else
            resultsArray{i,j}.chaosTests.visual = NaN;
        end
        
        counter = counter + 1;

    end
end

%% Update results
updatedResults = resultsArray;

end