% This script involves functions used to inspect the data

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

% Class end
    end
end