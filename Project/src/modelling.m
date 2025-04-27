% This script involves functions related to modelling

classdef modelling
    methods(Static)
% Class start

        % Model training and prediction functions
        % These functions require threshold criterion based models
        % The training is performed by selecting threshold based on best
        % performing F1 score

        % Strategy: Calculate score for each training set, perform predictions
        % based on a certain threshold, and return the threshold value which
        % provided the best F1 score.

        function threshold = train(trainingdata,windowsize,stepsize,feature,binsize,filter,points,filterthreshold)

            % Calculate number of segments to label, also necessary to
            % initialize label matrix with appropriate size to prevent
            % resizing
            total_segments = 0;
            for i = 1:length(trainingdata)
                load(trainingdata{i})
                total_segments = total_segments + length(1:stepsize:(length(rr)-windowsize));
            end
            results = zeros(total_segments,2);
            
            % Start iterating through trainingdata
            index = 1;
            for k = 1:length(trainingdata)
                
                load(trainingdata{k})
                
                % Ectopic beats filter
                if filter == "ON"
                    rr = modelling.medianfilter(rr,points,filterthreshold);
                end
                
                % TRAINING: Calculate score values and store the corresponding label to
                % that window
                for i = 1:stepsize:(length(rr)-windowsize)

                    % If-statements depending on which parameters the user
                    % wishes to compute

                    % Criterions input start
                    if feature == "RMSSD"
                        score = RMSSD.func(rr,windowsize,i);
                    elseif feature == "SSampEn"
                        score = SSampEn.func(rr, windowsize, i);
		            elseif feature == "Poincare"
			            score = Poincare.func(rr,windowsize,i,binsize);
		            else
                        error("Unknown feature: %s", feature)
                    end
                    % Criterion inputs end
                    
                    % Get true labels for that window
                    label = mode(targetsRR(i:i+windowsize));
                    results(index,:) = [score, label];
                    index = index + 1;
                end
            end

            % Separate scores and labels from matrix
            scores = results(:,1);
            labels = results(:,2);

            % Create threshold test vector
            thresholds = linspace(min(scores), max(scores),1000);

            % Find the threshold which provides the best F1 score
            bestf1 = 0;
            threshold = 0;
            for t = thresholds
                predictions = scores > t;
                f1 = inspect.f1score(labels, predictions);
                    
                if f1 > bestf1
                    bestf1 = f1;
                    threshold = t;
                end
            end

        end

        function result = predict(data,windowsize,stepsize,feature,binsize,threshold)
            load(data);
            total_segments = length(1:stepsize:(length(rr)-windowsize));
            result = zeros(total_segments,2);
            index = 1;
            for i = 1:stepsize:(length(rr)-windowsize)
    
                % If statements depending on which criterion the user
                % wishes to compute

                % Criterions input start
                if feature == "RMSSD"
                    score = RMSSD.func(rr,windowsize,i);
                elseif feature == "SSampEn"
                    score = SSampEn.func(rr, windowsize, i);
		        elseif feature == "Poincare"
		            score = Poincare.func(rr,windowsize,i,binsize);
                else
                    error("Unknown feature: %s", feature)
                end
                % Criterions input end
    
                % If score passes the threshold, it is labelled as 1
                if score > threshold
                    result(index,:) = [score, 1];
                else
                    result(index,:) = [score, 0];
                end
                index = index + 1;
            end
        end

        function rr = medianfilter(rr,points,threshold)
            for i = 1:points:(length(rr)-points)
                median = rr(i+round(points/2));
                for k = i:1:i+points
                    if rr(k)/median >= 1+threshold || rr(k)/median <= 1-threshold
                        rr(k) = median;
                    end
                end
            end
        end

        function result = containsString(vector, target)
            % Check if target is in the vector
            result = any(strcmp(vector, target));
        end

    function model = SVMtrain(trainingdata, windowsize, stepsize, features, filter, points, filterthreshold, binsize)
        total_segments = 0;
        for i = 1:length(trainingdata)
            load(trainingdata{i});
            total_segments = total_segments + length(1:stepsize:(length(rr) - windowsize));
        end
    
        results = zeros(total_segments, length(features) + 1); % +1 for label
    
        index = 1;
        for k = 1:length(trainingdata)
            load(trainingdata{k});
    
            % Ectopic beats filter
            if filter == "ON"
                rr = modelling.medianfilter(rr, points, filterthreshold);
            end
    
            % Calculate scores + labels
            for i = 1:stepsize:(length(rr) - windowsize)
                label = mode(targetsRR(i:i+windowsize));
    
                for f = 1:length(features)
                    feature_name = features{f};
    
                    switch feature_name
                        case "RMSSD"
                            score = RMSSD.func(rr, windowsize, i);
                        case "SSampEn"
                            score = SSampEn.func(rr, windowsize, i);
                        case "Poincare"
                            score = Poincare.func(rr, windowsize, i, binsize);
                    end
                    results(index, f) = score;
                end
    
                % Store label in the last column
                results(index, length(features) + 1) = label;
                index = index + 1;
            end
        end
    
        % Remove rows where all features are zero
        results(all(results == 0, 2), :) = [];
    
        % Separate features and labels
        X = results(:, 1:end-1); % Features
        Y = results(:, end);     % Labels
    
        % Train SVM
        model = fitcsvm(X, Y);
    end

    function predictions = SVMpredict(SVM, data, windowsize, stepsize, features, binsize)
        load(data);
    
        total_segments = length(1:stepsize:(length(rr) - windowsize));
        formatted_data = zeros(total_segments, length(features));
        index = 1;
    
        for i = 1:stepsize:(length(rr) - windowsize)
            for f = 1:length(features)
                feature_name = features{f};
    
                switch feature_name
                    case "RMSSD"
                        score = RMSSD.func(rr, windowsize, i);
                    case "SSampEn"
                        score = SSampEn.func(rr, windowsize, i);
                    case "Poincare"
                        score = Poincare.func(rr, windowsize, i, binsize);
                end
                formatted_data(index, f) = score;
            end
            index = index + 1;
        end
    
        % Remove rows where all features are zero
        formatted_data(all(formatted_data == 0, 2), :) = [];
    
        % Predict
        predictions = predict(SVM, formatted_data);
    end


        function [besta,bestb,bestd,beste,bestf,bestg] = gridSearch(trainingdata,validationdata,windowsizes,stepsizes,features,filter,points,filterthresholds,binsizes)
            bestf1 = 0;
            total_iterations = length(windowsizes)*length(stepsizes)*length(features)*length(filter)*length(points)*length(filterthresholds)*length(binsizes);
            iteration = 1;
            for a = windowsizes
                for b = stepsizes
                        for d = filter
                            for e = points
                                for f = filterthresholds
                                    for g = binsizes
                                        fprintf("Progress: " + iteration + "/" + total_iterations + "\n");
                                        model = modelling.SVMtrain(trainingdata,a,b,features,d,e,f,g);
                                        predictions = modelling.SVMpredict(model,validationdata,a,b,features,g);
                                        labels = inspect.getlabels(validationdata,a,b);
                                        f1 = inspect.f1score(labels, predictions);
                                        if f1 > bestf1
                                            fprintf("New best: " + f1 + "\n")
                                            besta=a;bestb=b;bestd=d;beste=e;bestf=f;bestg=g;
                                            bestf1 = f1;
                                        end
                                        iteration = iteration + 1;
                                    end
                                end
                            end
                        end
                end
            end
        end

% Class end
    end
end
