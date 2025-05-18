clc,clear

% Paths and conditions

% path to data
addpath('AF_RR_intervals/')
% path to source code
addpath('src/')

%%

trainingdata = {'afdb_1.mat','afdb_2.mat','afdb_3.mat','afdb_4.mat'};

windowsize = 30;
stepsize = 30;
features = ["RMSSD","SSampEn","Poincare"];
filter_train = 1;
filter_predict = 1;
points = 7;
filterthreshold = 1.2;
binsize=0.04;

figure

validationdata = 'afdb_5.mat';
load(validationdata)
model = modelling.SVMtrain(trainingdata,windowsize,stepsize,features,filter_train,points,filterthreshold,binsize);
predictions = modelling.SVMpredict(model,validationdata,windowsize,stepsize,features,binsize,filter_predict,points,filterthreshold);
xrange = linspace(0,length(rr),length(predictions));
subplot(3,1,1),plot(xrange,predictions),ylim([0.5 1.5]),xlabel(validationdata),ylabel("Predicted labels");
title("SVM")

validationdata = 'afdb_6.mat';
load(validationdata)
model = modelling.SVMtrain(trainingdata,windowsize,stepsize,features,filter_train,points,filterthreshold,binsize);
predictions = modelling.SVMpredict(model,validationdata,windowsize,stepsize,features,binsize,filter_predict,points,filterthreshold);
xrange = linspace(0,length(rr),length(predictions));
subplot(3,1,2),plot(xrange,predictions),ylim([0.5 1.5]),xlabel(validationdata),ylabel("Predicted labels");

validationdata = 'afdb_7.mat';
load(validationdata)
model = modelling.SVMtrain(trainingdata,windowsize,stepsize,features,filter_train,points,filterthreshold,binsize);
predictions = modelling.SVMpredict(model,validationdata,windowsize,stepsize,features,binsize,filter_predict,points,filterthreshold);
xrange = linspace(0,length(rr),length(predictions));
subplot(3,1,3),plot(xrange,predictions),ylim([0.5 1.5]),xlabel(validationdata),ylabel("Predicted labels");
xlim([0 max(xrange)])
