% Class with functions to inspect and evaluate data

classdef inspect
    methods(Static)
    % Class start
        % Generates subplots of all variables in given dataset
        function plotdata(data)
            load(data)
            screenSize = get(0, 'ScreenSize');
            fig = figure('Units', 'pixels', 'Position', [screenSize(3)/4, screenSize(4)/4, 2000, 400]);
            subplot(1,4,1),plot(targetsRR),title('targetsRR'), ylim([0.5 1.5])
            subplot(1,4,2),plot(targetsQRS),title('targetsQRS'), ylim([0.5 1.5])
            subplot(1,4,3),plot(rr),title('rr')
            subplot(1,4,4),plot(qrs),title('qrs')
        end

        function TP = TP(labels,predictions)
            TP = 0;
            for i = 1:length(labels)
                if predictions(i,2) == 1 && predictions(i,2) == labels(i)
                    TP = TP + 1;
                end
            end
        end

        function TN = TN(labels,predictions)
            TN = 0;
            for i = 1:length(labels)
                if predictions(i,2) == 0 && predictions(i,2) == labels(i)
                    TN = TN + 1;
                end
            end
        end

        function FP = FP(labels,predictions)
            FP = 0;
            for i = 1:length(labels)
                if predictions(i,2) == 1 && predictions(i,2) ~= labels(i)
                    FP = FP + 1;
                end
            end
        end

        function FN = FN(labels,predictions)
            FN = 0;
            for i = 1:length(labels)
                if predictions(i,2) == 0 && predictions(i,2) ~= labels(i)
                    FN = FN + 1;
                end
            end
        end

        function f1 = f1score(y_true, y_pred)
            tp = sum((y_pred == 1) & (y_true == 1));
            fp = sum((y_pred == 1) & (y_true == 0));
            fn = sum((y_pred == 0) & (y_true == 1));
        
            precision = tp / (tp + fp + eps);
            recall = tp / (tp + fn + eps);
        
            f1 = 2 * (precision * recall) / (precision + recall + eps);
        end

        % Data processing functions
        function labels = getlabels(data,windowsize,stepsize)
            load(data)
            total_segments = floor(length(rr)/windowsize);
            
            % Validation labels vector
            labels = zeros(total_segments,1);
            index = 1;
            for i = 1:stepsize:(length(rr)-windowsize)
                % Extracts the most frequent label in the window
                label = mode(targetsRR(i:i+windowsize-1));
                labels(index) = label;
                index = index + 1;
            end
        end
        
    % Class end
    end
end