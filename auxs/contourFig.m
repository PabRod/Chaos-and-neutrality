function contourFig(varargin)

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
        
    case 1 % Take specified files
        files = varargin{1};
        
    otherwise
        error('Wrong number of inputs');
end

%% Extract information
competition_pars = resultsAsMatrix(files{1}, 'competition_par');
usingLyaps = NaN(numel(files), numel(competition_pars));
usingz12 = NaN(numel(files), numel(competition_pars));
summaries = NaN(numel(files), numel(competition_pars));
nSpecies = NaN(1, numel(files));
for i = 1:numel(files)
    resultsArrayLocation = files{i};
    clear resultsArray;
    resultsArray = loadResults(resultsArrayLocation); 
    nSpecies(i) = sum(resultsArray{1,1}.dims);
    [probChaos_using_Lyaps, ~, probChaos_using_z1_2, summary, ~] = computeProbabilities(resultsArray);
    usingLyaps(i, :) = probChaos_using_Lyaps;
    usingz12(i, :) = probChaos_using_z1_2;
    summaries(i, :) = summary;
end

%% Plot
levels = [.0, .1, .2, .3, .4, .5, .6, .7, .8, .9, .95, .975, 0.99, 1];

subplot(1, 3, 1);
[c, h] = contourf(competition_pars, nSpecies, usingLyaps, levels);
title('Using max Lyapunov');
xlim([-.8 .8]);
clabel(c, h);

subplot(1, 3, 2);
[c, h] = contourf(competition_pars, nSpecies, usingz12, levels);
title('Using z1');
xlim([-.8 .8]);
clabel(c, h);

subplot(1, 3, 3);
[c, h] = contourf(competition_pars, nSpecies, summaries, levels);
title('Using weighted summary');
xlim([-.8 .8]);
clabel(c, h);

end