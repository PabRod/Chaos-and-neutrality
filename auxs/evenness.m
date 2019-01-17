function evs = evenness(results, mode, summary)

% Measure the system
nPrey = results.dims(1);
nPred = results.dims(2);

switch mode
    case 'all' % Count all species
        ys_subset = results.timeseries.ys;
        S = nPred + nPrey;
    case 'preyonly' % Count only prey species
        ys_subset = results.timeseries.ys(:, 1:nPrey);
        S = nPrey;
    case 'preyonly_c' % Count only prey species. Use simulation without predation
        ys_subset = results.timeseries.ys_c(:, 1:nPrey);
        S = nPrey;
    case 'predonly' % Count only predator species
        ys_subset = results.timeseries.ys(:, nPrey+1:nPrey+nPred);
        S = nPred;
    otherwise
        error('Supported modes are: all, preyonly, preyonly_c and predonly');
end

ps = ys_subset./sum(ys_subset, 2); % Use relative weights

evs = -sum(ps.*log(ps), 2)/log(S);

if summary % Return only mean and standard deviation
    evs = [mean(evs), std(evs)];
end

end