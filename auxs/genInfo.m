function info = genInfo(run)
%GENINFO Generates a human-readable information string

info = sprintf('Max Lyap: %f\nz1: %s', run.maxLyapunov, run.z1test.disp);

end