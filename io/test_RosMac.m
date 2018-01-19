%%
cclear; 

%% Free parameters
% System dimensions
nPreds = 12;
nPreys = 8;

% Simple parameters
e = 0.6;
g = 0.4;
H = 2;
inflow = 1e-5;
K = 10;
l = 0.15;
r = 0.5;

% Competition parameter
compPar = -0.5;

%% Dependent parameters
dims = nPreys + nPreds;

% Competition matrix
A = ones(nPreys) + RandCustom([nPreys, nPreys], [compPar - 0.1, compPar + 0.1], 'uniform');
A(A >= 2) = 2;
A(A <=0) = 0;
A(logical(eye(nPreys))) = 1;

% Predation matrix
S = rand(nPreds, nPreys);

% Collect all parameters
params = struct('A', A, 'S', S, 'e', e, ...
                'g', g, 'H', H, 'inflow', inflow, ...
                'K', K, 'l', l, 'r', r);

%% Solve differential equation

%% Stabilize
stabilTime = 2000;
opts = odeset('RelTol', 1e-4, 'AbsTol', 1e-8);
y0 = rand(1, dims) + 1;
[t_out, y_out] = ode45(@(t,y) RosMac(t, y, params), [0 stabilTime], y0, opts);

%% Plot stabilization run
close all;
figure;
subplot(2, 1, 1);
plot(t_out, y_out(:, 1:nPreys), '--'); hold on; plot(t_out, y_out(:, nPreys+1:end), '.');
title('Stabilization run');

%% Simulation run
tSpan = 0:1:5000;
y0_attractor = y_out(end, :);
[t_out, y_out] = ode45(@(t,y) RosMac(t, y, params), tSpan, y0_attractor, opts);

%% Plot run
subplot(2, 1, 2);
plot(t_out, y_out(:, 1:nPreys), '--'); hold on; plot(t_out, y_out(:, nPreys+1:end), '.');
title('Measure run');

%% Calculate Lyapunov exponent
maxLyap = lyapunovExp(@(t, y) RosMac(t, y, params), [0 100], y0_attractor, 1e-8.*ones(1, dims), true);