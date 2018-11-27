function [p, q, M] = z1ChaosTest(ys, th, N)
%Z1CHAOSTEST Summary of this function goes here
%   Detailed explanation goes here

%% Input control
if th <= 0 || th >= pi
    error('th should be bounded between 0 and pi (excluding)');
end

Nts = numel(ys(:)); % Length of the original time series
if N > Nts
    warning('The selected Lmax is too long. Length has been adjusted automatically');
    N = Nts;
end

%% Generate the testing function
% Our purpose is to build the family of functions:
%
% $$z_n(\theta) = \sum_{k = 1}^n y_k e^{ik \theta}$$

% Set the summands
ks = 1:N;
phasors = exp(1i.*ks.*th); % A complex exponential stores both cos and sin 
summands = ys(1:N).*phasors(:); % The summands are just phasors scaled by the time series elements

% Sum all
z = cumsum(summands);

%% Extract the series p and q
% Both series are packed inside the series z.
%
% Using Euler's identity for complex exponentials
%
% $$e^{ik \theta} = cos(\theta) + i sin(\theta)$$
%
% and noting that z is a linear combination of complex exponentials, we can
% extract the cos and sin elements as:
%
% $$p_n(\theta) = \Re \{ z_n(\theta) \}$$
%
% $$q_n(\theta) = \Im \{ z_n(\theta) \}$$

p = real(z);
q = imag(z);

%% Calculate the series M
% As the mean distance travelled after n steps. That is:
%
% $$M_n(\theta) = E \left(|z_{n+k}(\theta) - z_k(\theta)|^2\right) \approx \frac{1}{N-n}\sum_{k = 1}^{N-n}|z_{n+k}(\theta) - z_k(\theta)|^2$$

nCut = round(N/10);
M = zeros(1, nCut);
for n = 1:nCut
    lag = n - 1; % Indexation detail: lag 0 corresponds to element 1 of M
    zTrimmed = z(1:N-lag);
    zShifted = z(1+lag:N);
    dif = zShifted(:) - zTrimmed(:);
    distSq = abs(dif).^2;
    M(n) = mean(distSq);
end

end
