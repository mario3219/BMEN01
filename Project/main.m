clc,clear,close all

% Paths and conditions

% path to data
addpath('AF_RR_intervals/')
% path to source code
addpath('src/')

% Load data

trainingdata = {'afdb_1.mat','afdb_2.mat','afdb_3.mat','afdb_4.mat'};
validationdata = {'afdb_5.mat','afdb_6.mat','afdb_7.mat'};
validationdata = validationdata{2}; % Change which data to validate against here

%% RMSSD

% Simple threshold detector based only on RMSSD
% Assume afdb_1 -> afdb_4 is used for training
% Strategy: Calculate RMSSD for each training set, find the best threshold
% that provides the best F1 score, then validate the result with validation
% data (afdb_5 -> afdb_7)

windowsize = 10;
stepsize = 5;
criterion = "RMSSD";
filter = "ON";
points = 10;
filterthreshold = 0.2;

% Train & predict
threshold = modelling.train(trainingdata,windowsize,stepsize,criterion,filter,points,filterthreshold);
predictions = modelling.predict(validationdata,windowsize,stepsize,criterion,threshold);

% Performance evaluation
labels = inspect.getlabels(validationdata,windowsize,stepsize);
TP = inspect.TP(labels,predictions);
TN = inspect.TN(labels,predictions);
Accuracy = (TP+TN)/length(labels);

fprintf("Accuracy: " + Accuracy)