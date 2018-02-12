clc;
close all;

load('portable.mat');

levels = [.0, .1, .2, .3, .4, .5, .6, .7, .8, .9, .95, .975, 0.99, 1];
[c, h] = contourf(competition_pars, nSpecies, summaries, levels);
xlim([-.8 .8]);
clabel(c, h);

title('\fontsize{16} Probability of chaos');
xlabel('\fontsize{14} Competition parameter \epsilon');
ylabel('\fontsize{14} Number of species (predators + prey)');