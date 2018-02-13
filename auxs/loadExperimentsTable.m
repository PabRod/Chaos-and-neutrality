function table = loadExperimentsTable(filename)
%LOADEXPERIMENTCASES Generates a table with the experiment parameters from
%a csv file
%
%   The parameters of each experiment can be stored in a csv file with the
%   following format:
%
%   id;active;nPreys;nPreds;r;K;g;f;e;H;l;simTime;stabilTime;steps;lyapTime;lyapPert;reps;compPars;results_folder;timeseries_folder
%   failed;false;6;-4;0.5;10;0.4;1e-5;0.6;2;0.15;1000;1000;3000;100;0.01;3;-1 0.1 0 0.25 1;io/;io/
%   fast;true;12;8;0.5;10;0.4;1e-5;0.6;2;0.15;5000;5000;5000;100;1e-8;3;-1 0.1 0 0.25 1;io/;io/
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
