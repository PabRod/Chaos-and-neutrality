function evs = evenness(results, mode, summary)

% Measure the system
nPred = results.dims(1);
nPrey = results.dims(2);

switch mode
    case 'all'
        ys_subset = results.timeseries.ys;
        S = nPred + nPrey;
    case 'predonly'
        ys_subset = results.timeseries.ys(:, 1:nPrey);
        S = nPrey;
    case 'preyonly'
        ys_subset = results.timeseries.ys(:, nPrey+1:nPrey+nPred);
        S = nPred;
    otherwise
        error('Supported modes are: all, preyonly, predonly');
end

ps = ys_subset./sum(ys_subset, 2); % Use relative weights

evs = -sum(ps.*log(ps), 2)/log(S);

if summary % Return only mean and standard deviation
    evs = [mean(evs), std(evs)];
end

end