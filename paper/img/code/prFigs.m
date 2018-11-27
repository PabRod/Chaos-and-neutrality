close all;
clc;

subplot(3, 1, 1);
createFigures('2-3p.mat', 'z1');
xlim([-.8 .8]);
title('\fontsize{16} 5 species');
xlabel('');
ylabel('\fontsize{14} Probability of chaos');

subplot(3, 1, 2);
createFigures('4-6p.mat', 'z1');
xlim([-.8 .8]);
title('\fontsize{16} 10 species');
xlabel('');
ylabel('\fontsize{14} Probability of chaos');

subplot(3, 1, 3);
createFigures('12-18p.mat', 'z1');
xlim([-.8 .8]);
title('\fontsize{16} 30 species');
xlabel('');
ylabel('\fontsize{14} Probability of chaos');

xlabel('\fontsize{14} Competition parameter \epsilon');