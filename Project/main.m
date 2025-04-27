clc,clear,close all

% Paths and conditions

% path to data
addpath('AF_RR_intervals/')
% path to source code
addpath('src/')

% Load data

trainingdata = {'afdb_1.mat','afdb_2.mat','afdb_3.mat','afdb_4.mat'};
validationdata = {'afdb_5.mat','afdb_6.mat','afdb_7.mat'};
validationdata = validationdata{1}; % Change which data to validate against here

%% Gridsearch

windowsizes = 20:20:100;
stepsizes = 50:20:100;
features = "SSampEn";
filters = "ON";
points = 10:20:50;
filterthresholds = 0.2:0.1:0.4;
binsizes=0.1:0.1:0.5;

[a,b,d,e,f,g] = modelling.gridSearch(trainingdata,validationdata,windowsizes,stepsizes,features,filters,points,filterthresholds,binsizes);
fprintf("Windowsize: " + a + "\n" + "Stepsize: " + b + "\n" + "Points: " + e + "\n" + "Median Filter threshold: " + f + "\n" + "Binsize: " + g + "\n");

%% SVM

windowsize = 100;
stepsize = 90;
features = ["SSampEn","RMSSD","Poincare"];
filter = "ON";
points = 50;
filterthreshold = 0.4;
binsize=0.5;

model = modelling.SVMtrain(trainingdata,windowsize,stepsize,features,filter,points,filterthreshold,binsize);
predictions = modelling.SVMpredict(model,validationdata,windowsize,stepsize,features,binsize);

inspect.compare(validationdata,predictions,windowsize,stepsize);

%% RMSSD

% Simple threshold detector based only on RMSSD
% Assume afdb_1 -> afdb_4 is used for training
% Strategy: Calculate RMSSD for each training set, find the best threshold
% that provides the best F1 score, then validate the result with validation
% data (afdb_5 -> afdb_7)

windowsize = 30;
stepsize = 30;
feature = "RMSSD";
filter = "ON";
points = 10;
filterthreshold = 0.2;
binsize = 0;

% Train & predict
threshold = modelling.train(trainingdata,windowsize,stepsize,feature,binsize,filter,points,filterthreshold);
predictions = modelling.predict(validationdata,windowsize,stepsize,feature,binsize,threshold);

% Performance evaluation
inspect.compare(validationdata,predictions(:,2),windowsize,stepsize);
inspect.scoreDistribution(predictions)

%% SSampEn
windowsize = 30;
stepsize = 30;
feature = "SSampEn";
filter = "ON";
points = 10;
filterthreshold = 0.2;

threshold = modelling.train(trainingdata,windowsize,stepsize,feature,binsize,filter,points,filterthreshold);
predictions = modelling.predict(validationdata,windowsize,stepsize,feature,binsize,threshold);

inspect.compare(validationdata,predictions(:,2),windowsize,stepsize);
inspect.scoreDistribution(predictions)

%% Poincare

windowsize = 30;
stepsize = 30;
feature = "Poincare";
filter = "ON";
points = 10;
filterthreshold = 0.2;
binsize = 0.025;

threshold = modelling.train(trainingdata,windowsize,stepsize,feature,binsize,filter,points,filterthreshold);
predictions = modelling.predict(validationdata,windowsize,stepsize,feature,binsize,threshold);

inspect.compare(validationdata,predictions(:,2),windowsize,stepsize);
inspect.scoreDistribution(predictions)
