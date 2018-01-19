function output = resultsAsMatrix(resultsArrayLocation, prompt)
%RESULTSASMATRIX Extracts vectorial and matricial information inside
%resultsArray in matrix format

%% Load results
resultsArray = loadResults(resultsArrayLocation);

%% Measure size
[nreps, npars] = size(resultsArray);

%% Extract required information
switch prompt
        
    case 'competition_par'
        % Vector of competition parameters
        output = NaN(1, npars);
        for j = 1:npars
            output(j) = resultsArray{1, j}.competition_par;
        end
        
    case 'maxLyapunov'
        % Matrix of maximum Lyapunov exponents
        output = NaN(nreps, npars);
        for i = 1:nreps
            for j = 1:npars
                output(i,j) = resultsArray{i, j}.maxLyapunov;
            end
        end
        
    case 'lyapunov'
        % Matrix of chaos according to Lyapunov test
        output = NaN(nreps, npars);
        for i = 1:nreps
            for j = 1:npars
                output(i,j) = resultsArray{i, j}.chaosTests.lyapunov;
            end
        end
        
    case 'z1'
        % Matrix of chaos according to z1 test
        output = NaN(nreps, npars);
        for i = 1:nreps
            for j = 1:npars
                output(i,j) = resultsArray{i, j}.chaosTests.z1;
            end
        end
        
    case 'z12'
        % Matrix of chaos according to z12 test
        output = NaN(nreps, npars);
        for i = 1:nreps
            for j = 1:npars
                output(i,j) = resultsArray{i, j}.chaosTests.z12;
            end
        end
        
    case 'visual'
        % Matrix of chaos according to visual inspection test
        output = NaN(nreps, npars);
        for i = 1:nreps
            for j = 1:npars
                output(i,j) = resultsArray{i, j}.chaosTests.visual;
            end
        end
        
    otherwise
        error('Wrong prompt. Use: competition_par, maxLyapunov, z1, z12 or visual');
    
end

end

