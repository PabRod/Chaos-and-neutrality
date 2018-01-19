function [probChaos_using_Lyaps, probChaos_using_z1, probChaos_using_z1_2, summary, binaryComparer] = computeProbabilities(resultsArrayLocation)
%COMPUTEPROBABILITIES Summary of this function goes here
%   Detailed explanation goes here

%% Load results
resultsArray = loadResults(resultsArrayLocation);

%% Measure the array
[nreps, npars] = size(resultsArray);

%% Extract information as matrices
isChaos_Lyap = resultsAsMatrix(resultsArray, 'lyapunov');
isChaos_z1 = resultsAsMatrix(resultsArray, 'z1');
isChaos_z1_2 = resultsAsMatrix(resultsArray, 'z12');

%% Compute probabilities
probChaos_using_Lyaps = sum(isChaos_Lyap, 1)./nreps;
probChaos_using_z1  = sum(isChaos_z1, 1)./nreps;
probChaos_using_z1_2  = sum(isChaos_z1_2, 1)./nreps;

%% Compare the results of all tests
% Cases:
% Lyap false, z1 false: 00 = 0
% Lyap false, z1 true : 01 = 1
% Lyap true, z1 false : 10 = 2
% Lyap true, z1 true  : 11 = 3

binaryComparer = 2.*isChaos_Lyap + 1.*isChaos_z1_2;
votesForChaos = binaryComparer;
votesForChaos(votesForChaos == 3) = 3;
summary = NaN(1, npars);
for j = 1:npars
    summary(j) = sum(votesForChaos(:, j))./(3*nreps); % TODO: 3 should count as 2?
end

end