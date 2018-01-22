function table = loadExperimentsTable(filename)
%LOADEXPERIMENTCASES Generates a table with the experiment parameters from 
%a csv file
%
%   The parameters of each experiment can be stored in a csv file with the
%   following format:
%
%   id;active;nPreys;nPreds;simTime;stabilTime;steps;lyapTime;lyapPert;reps;compPars
%   A;true;6;4;1000;1000;3000;100;0.01;3;-1 0.1 0 0.25 1
%   B;false;12;8;1000;1000;3000;100;0.01;3;-1 0.1 0 0.25 1
%
%   Syntax:
%
%   table = loadExperimentsTable(filename);
%
%   where:
%
%   filename is the path to the csv file
%   table is a table-formatted version of the csv contents
%
%   See also:
%   PARSEEXPERIMENTPARAMETERS

%% Prepare the import
opts = detectImportOptions(filename);
opts.Delimiter = ';';
opts.Encoding = 'UTF-8';
opts = setvartype(opts, {'nPreys', 'nPreds', 'r', 'K', 'g', 'f', 'e', ... 
                         'H', 'l', 'simTime', 'stabilTime', 'steps', ... 
                         'lyapTime', 'reps'}, 'double');
opts = setvartype(opts, {'id', 'compPars'}, 'string');
opts = setvartype(opts, {'results_folder', 'timeseries_folder'}, 'char');
opts = setvartype(opts, {'active'}, 'logical');

%% Import
table = readtable(filename, opts);

end
