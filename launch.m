%% Clear the environment
close all;
clear;
clc;

%% Load experiments table
experiments_table_location = 'io/input_personal.csv';
tab = loadExperimentsTable(experiments_table_location);

% Some parameters are fixed
params.r = 0.5;
params.K = 10;
params.g = 0.4;
params.f = 1e-5;
params.e = 0.6;
params.H = 2;
params.l = 0.15;


%% Perform each experiment
[nExperiments, ~] = size(tab); % One experiment per row

for row = 1:nExperiments
    
    % Set random seed for the sake of reproducibility
    seed = 1;
    rng(seed);
    
    try
        % The numerical experiment is kept inside a try - catch - end
        % structure. In case of error, it moves to the next case instead
        % of interrupting the execution of the rest of the script
        
        %% Parse experiment data (see details below)
        pars = parseExperimentParameters(tab, row);
        
        % ---- Practical info ----
        id = pars.id; % Experiment id
        active = pars.active; % Is an active experiment?
        results_folder = pars.results_folder; % Output folder for storing results
        timeseries_folder = pars.timeseries_folder; % Output folder for storing time series
        
        % ---- Numerical info ----
        nPreys = pars.nPreys; % Number of prey species
        nPreds = pars.nPreds; % Number of predator species
        runTime = pars.runTime; % Time length of the time series
        stabilTime = pars.stabilTime; % Stabilization time (time to reach the attractor)
        timeSteps = pars.timeSteps; % Time steps in the time series
        lyapTime = pars.lyapTime; % Time used to estimate the maximum Lyapunov exponent
        lyapPert = pars.lyapPert; % Initial perturbation used to estimate the maximum Lyapunov exponent
        reps = pars.reps; % Number of repetitions of this experiment
        compPars = pars.compPars; % Competition parameters to generate competition matrix (see paper)
        
        
        %% If the experiment is inactive, ignore it and execute the next in table
        if ~active
            continue;
        end
        
        %% Print information about current experiment
        fprintf('\n \n Job: %s. \n Simulating.', id);
        
        %% Fix experiment parameters
        % Create the results object
        results.id = id;
        results.dims = [nPreys, nPreds];
        results.stabiltime = stabilTime;
        
        
        %% Iterate for different neutrality strengths
        compSteps = numel(compPars);
        resultsArray = cell(reps, compSteps);
        for compStep = 1:compSteps % Iterate for different neutrality strengths
            results.competition_par = compPars(compStep);
            for rep = 1:reps
                % Some of the parameters are randomly drawn. Run repeteadly in order to apply some statistics
                
                %% Set random initial conditions
                Prey = rand(nPreys, 1) + 1;
                Pred = rand(nPreds, 1) + 1;
                
                %% Set variable parameters                
                params.A = competitionMatrix(nPreys, compPars(compStep), 'moving_window', 0.2);
                params.S = rand(nPreds, nPreys);
                
                results.predMatrix = params.S;
                results.compMatrix = params.A;
                
                %% Reach the attractor
                opts = odeset('RelTol', 1e-4, 'AbsTol', 1e-5);
                y0 = rand(1, nPreds+nPreys) + 1;
                [~, y_out] = ode45(@(t,y) RosMac(t, y, params), [0 stabilTime], y0, opts);
                
                %% Find a solution inside the attractor
                tSpan = linspace(0, runTime, timeSteps);
                y_attr = y_out(end, :);
                [t_out, y_out] = ode45(@(t,y) RosMac(t, y, params), tSpan, y_attr, opts);
                
                results.timeseries.ys = y_out;
                results.timeseries.ts = t_out;
                
                %% Perform tests for chaos
                results.maxLyapunov = lyapunovExp(@(t, y) RosMac(t, y, params), linspace(0, lyapTime, 150), y_attr, lyapPert.*ones(1, nPreys+nPreds), true);
                
                %% Store in array
                resultsArray{rep, compStep} = results;
                
            end
        end
        
        %% Save preliminary results
        % This file contains the timeseries
        %         filename = char(strcat(output_folder, id, '_temp', '.mat'));
        %         fprintf('\n Saving time series.');
        %         save(filename, 'resultsArray', '-v7.3'); % v7.3 is required for files larger than 2 Gb
        
        %% Analyze results
        fprintf('\n Analyzing.');
        resultsArray = performChaosTests(resultsArray);
        
        %% Remove the heavy parts
        for i = 1:size(resultsArray, 1)
            for j = 1:size(resultsArray, 2)
                resultsArray{i,j}.timeseries = NaN;
                resultsArray{i,j}.predMatrix = NaN;
                resultsArray{i,j}.compMatrix = NaN;
                
                % TODO: use rmfield
            end
        end
        
        %% Save results
        % This file contains the time series and the results of the
        % analysis
        filename = char(strcat(results_folder, id, '.mat'));
        fprintf('\n Saving results.');
        save(filename, 'resultsArray', '-v7.3'); % v7.3 is required for files larger than 2 Gb
        
        
        % Clean temporary results
%         filename = char(strcat(output_folder, id, '_temp', '.mat'));
%         recycle('on');
%         delete(filename);
        
        %% Plot results
        fprintf('\n Creating figures.');
        
%         figure;
%         subplot(3, 1, 1);
%         createFigures(resultsArray, 'maxLyaps');
%         subplot(3, 1, 2);
%         createFigures(resultsArray, 'maxLyapsFiltered');
%         subplot(3, 1, 3);
%         createFigures(resultsArray, 'probabilities');
        
        figure;
        subplot(2, 1, 1);
        createFigures(resultsArray, 'comparer');
        subplot(2, 1, 2);
        createFigures(resultsArray, 'summary');
        
        fprintf('\n Finished.');
        
        %% Restore random seed
        rng('shuffle');
        
    catch me % In case of error, log and continue
        
        % Restore random seed
        rng('shuffle');
        
        fprintf('\n Error: %s', me.message);
        
        filename = char(strcat(results_folder, id, '_error', '.mat'));
        resultsArray = me.identifier;
        save(filename, 'resultsArray');
        
    end
    
    fprintf('\n');
    
end