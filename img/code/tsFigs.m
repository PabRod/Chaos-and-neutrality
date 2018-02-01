%%
clear;

%% Introduce parameters
% System dimensions
nPreds = 12;
nPreys = 18;

% Parameters
r = 0.5;
K = 1;
g = 0.4;
f = 1e-5;
e = 0.6;
H = 2;
l = 0.15;


% Competition matrix
p = -0.05;
w = 0.1;
A = competitionMatrix(nPreys, p, 'stretching_window', w);

% Predation matrix
S = rand(nPreds, nPreys);

% Dependent parameters
dims = nPreds + nPreys;

% Collect all parameters
params = struct('A', A, 'S', S, 'e', e, ...
                'g', g, 'H', H, 'f', f, ...
                'K', K, 'l', l, 'r', r);

%% Solve differential equation
simTime = 5000;
opts = odeset('RelTol', 1e-5, 'AbsTol', 1e-9);
y0 = 0.3*rand(1, dims);
[t_out, y_out] = ode45(@(t,y) RosMac(t, y, params), [0 simTime], y0, opts);

%% Plot
close all;
plot(t_out, y_out);