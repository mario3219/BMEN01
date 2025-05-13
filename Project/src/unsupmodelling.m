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

        function [besta, bestb, bestd, beste, bestf, bestg, bestf1] = gridSearch(data,windowsizes, stepsizes, features, filter, points, filterthresholds, binsizes, k)
                
                    total_iterations = length(windowsizes) * length(stepsizes) * length(filter) * length(points) * length(filterthresholds) * length(binsizes);
                
                    % Preallocate
                    scores = zeros(total_iterations, 7); % [a, b, d, e, f, g, f1]
                
                    % Generate all combinations
                    idx = 1;
                    combinations = zeros(total_iterations, 6); % [a, b, d, e, f, g]
                    for a = windowsizes
                        for b = stepsizes
                            for d = filter
                                for e = points
                                    for f = filterthresholds
                                        for g = binsizes
                                            combinations(idx, :) = [a, b, d, e, f, g];
                                            idx = idx + 1;
                                        end
                                    end
                                end
                            end
                        end
                    end
                
                    % Start parallel pool if needed
                    if isempty(gcp('nocreate'))
                        parpool;
                    end
                
                    % Create DataQueue and progress tracker
                    D = parallel.pool.DataQueue;
                    p = 0; % counter for progress
                    afterEach(D, @(~) modelling.updateProgress(total_iterations, @() p + 1, @(v) assignin('base', 'p', v)));
                
                    % Initialize p in base workspace
                    assignin('base', 'p', 0);
                
                    % Parallel loop
                    parfor i = 1:total_iterations
                        a = combinations(i, 1);
                        b = combinations(i, 2);
                        d = combinations(i, 3);
                        e = combinations(i, 4);
                        f = combinations(i, 5);
                        g = combinations(i, 6);
                
                        predictions = unsupmodelling.predict(data, a, b, features, d, e, f, g, k);
                        
                        labels = inspect.getlabels(data,a,b);
                        f1 = inspect.f1score(labels, predictions);
                
                        scores(i, :) = [a, b, d, e, f, g, f1];
                
                        % Tell DataQueue that one iteration finished
                        send(D, i);
                    end
                
                    % Find best
                    [~, best_idx] = max(scores(:, 7));
                    best = scores(best_idx, :);
                
                    besta = best(1);
                    bestb = best(2);
                    bestd = best(3);
                    beste = best(4);
                    bestf = best(5);
                    bestg = best(6);
                    bestf1 = best(7);
        end

        function best_combo = featureSelection(data,windowsize,stepsize,filter,points,filterthreshold,binsize,features,initthreshold)
            n = numel(features);
            all_combinations = {};
            
            for k = 1:n
                combs = nchoosek(1:n, k);
                for i = 1:size(combs,1)
                    all_combinations{end+1} = features(combs(i,:));
                end
            end
            
            best_combo = "RMSSD";
            best_f1 = 0;
            total_iterations = length(all_combinations);
            iteration = 1;
            for comb = all_combinations
                fprintf("Progress: " + iteration + "/" + total_iterations + "\n");
                features = comb{1};
                predictions = unsupmodelling.predict(data, windowsize, stepsize, features, filter, points, filterthreshold, binsize, initthreshold);
                labels = inspect.getlabels(data,windowsize,stepsize);
                f1 = inspect.f1score(labels, predictions);
                if f1 > best_f1
                    best_f1 = f1;
                    best_combo = features;
                    fprintf("New best F1: " + f1 + "\n");
                end
                iteration = iteration + 1;
            end
            fprintf("Best features:");
            disp(best_combo)    
        end

    end
end
