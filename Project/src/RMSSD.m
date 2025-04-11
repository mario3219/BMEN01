% Simple threshold detector based only on using RMSSD

classdef RMSSD
    methods(Static)
    % Class start

    % Strategy: Calculate RMSSD for each training set, perform predictions
    % based on a certain threshold, and return the threshold value which
    % provided the best F1 score.

    function threshold = train(trainingdata,windowsize,stepsize)

            % Calculate number of segments to label, also necessary to
            % initialize label matrix with appropriate size to prevent
            % resizing
            total_segments = 0;
            for i = 1:length(trainingdata)
                load(trainingdata{i})
                total_segments = total_segments + floor(length(rr)/windowsize);
            end
            rmssd_labeled = zeros(total_segments,2);
            
            % Calculate RMSSD values and store the corresponding label to
            % that window
            index = 1;
            for k = 1:length(trainingdata)
                load(trainingdata{k})
                for i = 1:stepsize:(length(rr)-windowsize)
                    deltarr = diff(rr(i:i+windowsize));
                    rmssd = sqrt(mean(deltarr.^2));
                    label = mode(targetsRR(i:i+windowsize));
                    rmssd_labeled(index,:) = [rmssd, label];
                    index = index + 1;
                end
            end

            % Separate scores and labels from matrix
            scores = rmssd_labeled(:,1);
            labels = rmssd_labeled(:,2);

            % Create threshold test vector
            thresholds = linspace(min(scores), max(scores));

            % Find the threshold which provides the best F1 score
            bestf1 = 0;
            threshold = 0;
            for t = thresholds
                predictions = scores > t;
                f1 = funcs.f1score(labels, predictions);
            
                if f1 > bestf1
                    bestf1 = f1;
                    threshold = t;
                end
            end
        end

    % Class end
    end
end