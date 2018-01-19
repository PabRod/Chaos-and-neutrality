%
absTol = 1e-12;

%% Read table, first row
tab = loadExperimentsTable('mockInput.csv');
[id, active, nPreys, nPreds, runTime, stabilTime, timeSteps, lyapTime, lyapPert, reps, compPars] = parseExperimentParameters(tab, 1);

assert(strcmp('first', id));
assert(active);
assert(nPreys == 6);
assert(nPreds == 4);
assert(runTime == 1000);
assert(stabilTime == 1000);
assert(timeSteps == 3000);
assert(lyapTime == 100);
assert(abs(lyapPert - 1e-8) < absTol);
assert(reps == 50);

expectedCompPars = cat(2, -1:0.1:0, 0.25:0.25:1);
for i = 1:numel(expectedCompPars)
    assert(abs(compPars(i) - expectedCompPars(i)) < absTol);
end

%% Read table, second row
tab = loadExperimentsTable('mockInput.csv');
[id, active, nPreys, nPreds, runTime, stabilTime, timeSteps, lyapTime, lyapPert, reps, compPars] = parseExperimentParameters(tab, 2);

assert(strcmp('second', id));
assert(~active);
assert(nPreys == 5);
assert(nPreds == 3);
assert(runTime == 2000);
assert(stabilTime == 2500);
assert(timeSteps == 2000);
assert(lyapTime == 150);
assert(abs(lyapPert - 0.01) < absTol);
assert(reps == 3);

expectedCompPars = cat(2, -1:0.1:0, 0.2:0.2:1);
for i = 1:numel(expectedCompPars)
    assert(abs(compPars(i) - expectedCompPars(i)) < absTol);
end