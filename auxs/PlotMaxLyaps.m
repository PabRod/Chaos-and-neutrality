function PlotMaxLyaps(pars, max_lyaps, varargin)
%PLOTMAXLYAPS Summary of this function goes here
%   Detailed explanation goes here

%% Set threshold
if nargin == 2
    threshold = 0;
elseif nargin == 3
    threshold = varargin{1};
end

%% Set colors
numPoints = numel(max_lyaps);
chaosColor = cell(1, numPoints);
for i = 1:numPoints
    if(max_lyaps(i) >= threshold)
        chaosColor{i} = 'red'; % Sure case of chaos
    else
        chaosColor{i} = 'blue';
    end
end

%% Plot
for i = 1:numPoints
    plot(pars(i), max_lyaps(i), '.', 'color', chaosColor{i});
    hold on;
end


end

