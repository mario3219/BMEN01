clc,clear,close all

% Simple threshold detector based only on RMSSD
% Assume afdb_1 -> afdb_4 is used for training
% Strategy: Calculate RMSSD for each training set, find the best threshold
% that provides the best F1 score, then validate the result with validation
% data (afdb_5 -> afdb_7)

%% Paths and conditions

% path to data
addpath('AF_RR_intervals/')
% path to source code
addpath('src/')

%% Training and prediction

trainingdata = {'afdb_1.mat','afdb_2.mat','afdb_3.mat','afdb_4.mat'};
validationdata = {'afdb_5.mat','afdb_6.mat','afdb_7.mat'};
validationdata = validationdata{1}; % Change which data to validate against here

windowsize = 5;
stepsize = 5;

% Train & predict
threshold = modelling.train(trainingdata,"RMSSD",windowsize,stepsize);
predictions = modelling.predict(validationdata,threshold,"RMSSD",windowsize,stepsize);

%% Performance evaluation
labels = inspect.getlabels(validationdata,windowsize,stepsize);
TP = inspect.TP(labels,predictions);
TN = inspect.TN(labels,predictions);
Accuracy = (TP+TN)/length(labels);

fprintf("Accuracy: " + Accuracy)