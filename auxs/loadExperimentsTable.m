function table = loadExperimentsTable(filename)
%LOADEXPERIMENTCASES Generates a table with the experiment parameters from
%a csv file
%
%   The parameters of each experiment can be stored in a csv file with the
%   following format:
%
%   id;active;nPreys;nPreds;r;K;g;f;e;H;l;width;simTime;stabilTime;steps;lyapTime;lyapPert;reps;compPars;seed;results_folder;timeseries_folder
%   sim1;true;2;3;0.5;10;0.4;1e-5;0.6;2;0.15;0.2;5000;2000;5000;100;1e-8;200;-0.9 0.05 0 0.2 0.9;1;io/;io/
%   sim2;true;4;6;0.5;10;0.4;1e-5;0.6;2;0.15;0.2;5000;2000;5000;100;1e-8;200;-0.9 0.05 0 0.2 0.9;1;io/;io/
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
                         'lyapTime', 'reps', 'width', 'seed'}, 'double');
opts = setvartype(opts, {'id', 'compPars'}, 'string');
opts = setvartype(opts, {'results_folder', 'timeseries_folder'}, 'char');
opts = setvartype(opts, {'active'}, 'logical');

%% Import
table = readtable(filename, opts);

end
