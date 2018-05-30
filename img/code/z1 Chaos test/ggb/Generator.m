close all;
clear;
clc;

ts = linspace(0, 1, 500);
ys = cos(4*pi.*ts);

%%
csvwrite('ts.csv', ys');