function isc = isChaos(result, criterion)
%ISCHAOS returns 1 if the system is chaotic and 0 otherwise.
%
% The method uses different criterions: lyapunov, z1, z12 and visual.

switch criterion
    case 'lyapunov' % Criterion of the maximum Lyapunov exponent
        isc = (result.maxLyapunov > 0);
        
    case 'z1' % Criterion of Gottwald and Melbourne (z1 test)
        if ~isfield(result, 'z1test') % Avoid re-doing the z1 test
            result.z1test = z1test(result.timeseries.ys);
        end
        isc = strcmp(result.z1test.disp, 'Chaotic');
        
    case 'z12' % Criterion of Gottwald and Melbourne (z1 test, soft version)
        if ~isfield(result, 'z1test') % Avoid re-doing the z1 test
            result.z1test = z1test(result.timeseries.ys);
        end
        isc = strcmp(result.z1test.disp, 'Chaotic') ||  strcmp(result.z1test.disp, 'Indecisive');
        
    case 'visual' % Visual criterion
        isc = visualInspection(result);
        
    otherwise
        error('Available criterions are: lyapunov, z1, z12 and visual');
        
end