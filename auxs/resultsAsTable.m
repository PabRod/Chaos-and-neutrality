function T = resultsAsTable(resultsArrayLocation)
%RESULTSASTABLE Extracts simulation results' information and sorts it as a
%table

%% Load results
resultsArray = loadResults(resultsArrayLocation);

%% Measure size
[nreps, npars] = size(resultsArray);

%% Build table
for i = 1:nreps*npars % Append rows
    array = resultsArray{i};
    
    % Flatten the inner structures
    chaosTests = struct2table(array.chaosTests);
    biodiversity = struct2table(array.biodiversity);
    
    % Remove duplicated information
    array = rmfield(array, 'chaosTests');
    array = rmfield(array, 'biodiversity');
    
    % Append lines to table
    newline = [struct2table(array), chaosTests, biodiversity];
    if i == 1
        T = newline;
    else
        T = [T; newline];
    end
end