function r = RandCustom(dims, limits, dist)
%RANDCUSTOM Summary of this function goes here
%
% Example of use: r = RandCustom([1, 10], [-1, 1], 'uniform')

%% Defaults
defaultDims = 1;
defaultLims = [0 1];
defaultDist = 'uniform';
if(nargin == 0)
    dims = defaultDims;
    limits = defaultLims;
    dist = defaultDist;
elseif(nargin == 1)
    limits = defaultLims;
    dist = defaultDist;
elseif (nargin == 2)
    dist = defaultDist;
end

%% Call the appropriate method
if(strcmp(dist, 'uniform'))
    r = RandUniform(dims, limits);
else
    error('Supported distributions are: uniform');
end

end

function r = RandUniform(dims, limits)
%RANDUNIFORM Uniform distribution for the interval [a, b]
%
% Example of use: r = RandUniform([1, 10], [-1, 1])

a = limits(1);
b = limits(2);
r = a + (b-a).*rand(dims);

end