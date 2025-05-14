clc,clear

% Paths and conditions

% path to data
addpath('AF_RR_intervals/')
% path to source code
addpath('src/')

%%

load('afdb_1.mat')

X = rr;
Y = targetsRR;

model = fitcsvm(X,Y);
