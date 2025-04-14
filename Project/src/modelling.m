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

        function threshold = train(trainingdata, criterion, windowsize,stepsize)

            % Calculate number of segments to label, also necessary to
            % initialize label matrix with appropriate size to prevent
            % resizing
            total_segments = 0;
            for i = 1:length(trainingdata)
                load(trainingdata{i})
                total_segments = total_segments + length(1:stepsize:(length(rr)-windowsize));
            end
            results = zeros(total_segments,2);
            
            % Calculate score values and store the corresponding label to
            % that window
            index = 1;
            for k = 1:length(trainingdata)
                load(trainingdata{k})
                for i = 1:stepsize:(length(rr)-windowsize)

                    % If-statements depending on which criterion the user
                    % wishes to compute

                    % Criterions input start
                    if criterion == "RMSSD"
                        score = RMSSD.func(rr,windowsize,i);
                    end
                    % Criterion inputs end

                    label = mode(targetsRR(i:i+windowsize));
                    results(index,:) = [score, label];
                    index = index + 1;
                end
            end

            % Separate scores and labels from matrix
            scores = results(:,1);
            labels = results(:,2);

            % Create threshold test vector
            thresholds = linspace(min(scores), max(scores));

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

        function result = predict(data,threshold,criterion,windowsize,stepsize)
            load(data);
            total_segments = length(1:stepsize:(length(rr)-windowsize));
            result = zeros(total_segments,2);
            index = 1;
            for i = 1:stepsize:(length(rr)-windowsize)
    
                % If statements depending on which criterion the user
                % wishes to compute

                % Criterions input start
                if criterion == "RMSSD"
                    score = RMSSD.func(rr,windowsize,i);
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

        function result = medianfilter(rr,points,threshold)
            result = rr;
            for i = 1:points:(length(result)-points)
                median = result(i+points);
                for k = i:1:i+points
                    if result(k)/median >= 1+threshold || result(k)/median <= 1-threshold
                        result(k) = median;
                    end
                end
            end
        end

% Class end
    end
end