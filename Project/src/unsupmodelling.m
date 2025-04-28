classdef unsupmodelling
    methods(Static)
        function predictions = predict(data, windowsize, stepsize, features, filter, points, filterthreshold, binsize, initial_threshold)
            load(data);
            total_segments = length(1:stepsize:(length(rr)-windowsize));
            predictions = zeros(total_segments,1); % +1 for label
            
            index = 1;
            af = 0; 
            distances = [];
            adapt_rate = 10;

            % Ectopic beats filter
            if filter == 1
                rr = modelling.medianfilter(rr, points, filterthreshold);
            end

            currentWindow = zeros(length(features),1);
            testWindow = zeros(length(features),1);
            threshold = initial_threshold;

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
                        case "pNN50"
                            score = pNN50.func(rr, windowsize, i);
                        case "SDNN"
                            score = SDNN.func(rr,windowsize,i);
                    end
                    currentWindow(f) = score;
                end

                if i == 1
                    testWindow = currentWindow;
                else
                    diff = norm(testWindow - currentWindow,2);
                    distances = [distances, diff];
                    if mod(index, adapt_rate) == 0 && length(distances) >= adapt_rate
                        threshold = mean(distances(end-adapt_rate+1:end)) + 2*std(distances(end-adapt_rate+1:end));
                    end

                    if diff > threshold
                        testWindow = currentWindow;
                        af = 1;
                    else
                        af = 0;
                    end
                    predictions(index) = af;
                end

                index = index + 1;
            end
        end
    end
end
