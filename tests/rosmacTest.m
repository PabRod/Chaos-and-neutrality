%
absTol = 1e-5;

%% Logistic growth
% Choosing the appropriate parametres, we get a very simple example:
% logistic growth for the prey and exponential decay for the predator

% System dimensions
nPreds = 1;
nPreys = 1;

% Parameters
e = 0;
g = 0;
H = 1;
f = 0;
K = pi;
l = 0.15;
r = 0.9;

% Competition matrix
A = ones(nPreys);

% Predation matrix
S = ones(nPreds, nPreys);

% Dependent parameters
dims = nPreys + nPreds;

% Collect all parameters
params = struct('A', A, 'S', S, 'e', e, ...
                'g', g, 'H', H, 'f', f, ...
                'K', K, 'l', l, 'r', r);

% Solve differential equation

% Stabilize
stabilTime = 500;
opts = odeset('RelTol', 1e-5, 'AbsTol', 1e-9);
y0 = [0.1, 0.1];
[t_out, y_out] = ode45(@(t,y) RosMac(t, y, params), [0 stabilTime], y0, opts);

% Assert
prey_stable_population = y_out(end, 1); % Expected to be K
pred_stable_population = y_out(end, 2); % Expected to be 0

assert(abs(prey_stable_population - K) < absTol);
assert(abs(pred_stable_population) < absTol);


%% Plot
% % System dimensions
% nPreds = 1;
% nPreys = 1;
% 
% % Simple parameters
% e = 0.6;
% g = 0.4;
% H = 2;
% f = 1e-5;
% K = 10;
% l = 0.15;
% r = 0.5;
% 
% % Competition parameter
% compPar = -0.5;
% 
% % Dependent parameters
% dims = nPreys + nPreds;
% 
% % Competition matrix
% A = ones(nPreys) + RandCustom([nPreys, nPreys], [compPar - 0.1, compPar + 0.1], 'uniform');
% A(A >= 2) = 2;
% A(A <=0) = 0;
% A(logical(eye(nPreys))) = 1;
% 
% % Predation matrix
% S = rand(nPreds, nPreys);
% 
% % Collect all parameters
% params = struct('A', A, 'S', S, 'e', e, ...
%                 'g', g, 'H', H, 'f', f, ...
%                 'K', K, 'l', l, 'r', r);
% 
% % Solve differential equation
% 
% % Stabilize
% stabilTime = 2000;
% opts = odeset('RelTol', 1e-4, 'AbsTol', 1e-8);
% y0 = rand(1, dims) + 1;
% [t_out, y_out] = ode45(@(t,y) RosMac(t, y, params), [0 stabilTime], y0, opts);
% 
% % Plot stabilization run
% close all;
% figure;
% subplot(2, 1, 1);
% plot(t_out, y_out(:, 1:nPreys), '--'); hold on; plot(t_out, y_out(:, nPreys+1:end), '.');
% title('Stabilization run');
% 
% % Simulation run
% tSpan = 0:1:5000;
% y0_attractor = y_out(end, :);
% [t_out, y_out] = ode45(@(t,y) RosMac(t, y, params), tSpan, y0_attractor, opts);
% 
% % Plot run
% subplot(2, 1, 2);
% plot(t_out, y_out(:, 1:nPreys), '--'); hold on; plot(t_out, y_out(:, nPreys+1:end), '.');
% title('Measure run');
% 
% % Calculate Lyapunov exponent
% maxLyap = lyapunovExp(@(t, y) RosMac(t, y, params), [0 100], y0_attractor, 1e-8.*ones(1, dims), true);