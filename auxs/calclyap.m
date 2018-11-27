function [a, b, dist, nhorizon] = calclyap(gg_t, Y1, Y2)
dist = sqrt(sum((Y1 - Y2).^2, 2));
%dists=abs(Y1-Y2);
%dists(dists<1E-16)=1E-16;
maxdist = max(dist);
if maxdist < 1E-3 * max(max(Y1))
   maxdist = 1E-3 * max(max(Y1));
end
nhor = -1; % Number of steps for the time horizon
for tt = 1:length(gg_t)
   if abs(dist(tt)) < 1E-16
      warning('GRIND:lyapunov:nodiff','Small difference between runs: log of (almost) zero');
      dist(tt) = 1E-16;
   end
   if (nhor==-1)&&(dist(tt) > maxdist / 4)
      nhor = tt;
   end
end
if nhor ~= -1
   nhorizon = nhor;
else
   nhorizon = length(gg_t);
end
n = nhorizon;
%tim = transpose([1:ndays]);
logd = log(dist(1:nhorizon));
tt1 = gg_t(1:nhorizon);
sumx = sum(tt1);
sumy = sum(logd);
sumx2 = sum(tt1 .* tt1);
sumxy = sum(tt1 .*  logd);
a = (sumxy - sumx * sumy / n) / (sumx2 - sumx * sumx / n);
b = sumy / n - a * sumx / n;

end

