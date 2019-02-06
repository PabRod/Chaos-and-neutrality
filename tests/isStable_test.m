%% Stable case
ts = linspace(0, 100, 100)';
ys = [0.*ts, 1 + 0.*ts];

assert(isStable(ys));

%% Unstable case
ts = linspace(0, 100, 100)';
ys = [sin(ts), cos(ts)];

assert(~isStable(ys));