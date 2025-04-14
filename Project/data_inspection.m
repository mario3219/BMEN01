clc,close all

%%
clc,clear

% path to data
addpath('AF_RR_intervals/')
% path to source code
addpath('src')

%% Plot
inspect.plotdata(data{6});

% targetsRR: label vector (0: normal, 1: AF)
% QRS: QRS detector
% rr: time between heartbeats
% qrs: timestamps for R-peaks, the difference between each element
% represents RR-interval time, as proven by:

rr_diff = diff(qrs) / Fs;
figure,
subplot(1,2,1),plot(rr_diff),title("rr_diff")
subplot(1,2,2),plot(rr),title("rr")

%% Median test
load("afdb_7.mat")
points = 9;
threshold = 0.2;
filtered = modelling.medianfilter(rr,points,threshold);
figure
subplot(2,1,1),plot(rr),title("Unfiltered rr"),ylim([0 2]);
subplot(2,1,2),plot(filtered),title("Filtered rr"),ylim([0 2]);


%% Heartrate
load("afdb_7.mat")

% Heartrate
heartrate = inspect.getheartrate(rr);
figure,plot(heartrate),title("Heartrate")