clc,clear,close all

% Simple threshold test based only on RMSSD
% Assume afdb_1 -> afdb_4 is used for training
% Strategy: Calculate RMSSD for each training set, find the best threshold
% that provides the best F1 score, then validate the result with validation
% data (afdb_5 -> afdb_7)

%% Paths and conditions

% path to data
addpath('AF_RR_intervals/')
% path to source code
addpath('src')

% Set training window parameters here
stepsize = 10;
windowsize = 30;

%% Find largest label vector

% The training process will be slower if the rmssd_labels matrix is not
% initialized with a fixed size, therefore it is necessary to find the
% largest appropriate size before training starts

size = 0;
for data = {'afdb_1.mat','afdb_2.mat','afdb_3.mat','afdb_4.mat'}
    load(data{1})
    size = size + floor(length(rr)/windowsize);
end

%% Training

rmssd_labeled = zeros(size,2);
index = 1;

for data = {'afdb_1.mat','afdb_2.mat','afdb_3.mat','afdb_4.mat'}
    load(data{1})
    for i = 1:stepsize:(length(rr)-windowsize)
        deltarr = diff(rr(i:i+windowsize));
        rmssd = sqrt(mean(deltarr.^2));
        label = mode(targetsRR(i:i+windowsize));
        rmssd_labeled(index,:) = [rmssd, label];
        index = index + 1;
    end
end

thresholds = linspace(min(rmssd_labeled(:,1)), max(rmssd_labeled(:,1)));
predictions = zeros(height(rmssd_labeled(:,1)),2);
for t = thresholds

    for idx = height(rmssd_labeled)
        if rmssd_labeled(idx,1) > t
            predictions = predictions + rmssd_labeled(idx,:);
        end
    end
end