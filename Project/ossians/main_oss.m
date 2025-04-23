clc,clear,close all

% Paths and conditions



% Load data

trainingdata = {'afdb_1.mat','afdb_2.mat','afdb_3.mat','afdb_4.mat'};
validationdata = {'afdb_5.mat','afdb_6.mat','afdb_7.mat'};
validationdata = validationdata{1}; % Change which data to validate against here

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
inspect.compare(validationdata,predictions,windowsize,stepsize);
inspect.scoreDistribution(predictions)
%% SSampEn
windowsize = 30;
stepsize = 30;
criterion = "SSampEn";
filter = "OFF";
points = 10;
filterthreshold = 0.2;

threshold = modelling.train(trainingdata,windowsize,stepsize,criterion,filter,points,filterthreshold);
predictions = modelling.predict(validationdata,windowsize,stepsize,criterion,threshold);

inspect.compare(validationdata,predictions,windowsize,stepsize);
inspect.scoreDistribution(predictions)

