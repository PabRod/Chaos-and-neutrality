function pars = parseExperimentParameters(table, row)
%PARSEEXPERIMENT Generates all the required parameters for running a given
%experiment using a table as an input
%
%   The function LOADEXPERIMENTSTABLE generates a human-readable table.
%   When a row of this table is introduced in the current method, it
%   generates a computer friendly set of parameters ready to be used by our
%   algorithm.
%
%   See also:
%   LOADEXPERIMENTSTABLE

%% Read the straightforward information
% That is, everything but compPars
pars.id = string(table.id(row)); % Experiment id
pars.active = table.active(row); % Is an active experiment?
pars.nPreys = table.nPreys(row); % Number of prey species
pars.nPreds = table.nPreds(row); % Number of predator species
pars.r = table.r(row); % Prey growth ratio
pars.K = table.K(row); % Prey carrying capacity
pars.g = table.g(row); % Predation rate
pars.f = table.f(row); % Immigration rate
pars.e = table.e(row); % Assimilation efficiency
pars.H = table.H(row); % Half-saturation constant
pars.l = table.l(row); % Loss rate
pars.width = table.width(row); % Width of the competition window
pars.runTime = table.simTime(row); % Time length of the time series
pars.stabilTime = table.stabilTime(row); % Stabilization time (time to reach the attractor)
pars.timeSteps = table.steps(row); % Time steps in the time series
pars.lyapTime = table.lyapTime(row); % Time used to estimate the maximum Lyapunov exponent
pars.lyapPert = table.lyapPert(row); % Initial perturbation used to estimate the maximum Lyapunov exponent
pars.reps = table.reps(row); % Number of repetitions of this experiment
pars.seed = table.seed(row); % Random seed
pars.results_folder = char(table.results_folder(row));  % Output folder for storing results
pars.timeseries_folder = char(table.timeseries_folder(row)); % Output folder for storing time series

%% Read compPars and generate competition parameters
% The table entry for compPars is a string used for generating the
% competition parameters.
%
% The structure is: "start step medium step end".
% For instance: -1 0.05 0 0.2 1 generates the concatenation of -1:0.05:0 
% and 0.2:0.2:1
compParsGenerator = str2num(char(table.compPars(row)));
pStart = compParsGenerator(1);
pStep1 = compParsGenerator(2);
pMid = compParsGenerator(3);
pStep2 = compParsGenerator(4);
pEnd = compParsGenerator(5);
pars.compPars = cat(2, pStart:pStep1:pMid, pMid+pStep2:pStep2:pEnd);

end