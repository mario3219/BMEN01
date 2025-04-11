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

windowsize = 30;
stepsize = 10;

% Train & predict
threshold = RMSSD.train(trainingdata,30,10);
results = RMSSD.predict(validationdata,threshold,30,10);

%% Performance evaluation

load(validationdata)

% Calculate amount of windows to validate on
% The amount of windows should be proportional to the predicted amount
total_segments = floor(length(rr)/windowsize);

% Validation labels vector
labels = zeros(total_segments,1);
index = 1;
for i = 1:stepsize:(length(rr)-windowsize)
    % Extracts the most frequent label in the window
    label = mode(targetsRR(i:i+windowsize));
    labels(index) = label;
    index = index + 1;
end

% Summarizes if predicted is equal to true label
true_values = 0;
for i = 1:length(labels)
    if results(i,2) == labels(i)
        true_values = true_values + 1;
    end
end

fprintf("Accuracy: " + true_values/length(labels))