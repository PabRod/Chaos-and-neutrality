function lambda = lyapunovExp(ode, ts, y0, pert, silent)
%LYAPUNOVEXP Summary of this function goes here
% Examples:
%
% LyapunovExp(@(t,y)[y(1); -y(2)], [0 10], [0.2;0.2], [0.01; -0.02]);
% LyapunovExp(@f, [0 10], [0.2;0.2], [0.01; -0.02]);

%% Set defaults
if nargin == 4
    silent = false;
end

%% Solve for both initial conditions
[~, y1] = ode45(ode, ts, y0);
[t, y2] = ode45(ode, ts, y0 + pert);

%% Compute the difference
dif = y2 - y1; % Oriented difference

N = numel(t);
delta = zeros(N, 1);
for i = 1:N
    delta(i) = length_measure(dif(i,:)); % Absolute difference
end

%% Estimate lambda by regression
% We expect a relation of the form
%
% delta(t) ~= length(pert) .* e .^ (lambda t)

fr = fit(t, delta, 'exp1');
lambda = fr.b;

%% Output check
% The scale parameter is expected to be equal to the length of the initial perturbation
relTol = 1e-3;
absErr = abs(length_measure(pert) - fr.a);
relErr = absErr/length_measure(pert);
if(relErr > relTol)
    if silent
        % Do nothing. Maybe log?
    else
        warning('The fit may not be reliable');
    end
end

%% Used in debug
% close all;
% figure;
% plot(t, y1);
% figure;
% plot(fr, t, delta);

end

function d = length_measure(rowvec)
%LENGTH_MEASURE stablishes a metric for vector lengths
    d = norm(rowvec, 2);
end