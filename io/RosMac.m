function dydt = RosMac(t, y, params)
%ROSMAC Represents a generalized Rosenzweig-MacArthur predator-prey model
%   Detailed explanation goes here

%% Read parameters
A = params.A; % Competition matrix
S = params.S; % Predation matrix
e = params.e; % Assimilation efficiency
g = params.g; % Predation rate
l = params.l; % Predators' loss rate
r = params.r; % Prey's growth rate
H = params.H; % Half-saturation constant
K = params.K; % Prey's carrying capacity
f = params.f; % Prey's immigration rate

%% Measure the system
nPreds = size(S, 1);
nPreys = size(S, 2);

%% Generate auxiliary functions
Prey = @(y) y(1:nPreys, 1);
Pred = @(y) y(nPreys+1:end, 1);
V = @(y) S*Prey(y);
C = @(y) g.*diag(Pred(y))*V(y)./(V(y) + H);

%% Dynamics
% The first elements of the vector represent the prey
dydt(1:nPreys, 1) = (r.*diag(Prey(y)))*(K - A*Prey(y))./K - diag(Prey(y))*S'*(C(y)./V(y)) + f;

% The last elements of the vector represent the predator
dydt(nPreys+1:nPreys+nPreds, 1) = e.*C(y) - l.*Pred(y);

end