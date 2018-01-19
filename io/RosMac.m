function dydt = RosMac(t, y, params)
%ROSMAC Represents a generalized Rosenzweig-MacArthur predator-prey model
%   Detailed explanation goes here

% Read parameters
A = params.A; S = params.S;
e = params.e; g = params.g;
l = params.l; r = params.r;
H = params.H; K = params.K;
inflow = params.inflow;

% Measure the system
nPreds = size(S, 1);
nPreys = size(S, 2);

% Auxiliary functions
Prey = @(y) y(1:nPreys, 1);
Pred = @(y) y(nPreys+1:end, 1);
V = @(y) S*Prey(y);
C = @(y) g.*diag(Pred(y))*V(y)./(V(y) + H);

% Dynamics
% Preys
dydt(1:nPreys, 1) = (r.*diag(Prey(y)))*(K - A*Prey(y))./K - diag(Prey(y))*S'*(C(y)./V(y)) + inflow;

% Predators
dydt(nPreys+1:nPreys+nPreds, 1) = e.*C(y) - l.*Pred(y);

end