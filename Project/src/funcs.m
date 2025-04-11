% This script involves functions used to inspect the data

classdef funcs
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

        function f1 = f1score(y_true, y_pred)
            tp = sum((y_pred == 1) & (y_true == 1));
            fp = sum((y_pred == 1) & (y_true == 0));
            fn = sum((y_pred == 0) & (y_true == 1));
        
            precision = tp / (tp + fp + eps);
            recall = tp / (tp + fn + eps);
        
            f1 = 2 * (precision * recall) / (precision + recall + eps);
        end

% Class end
    end
end