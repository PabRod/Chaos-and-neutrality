function runRes = launchExperiment(id, nPreys, nPreds, runTime, stabilTime, timeSteps, lyapTime, lyapPert, reps, compPars)
%LAUNCHEXPERIMENT Summary of this function goes here
%   Detailed explanation goes here


use('experiment.ini');
%% Override dimensionality
setdimension('Prey', nPreys); % TODO: silent
setdimension('Pred', nPreds); % TODO: silent
dim1 = nPreys;
dim2 = nPreds;

% TODO: set matrices here

%% Iterate for different neutrality strenghts
compSteps = numel(compPars);
runRes = cell(reps, compSteps);
stepCounter = 1;
for i = 1:compSteps
    for j = 1:reps
        
        %% Set initial conditions
        Prey = rand(nPreys, 1) + 1;
        Pred = rand(nPreds, 1) + 1;
        
        %% Set variable parameters
        S = rand(nPreds, nPreys);
        A = ones(nPreys) + compPars(i).*RandCustom([nPreys, nPreys], [0 1], 'uniform');
        A(logical(eye(nPreys))) = 1; % Keep ones in the diagonal
        
        %% Run
        stabil(stabilTime, true);
        ke;
        simtime(0, runTime, timeSteps);
        time -s;
        
        %% Store
        results.id = id;
        results.timeseries.ys = outfun({'Prey', 'Pred'});
        results.timeseries.ts = outfun('t');
        results.dims = [nPreys, nPreds];
        results.stabiltime = stabilTime;
        results.params = par;
        results.details = g_grind;
        results.competition_par = compPars(i);
        results.maxLyapunov = lyapunov(lyapTime, lyapPert, true);
        %results.z1test = z1test(results.timeseries.ys, false);
        
        runRes{j, stepCounter} = results;
        
    end
    stepCounter = stepCounter + 1;
end

end