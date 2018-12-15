function contourFig(varargin)
%CONTOURFIG Generates the contour plot combining the results of
%experiments executed with different numbers of species.
%
% Each per-number-of-species batch subset must have the same size.
%
% Usage:
%
% If all the output files (say, 2-3p.mat, 4-6p.mat, ..., 20-30p.mat) are in 
% the same folder, and there is no other .mat file in the folder, execute
% contourFig without arguments.
%
% To point to a particular set of files, include the filenames as argument:
% contourFig({'2-3p.mat', '4-6p.mat', ..., '20-30p.mat'})

%% Input control
switch nargin
    
    case 0 % Take all .mat files in folder
        filesInfo = dir('*.mat');
        
        % Sort by date
        [~, idx] = sort([filesInfo.datenum]);
        filesInfo = filesInfo(idx);
        
        % Create the files list in the expected format
        files = cell(1, numel(filesInfo));
        for i = 1:numel(filesInfo)
            files{i} = filesInfo(i).name;
        end
        
        opts = 'all';
        
    case 1 % Take specified files
        files = varargin{1};
        opts = 'all';
        
    case 2 % Plot only specified contours
        files = varargin{1};
        opts = varargin{2};
        
    otherwise
        error('Wrong number of inputs');
end

%% Extract information
competition_pars = resultsAsMatrix(files{1}, 'competition_par');
usingLyaps = NaN(numel(files), numel(competition_pars));
usingz1 = NaN(numel(files), numel(competition_pars));
usingz12 = NaN(numel(files), numel(competition_pars));
summaries = NaN(numel(files), numel(competition_pars));
nSpecies = NaN(1, numel(files));
for i = 1:numel(files)
    resultsArrayLocation = files{i};
    clear resultsArray;
    resultsArray = loadResults(resultsArrayLocation); 
    nSpecies(i) = sum(resultsArray{1,1}.dims);
    [probChaos_using_Lyaps, probChaos_using_z1, probChaos_using_z1_2, summary, ~] = computeProbabilities(resultsArray);
    usingLyaps(i, :) = probChaos_using_Lyaps;
    usingz1(i, :) = probChaos_using_z1;
    usingz12(i, :) = probChaos_using_z1_2;
    summaries(i, :) = summary;
end

%% Plot
levels = [.0, .1, .2, .3, .4, .5, .6, .7, .8, .9, .95, .975, 0.99, 1];

switch opts
    
    case 'lyaps'
        contourFigLyaps(competition_pars, nSpecies, usingLyaps, levels);
        
    case 'z1'
        contourFigZ1(competition_pars, nSpecies, usingz1, levels);
        
    case 'z12'
        contourFigZ1(competition_pars, nSpecies, usingz12, levels);
        title('Using z1 soft');
        
    case 'summary'
        contourFigSummary(competition_pars, nSpecies, summaries, levels);
        
    case 'all'
        subplot(2, 2, 1);
        contourFigLyaps(competition_pars, nSpecies, usingLyaps, levels);
        
        subplot(2, 2, 2);
        contourFigZ1(competition_pars, nSpecies, usingz1, levels);
        
        subplot(2, 2, 3);
        contourFigZ1(competition_pars, nSpecies, usingz12, levels);
        title('Using z1 soft');
        
        subplot(2, 2, 4);
        contourFigSummary(competition_pars, nSpecies, summaries, levels);
        
    case 'paper'
        subplot(3, 1, 1);
        contourFigLyaps(competition_pars, nSpecies, usingLyaps, levels);
        xlabel('');
        ylabel('');
        
        subplot(3, 1, 2);
        contourFigZ1(competition_pars, nSpecies, usingz12, levels);
        title('Using z1 soft');
        xlabel('');
        
        subplot(3, 1, 3);
        contourFigZ1(competition_pars, nSpecies, usingz1, levels);
        title('Using z1 hard');
        xlabel('Competition parameter \epsilon');
        ylabel('');
        
    otherwise
        error();
        
end

end

function contourFigLyaps(competition_pars, nSpecies, usingLyaps, levels)
%Auxiliary function
        [c, h] = contourf(competition_pars, nSpecies, usingLyaps, levels);
        title('Using max Lyapunov');
        xlim([-.8 .8]);
        clabel(c, h);
        xlabel('Competition parameter \epsilon');
        ylabel('Number of species (predators + prey)');
end

function contourFigZ1(competition_pars, nSpecies, usingz1, levels)
%Auxiliary function
        [c, h] = contourf(competition_pars, nSpecies, usingz1, levels);
        title('Using z1 hard');
        xlim([-.8 .8]);
        clabel(c, h);
        xlabel('Competition parameter \epsilon');
        ylabel('Number of species (predators + prey)');
end

function contourFigSummary(competition_pars, nSpecies, summaries, levels)
%Auxiliary function
        [c, h] = contourf(competition_pars, nSpecies, summaries, levels);
        title('Using weighted summary');
        xlim([-.8 .8]);
        clabel(c, h);
        xlabel('Competition parameter \epsilon');
        ylabel('Number of species (predators + prey)');
end