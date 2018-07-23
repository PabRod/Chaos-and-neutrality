%
absTol = 1e-5;

%% Neutral matrix
% Choosing the appropriate parametres, we should get a neutral competition
% matrix, that is, A_{ij} = 1 for all i and j

A = competitionMatrix(3, 0, 'stretching_window');

assert(size(A, 1) == 3);
assert(size(A, 2) == 3);
assert(sum(A(A == 1)) == 9);

%% Non neutral matrix
A = competitionMatrix(10, 1, 'stretching_window');

assert(size(A, 1) == 10);
assert(size(A, 2) == 10);
assert(sum(A(A == 1)) < 100);

%% Stretching window
A = competitionMatrix(20, -1, 'stretching_window');

assert(min(A(:)) < 0.1);

%% Moving window
A = competitionMatrix(20, 0, 'moving_window', 0.1);

assert(min(A(:)) < 0.96);

%% Check diagonal
% All diagonal elements must be equal to one
A_s = competitionMatrix(20, -0.5, 'stretching_window');

d_s = diag(A_s);
assert(sum(d_s(d_s == 1)) == 20);

A_m = competitionMatrix(20, 0.2, 'moving_window', 0.2);

d_m = diag(A_m);
assert(sum(d_m(d_m == 1)) == 20);