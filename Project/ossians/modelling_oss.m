% This script involves functions related to modelling

% -----------------------------------------------%
% Information about RMSSD
%
% It takes the differences between sucessive squares and then the average
% of these. Then the square root of this answer. 
%
% This parameter does NOT account for changes in heart rate. But it can be
% designed so that it does implicitly depend on it.
%
% If we use  this heart rate normalized RMSSD, then this is identical to
% the Pcv
%
% When using NMASD which is the normalized verion it has about the same
% performance as Pcv. So, Pcv, Prmssd and Pnmasd convey the same
% information for RR dispersion.
%
%








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

        function threshold = train(trainingdata,windowsize,stepsize,criterion,filter,points,filterthreshold)

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
                
                if filter == "ON"
                    rr = modelling.medianfilter(rr, points, filterthreshold);
                end
                
                for i = 1:stepsize:(length(rr)-windowsize)
                    % Modified criterion selection
                    if criterion == "RMSSD"
                        score = RMSSD.func(rr, windowsize, i);
                    elseif criterion == "SSampEn"
                        score = SSampEn(rr, windowsize, i); 
                    else
                        error('Unknown criterion: %s', criterion);
                    end
                    
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






      
       
          function result = predict(data, windowsize, stepsize, criterion, threshold)
            load(data);
            total_segments = length(1:stepsize:(length(rr)-windowsize));
            result = zeros(total_segments,2);
            index = 1;
            
            for i = 1:stepsize:(length(rr)-windowsize)
                % Modified criterion selection
                if criterion == "RMSSD"
                    score = RMSSD.func(rr, windowsize, i);
                elseif criterion == "SSampEn"
                    score = SSampEn(rr, windowsize, i); 
                else
                    error('Unknown criterion: %s', criterion);
                end
                
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
                median = rr(i+points);
                for k = i:1:i+points
                    if rr(k)/median >= 1+threshold || rr(k)/median <= 1-threshold
                        rr(k) = median;
                    end
                end
            end
        end

% Class end
    end
end