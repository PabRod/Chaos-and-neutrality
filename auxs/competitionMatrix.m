function A = competitionMatrix(n, compPar, mode, varargin)
%COMPETITONMATRIX Generates the competition matrix A with the given parameters

switch mode
    case 'stretching_window'
        A = ones(n) + compPar.*RandCustom([n, n], [0 1], 'uniform');
        A(logical(eye(n))) = 1; % Keep ones in the diagonal

    case 'moving_window'
        width = varargin{1};
        A = ones(n) + RandCustom([n, n], [compPar - width./2, compPar + width./2], 'uniform');
        A(A >= 2) = 2; % Trim any extreme values, i.e., higher than 2...
        A(A <= 0) = 0; % ... and lower than 0
        A(logical(eye(n))) = 1; % Keep ones in the diagonal

    otherwise
        error('Supported modes are: stretching_window and moving_window');

end

end
