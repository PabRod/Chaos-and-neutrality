%
absTol = 1e-12;

%% Read table, first row
tab = loadExperimentsTable('mockInput.csv');
pars = parseExperimentParameters(tab, 1);

assert(strcmp('first', pars.id));
assert(~pars.active);
assert(pars.nPreys == 6);
assert(pars.nPreds == 4);
assert(pars.r == 0.5);
assert(pars.K == 10);
assert(pars.g == 0.4);
assert(pars.f == 1e-5);
assert(pars.e == 0.6);
assert(pars.H == 2);
assert(pars.l == 0.15);
assert(pars.width == 0.2);
assert(pars.runTime == 1000);
assert(pars.stabilTime == 1000);
assert(pars.timeSteps == 3000);
assert(pars.lyapTime == 100);
assert(abs(pars.lyapPert - 1e-8) < absTol);
assert(pars.reps == 50);
assert(pars.seed == 1);
assert(strcmp('io/', pars.results_folder));
assert(strcmp('io/', pars.timeseries_folder));

expectedCompPars = cat(2, -1:0.1:0, 0.25:0.25:1);
for i = 1:numel(expectedCompPars)
    assert(abs(pars.compPars(i) - expectedCompPars(i)) < absTol);
end

%% Read table, second row
tab = loadExperimentsTable('mockInput.csv');
pars = parseExperimentParameters(tab, 2);

assert(strcmp('second', pars.id));
assert(~pars.active);
assert(pars.nPreys == 5);
assert(pars.nPreds == 3);
assert(pars.r == 0.5);
assert(pars.K == 10);
assert(pars.g == 0.4);
assert(pars.f == 1e-5);
assert(pars.e == 0.6);
assert(pars.H == 2);
assert(pars.l == 0.15);
assert(pars.width == 0.1);
assert(pars.runTime == 2000);
assert(pars.stabilTime == 2500);
assert(pars.timeSteps == 2000);
assert(pars.lyapTime == 150);
assert(abs(pars.lyapPert - 0.01) < absTol);
assert(pars.reps == 3);
assert(pars.seed == 1);
assert(strcmp('io/', pars.results_folder));
assert(strcmp('io/ts/', pars.timeseries_folder));

expectedCompPars = cat(2, -1:0.1:0, 0.2:0.2:1);
for i = 1:numel(expectedCompPars)
    assert(abs(pars.compPars(i) - expectedCompPars(i)) < absTol);
end
