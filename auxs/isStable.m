function iss = isStable(ys, threshold)
%ISSTABLE returns 1 if the system reached a stable point and 0 otherwise.

%% Set default
if nargin == 1
    threshold = 1e-2;
end

%% Check time series
dys = diff(ys);

iss = all(abs(dys(:)) < threshold);

end