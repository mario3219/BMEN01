%
clc,clear, close all

% path to data
addpath('AF_RR_intervals/')
% path to source code
addpath('src')

%% Plot
data = "afdb_6.mat";
inspect.plotdata(data);

%%
data = "afdb_5.mat";
load(data)
screenSize = get(0, 'ScreenSize');
fig = figure('Units', 'pixels', 'Position', [screenSize(3)/4, screenSize(4)/4, 400, 300]);
subplot(3,1,1),plot(targetsRR), ylim([0.5 1.5]);
xlabel(data)
ylabel('targetsRR');

data = "afdb_6.mat";
load(data)
subplot(3,1,2),plot(targetsRR), ylim([0.5 1.5]);
xlabel(data);
ylabel('targetsRR');

data = "afdb_7.mat";
load(data)
subplot(3,1,3),plot(targetsRR), ylim([0.5 1.5]);
xlabel(data);
ylabel('targetsRR');

% targetsRR: label vector (0: normal, 1: AF)
% QRS: QRS detector
% rr: time between heartbeats
% qrs: timestamps for R-peaks, the difference between each element
% represents RR-interval time

%% Poincare
data = "afdb_7.mat";
inspect.poincare(data,1,100,0.05);

%% Compare qrs_diff to rr
load(data)
rr_diff = diff(qrs) / Fs;
figure,
subplot(1,2,1),plot(rr_diff),title("rr diff")
subplot(1,2,2),plot(rr),title("rr")

%% Median filter test
load("afdb_6.mat")
points = 7;
threshold = 1;
filtered = modelling.medianfilter(rr,points,threshold);
figure
subplot(2,1,1),plot(rr),title("Unfiltered rr"),ylim([0 2]);
subplot(2,1,2),plot(filtered),title("Filtered rr"),ylim([0 2]);


%% Heartrate
load("afdb_7.mat")

% Heartrate
heartrate = inspect.getheartrate(rr);
figure,plot(heartrate),title("Heartrate")