%
clc,clear, close all

% path to data
addpath('AF_RR_intervals/')
% path to source code
addpath('src')

%% Plot
data = "afdb_6.mat";
inspect.plotdata(data);

% targetsRR: label vector (0: normal, 1: AF)
% QRS: QRS detector
% rr: time between heartbeats
% qrs: timestamps for R-peaks, the difference between each element
% represents RR-interval time

%% Compare qrs_diff to rr
load(data)
rr_diff = diff(qrs) / Fs;
figure,
subplot(1,2,1),plot(rr_diff),title("rr diff")
subplot(1,2,2),plot(rr),title("rr")

%% Median filter test
load("afdb_6.mat")
points = 100;
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