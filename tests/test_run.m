% Experiment parameters
% Experiments table location
experiments_table_location = 'mockInput.csv';

% Perform each experiment
try % If the package is not properly installed, this should fail
    tab = loadExperimentsTable(experiments_table_location);
catch me
    fprintf('\n Error: %s', me.message);
    fprintf('\n');
    error('The package is not properly installed. Remember to add all folders and subfolders to path');
end

[nExperiments, ~] = size(tab); % One experiment per row
for row = 1:nExperiments

    try
        % The numerical experiment is kept inside a try - catch - end
        % structure. In case of error, it moves to the next case instead
        % of interrupting the execution of the rest of the script

        % Parse experiment data (see details below)
        pars = parseExperimentParameters(tab, row);

        active = pars.active; % Is an active experiment?
        if ~active % If the experiment is inactive...
            continue; % ... ignore it and execute the next in table
        end

        % ---- Practical info ----
        id = pars.id; % Experiment id
        results_folder = pars.results_folder; % Output folder for storing results
        timeseries_folder = pars.timeseries_folder; % Output folder for storing time series

        % ---- Model info ----
        nPreys = pars.nPreys; % Number of prey species
        nPreds = pars.nPreds; % Number of predator species

        r = pars.r; % Prey growth ratio
        K = pars.K; % Prey carrying capacity
        g = pars.g; % Predation rate
        f = pars.f; % Immigration rate
        e = pars.e; % Assimilation efficiency
        H = pars.H; % Half-saturation constant
        l = pars.l; % Loss rate
        compPars = pars.compPars; % Competition parameters to generate competition matrix (see paper)

        % ---- Simulation info ----
        seed = pars.seed; % Random seed
        runTime = pars.runTime; % Time length of the time series
        stabilTime = pars.stabilTime; % Stabilization time (time to reach the attractor)
        timeSteps = pars.timeSteps; % Time steps in the time series
        lyapTime = pars.lyapTime; % Time used to estimate the maximum Lyapunov exponent
        lyapPert = pars.lyapPert; % Initial perturbation used to estimate the maximum Lyapunov exponent
        reps = pars.reps; % Number of repetitions of this experiment

        % Set the random seed for the sake of reproducibility
        rng(seed);

        % Print information about current experiment
        fprintf('\n \n Job: %s. \n Simulating.', id);

        % Create the results object
        % The results object stores all the information about the results
        % of the current run
        results.id = id;
        results.dims = [nPreys, nPreds];
        results.stabiltime = stabilTime;

        % Iterate for different neutrality strengths
        compSteps = numel(compPars);
        resultsArray = cell(reps, compSteps);
        for compStep = 1:compSteps % Iterate for different neutrality strengths
            results.competition_par = compPars(compStep);
            for rep = 1:reps
                % Some of the parameters are randomly drawn. This allows us
                % to run several times the "same" experiment, in order to
                % perform statistical analysis afterwards.

                % Set variable parameters
                mode = 'moving_window';
                window_width = 0.2;
                pars.A = competitionMatrix(nPreys, compPars(compStep), mode, window_width);
                pars.S = rand(nPreds, nPreys);

                results.predMatrix = pars.S;
                results.compMatrix = pars.A;

                % Reach the attractor
                opts = odeset('RelTol', 5e-5, 'AbsTol', 1e-7);
                y0 = rand(1, nPreds+nPreys) + 1;
                [~, y_out] = ode45(@(t,y) RosMac(t, y, pars), [0, stabilTime/2, stabilTime], y0, opts);

                % Find a solution inside the attractor
                tSpan = linspace(0, runTime, timeSteps);
                y_attr = y_out(end, :);
                [t_out, y_out] = ode45(@(t,y) RosMac(t, y, pars), tSpan, y_attr, opts);

                results.timeseries.ys = y_out;
                results.timeseries.ts = t_out;

                % Perform tests for chaos
                [ts_lyap, ys_lyap_1] = ode45(@(t,y) RosMac(t, y, pars), linspace(0, lyapTime, 150), y_attr, opts); %TODO: re-use previous run
                [~, ys_lyap_2] = ode45(@(t,y) RosMac(t, y, pars), linspace(0, lyapTime, 150), y_attr + lyapPert.*ones(1, nPreys+nPreds), opts);

                [results.maxLyapunov, b, dist, nhorizon] = calclyap(ts_lyap, ys_lyap_1, ys_lyap_2);

                % Store in array
                resultsArray{rep, compStep} = results;

            end
        end

        % Analyze results
        fprintf('\n Analyzing.');
        resultsArray = performChaosTests(resultsArray);

        % Remove the heavy parts
        % The time series are very heavy. Here we remove them
        for i = 1:size(resultsArray, 1)
            for j = 1:size(resultsArray, 2)
                resultsArray{i,j} = rmfield(resultsArray{i,j}, {'timeseries', 'predMatrix', 'compMatrix'});
                % TODO: keep matrices
            end
        end

        % Plot results
        figure;
        subplot(2, 1, 1);
        createFigures(resultsArray, 'comparer');
        subplot(2, 1, 2);
        createFigures(resultsArray, 'summary');
        close all;

        fprintf('\n Congratulations. The package is properly installed!.');

        % Restore random seed
        rng('shuffle');

    catch me % In case of error

        % Restore random seed
        rng('shuffle');

        fprintf('\n Error: %s', me.message);

    end

    fprintf('\n');

end
