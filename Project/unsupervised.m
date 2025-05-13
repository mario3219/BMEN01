clc,clear,close all

% Paths and conditions

% path to data
addpath('AF_RR_intervals/')
% path to source code
addpath('src/')

trainingdata = {'afdb_1.mat','afdb_2.mat','afdb_3.mat','afdb_4.mat'};
validationdata = 'afdb_5.mat';

%% GridSearch

data = 'afdb_7.mat';

windowsizes = 1:50:201;
stepsizes = 1:50:201;
features = ["SSampEn","RMSSD","Poincare","pNN50","SDNN"];
filter = 1;
points = 1:5:20;
filterthresholds = 0.1:0.5:2;
binsizes=0.05:0.05:0.2;
initthreshold = 0;

[besta, bestb, bestd, beste, bestf, bestg, bestf1] = unsupmodelling.gridSearch(data, windowsizes, stepsizes, features, filter, points, filterthresholds, binsizes, initthreshold);

%% Feature selection

data = 'afdb_1.mat';

windowsize = 100;
stepsize = 150;
features = ["SSampEn","RMSSD","Poincare","pNN50","SDNN"];
filter = 1;
points = 6;
filterthreshold = 1.2;
binsize=0.2;
initthreshold = 0;

unsupmodelling.featureSelection(data,windowsize,stepsize,filter,points,filterthreshold,binsize,features,initthreshold);

%% Unsupervised Classifier

data = 'afdb_1.mat';

windowsize = 100;
stepsize = 150;
features = ["SSampEn","RMSSD"];
filter = 1;
points = 6;
filterthreshold = 1.2;
binsize=0.2;
initthreshold = 0;

predictions = unsupmodelling.predict(data, windowsize, stepsize, features, filter, points, filterthreshold, binsize, initthreshold);
inspect.compare(data,predictions,windowsize,stepsize,points,filterthreshold)