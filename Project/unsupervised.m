clc,clear,close all

% Paths and conditions

% path to data
addpath('AF_RR_intervals/')
% path to source code
addpath('src/')

trainingdata = {'afdb_1.mat','afdb_2.mat','afdb_3.mat','afdb_4.mat'};
validationdata = 'afdb_5.mat';

%% Unsupervised Classifier

data = 'afdb_7.mat';

windowsize = 200;
stepsize = 200;
features = ["SSampEn","RMSSD","Poincare","pNN50","SDNN"];
filter = 1;
points = 7;
filterthreshold = 1.2;
binsize=0.04;
initthreshold = 0;

predictions = unsupmodelling.predict(data, windowsize, stepsize, features, filter, points, filterthreshold, binsize, initthreshold);
inspect.compare(data,predictions,windowsize,stepsize,points,filterthreshold)