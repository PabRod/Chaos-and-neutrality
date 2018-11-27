function resultsArray = loadResults(resultsLocation)
%LOADRESULTS Loads a results file / variable

if isa(resultsLocation, 'char') && exist(resultsLocation, 'file') % Input is a file
    all = load(resultsLocation); % Loads all in a 1 x 1 struct. This struct, ...
    fields = fieldnames(all); % ... contains another one. We want to ...
    resultsArray = all.(fields{1}); % ... extract it
else % Input is a variable
    resultsArray = resultsLocation;
end

end