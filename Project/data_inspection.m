clc,close all

%%
clc,clear

% path to data
addpath('AF_RR_intervals/')
% path to source code
addpath('src')

%% Inspect data
data = {'afdb_1.mat','afdb_2.mat','afdb_3.mat','afdb_4.mat','afdb_5.mat','afdb_6.mat','afdb_7.mat'};
inspect.plotdata(data{6});

%%
load("afdb_1.mat")

% Compare labeled RR and rr
figure, plot(targetsRR), ylim([0.5 1.5]), xlim([2500 4000]), title('targetsRR')
figure, plot(rr), xlim([2500 4000]), title('rr')

% Compare labeled QRS and rr
figure, plot(targetsQRS), ylim([0.5 1.5]), xlim([2500 4000]), title('targetsQRS')

% targetsRR: label vector (0: normal, 1: AF)
% QRS: QRS detector
% rr: time between heartbeats
% qrs: timestamps for R-peaks, the difference between each element
% represents RR-interval time, as proven by:

rr_diff = diff(qrs) / Fs;
figure,
subplot(1,2,1),plot(rr_diff),title("rr_diff")
subplot(1,2,2),plot(rr),title("rr")