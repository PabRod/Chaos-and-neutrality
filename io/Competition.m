function dydt = Competition(t, y, params)
%COMPETITION Represents a competition model
%   Returns a vector function handle @dydt ready to be integrated in 
%   solvers like ode45

%% Read parameters
A = params.A; % Competition matrix
r = params.r; % Prey's growth rate
K = params.K; % Prey's carrying capacity
f = params.f; % Prey's immigration rate

%% Dynamics
% The first elements of the vector represent the prey populations
dydt = (r.*diag(y))*(K - A*y)./K + f;

end