function [id, active, nPreys, nPreds, runTime, stabilTime, timeSteps, lyapTime, lyapPert, reps, compPars, output_folder, timeseries_folder] = parseExperimentParameters(table, row)
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
id = string(table.id(row));
active = table.active(row);
nPreys = table.nPreys(row);
nPreds = table.nPreds(row);
runTime = table.simTime(row);
stabilTime = table.stabilTime(row);
timeSteps = table.steps(row);
lyapTime = table.lyapTime(row);
lyapPert = table.lyapPert(row);
reps = table.reps(row);
output_folder = char(table.results_folder(row));
timeseries_folder = char(table.timeseries_folder(row));

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
compPars = cat(2, pStart:pStep1:pMid, pMid+pStep2:pStep2:pEnd);

end