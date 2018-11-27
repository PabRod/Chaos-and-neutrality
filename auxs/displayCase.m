function result = displayCase(resultsLocation, i, j)
%DISPLAYCASE Loads and displays the case identified by the coordinates (i,j)

%%
if isa(resultsLocation, 'char') && exist(resultsLocation, 'file')
    results = loadResults(resultsLocation);
else
    results = resultsLocation;
end

%%
if numel(results) == 1
    result = results;
else
    result = results{i,j};
end
%info = genInfo(result);
plot(result.timeseries.ts, result.timeseries.ys);
%title(info);

end

