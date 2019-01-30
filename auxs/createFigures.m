function createFigures(resultsArrayLocation, options)
%CREATEFIGURES Creates some figures useful for exploratory analysis and
%showing results
%
%   The possible options are:
%   'maxLyaps': for plotting maximum Lyapunov exponents
%   'maxLyapsFiltered': a combined plot of maximum Lyapunov exponents and
%   other chaos tests
%   'probabilities': probabilities of chaos using different measures
%   'comparer': agreement comparer between the different tests for
%   individual runs
%   'summary': probability of chaos vs. competition parameter
%   'z12': probability of chaos vs. competition parameter (using z test)
%   'speciesCount': number of non-extinct species
%   'evenness': species' evenness
%   'preyCount': number of non-extinct prey species
%   'preyEven': prey species'evenness
%   'biodchaosvsregular': biodiversity comparer chaotic cases vs regular
%   cases
%   'evenchaosvsregular': evenness comparer chaotic cases vs regular
%   cases
%   'biodboxandwhisker': biodiversity box and whisker plot
%   'biodvslyap': biodiversity vs max lyapunov exponent
%   'biodsplitbychaos': biodiversity vs competition parameter, splitted by
%   asymptotic dynamics (chaotic/regular)
%   'biodsplitbychaosdiff': biodiversity vs competition parameter, splitted by
%   asymptotic dynamics (chaotic/regular), and substracted
%   'evensplitbychaos': evenness vs competition parameter, splitted by
%   asymptotic dynamics (chaotic/regular)

%% Load results
resultsArray = loadResults(resultsArrayLocation);

%% Measure the input
[nreps, npars] = size(resultsArray);
N = nreps.*npars;

switch options
    
    case 'maxLyaps'
        competition_pars = resultsAsMatrix(resultsArray, 'competition_par');
        max_lyaps = resultsAsMatrix(resultsArray, 'maxLyapunov');
        
        %% Compute statistical data
        m = zeros(1, npars); % Mean
        s = zeros(1, npars); % SD
        prob = zeros(1, npars); % Probability of chaos
        for i = 1:npars
            m(i) = mean(max_lyaps(:, i));
            s(i) = std(max_lyaps(:, i));
            prob(i) = sum(max_lyaps(:, i) > 0)/nreps;
        end
        
        %% Plot Lyapunov analysis results
        hold on;
        for j = 1:nreps
            PlotMaxLyaps(competition_pars, max_lyaps(j,:));
        end
        
        % Add some aesthetics
        plot(competition_pars, m, 'color', 'k'); % Plot mean
        plot(competition_pars, m + s, '--', 'color', 'k'); % Plot +- sd
        plot(competition_pars, m - s, '--', 'color', 'k'); % Plot +- sd
        plot([competition_pars(1), competition_pars(end)], [0 0], '-', 'color', 'k'); % Plot line at y = 0
        text = sprintf('Lyapunov exponent analysis \n Case: %s', resultsArray{1,1}.id);
        title(text);
        xlabel('Competition parameter'); ylabel('Max Lyapunov exponent'); % Add axis labels
        
    case 'maxLyapsFiltered'
        competition_pars = resultsAsMatrix(resultsArray, 'competition_par');
        isChaos_Lyap = resultsAsMatrix(resultsArray, 'lyapunov');
        isChaos_z1 = resultsAsMatrix(resultsArray, 'z1');
        isChaos_z12 = resultsAsMatrix(resultsArray, 'z12');
        max_lyaps = resultsAsMatrix(resultsArray, 'maxLyapunov');
        max_lyaps_filtered = max_lyaps.*isChaos_z12.*isChaos_Lyap;
        max_lyaps_filtered(max_lyaps_filtered < 0) = NaN;
        
        m_filtered = zeros(1, npars); % Mean
        s_filtered = zeros(1, npars); % SD
        prob_filtered = zeros(1, npars); % Probability of chaos
        for i = 1:npars
            m_filtered(i) = mean(max_lyaps_filtered(:, i));
            s_filtered(i) = std(max_lyaps_filtered(:, i));
            prob_filtered(i) = sum(max_lyaps_filtered(:, i) > 0)/nreps;
        end
        
        %% Plot filtered maximum Lyapunov exponent
        hold on;
        for j = 1:nreps
            PlotMaxLyaps(competition_pars, max_lyaps_filtered(j,:));
        end
        
        % Add some aesthetics
        plot(competition_pars, m_filtered, 'color', 'k'); % Plot mean
        plot(competition_pars, m_filtered + s_filtered, '--', 'color', 'k'); % Plot +- sd
        plot(competition_pars, m_filtered - s_filtered, '--', 'color', 'k'); % Plot +- sd
        plot([competition_pars(1), competition_pars(end)], [0 0], '-', 'color', 'k'); % Plot line at y = 0
        text = sprintf('Chaos strength \n Case: %s', resultsArray{1,1}.id);
        title(text);
        xlabel('Competition parameter'); ylabel('Chaos strength'); % Add axis labels
        
    case 'probabilities'
        competition_pars = resultsAsMatrix(resultsArray, 'competition_par');
        [probChaos_using_Lyaps, probChaos_using_z1, probChaos_using_z1_2, ~, ~] = computeProbabilities(resultsArray);
        
        plot(competition_pars, probChaos_using_Lyaps);
        hold on;
        plot(competition_pars, probChaos_using_z1);
        plot(competition_pars, probChaos_using_z1_2);
        plot([0 0], [0 1], '--', 'color', 'k');
        text = sprintf('Probability of chaos \n Case: %s', resultsArray{1,1}.id);
        title(text);
        xlabel('Competition parameter');
        ylabel('Probability');
        legend('Lyapunov', 'z1', 'z1 soft');
        
    case 'z1'
        competition_pars = resultsAsMatrix(resultsArray, 'competition_par');
        [~, ~, probChaos_using_z1_2, ~, ~] = computeProbabilities(resultsArray);
        
        %area(competition_pars, probChaos_using_z1_2, 'FaceColor', [254 127 127]./255);
        area(competition_pars, probChaos_using_z1_2);
        xlim([-.8,.8]);
        ylim([0,1]);
        text = sprintf('Probability of chaos \n Case: %s', resultsArray{1,1}.id);
        title(text);
        xlabel('Competition parameter \epsilon');
        ylabel('Probability of chaos');
        
    case 'comparer'
        competition_pars = resultsAsMatrix(resultsArray, 'competition_par');
        [~, ~, ~, ~, binaryComparer] = computeProbabilities(resultsArrayLocation);
        
        binaryResult = NaN(1,4);
        for i = 0:3
            binaryResult(i + 1) = sum(binaryComparer(:) == i)./N;
        end
        match = binaryResult(1) + binaryResult(4);
        
        pcolor(competition_pars, 1:nreps, binaryComparer);
        text = sprintf('Case: %s Match: %f. \n Lyap false and z1 false: %f Lyap false and z1 true: %f \n Lyap true and z1 false: %f Lyap true and z1 true: %f', resultsArray{1,1}.id, match, binaryResult(1), binaryResult(2), binaryResult(3), binaryResult(4));
        title(text);
        % axis equal;
        xlabel('Competition parameter');
        ylabel('Repetition');
        colorbar;
        
    case 'summary'        
        competition_pars = resultsAsMatrix(resultsArray, 'competition_par');
        [~, ~, ~, summary, ~] = computeProbabilities(resultsArrayLocation);
        
        area(competition_pars, summary, 'FaceColor', [254 127 127]./255);
        ylim([0,1]);
        text = sprintf('Case: %s', resultsArray{1,1}.id);
        title(text);
        % axis equal;
        xlabel('Competition parameter');
        ylabel('Certainty of chaos');
        
    case 'z12'
        competition_pars = resultsAsMatrix(resultsArray, 'competition_par');
        [~, ~, usingz12, ~, ~] = computeProbabilities(resultsArrayLocation);
        
        area(competition_pars, usingz12, 'FaceColor', [254 127 127]./255);
        ylim([0,1]);
        text = sprintf('Case: %s', resultsArray{1,1}.id);
        title(text);
        % axis equal;
        xlabel('Competition parameter');
        ylabel('Certainty of chaos');
        xlim([-1 1]);
        
    case 'speciesCount'
        competition_pars = resultsAsMatrix(resultsArray, 'competition_par');
        count = resultsAsMatrix(resultsArray, 'speciesCount');
        
        cnt_tot = count(:, :, 1);
        cnt_prey = count(:, :, 2);
        cnt_pred = count(:, :, 3);
        cnt_prey_c = count(:, :, 4);
        
        dimensions = resultsArray{1,1}.dims;
        nPred = dimensions(1);
        nPrey = dimensions(2);
        
        subplot(3, 1, 1);
        plot(competition_pars, cnt_tot);
        hold on;
        plot(competition_pars, mean(cnt_tot), 'LineWidth', 4, 'Color', 'k');
        plot(competition_pars, mean(cnt_tot) + [1;-1].*std(cnt_tot), 'LineWidth', 5, 'Color', 'k', 'LineStyle', '--');
        ylim([0, nPred+nPrey]);
        title('Total');
        
        subplot(3, 1, 2);
        plot(competition_pars, cnt_prey);
        hold on;
        plot(competition_pars, mean(cnt_prey_c), 'LineWidth', 4, 'Color', 'g');
        plot(competition_pars, mean(cnt_prey_c) + [1;-1].*std(cnt_prey_c), 'LineWidth', 4, 'Color', 'g', 'LineStyle', '--');
        plot(competition_pars, mean(cnt_prey), 'LineWidth', 4, 'Color', 'k');
        plot(competition_pars, mean(cnt_prey) + [1;-1].*std(cnt_prey), 'LineWidth', 4, 'Color', 'k', 'LineStyle', '--');
        difference = cnt_prey_c - cnt_prey;
        plot(competition_pars, mean(difference), 'LineWidth', 4, 'Color', 'b');
        plot(competition_pars, mean(difference) + [1;-1].*std(difference), 'LineWidth', 4, 'Color', 'b', 'LineStyle', '--');
        
        %         ylim([0, nPrey]);
        title('Prey');
        ylabel('Average number of non extinct species');
        
        subplot(3, 1, 3);
        plot(competition_pars, cnt_pred);
        hold on;
        plot(competition_pars, mean(cnt_pred), 'LineWidth', 4, 'Color', 'k');
        plot(competition_pars, mean(cnt_pred) + [1;-1].*std(cnt_pred), 'LineWidth', 5, 'Color', 'k', 'LineStyle', '--');
        ylim([0, nPred]);
        title('Pred');
        xlabel('Competition parameter');
        
    case 'evenness'
        competition_pars = resultsAsMatrix(resultsArray, 'competition_par');
        evenness = resultsAsMatrix(resultsArray, 'evenness');
        
        evs = evenness(:, :, 1);
        evs_prey = evenness(:, :, 2);
        evs_pred = evenness(:, :, 3);
        evs_prey_c = evenness(:, :, 4);
        
        dimensions = resultsArray{1,1}.dims;
        nPred = dimensions(1);
        nPrey = dimensions(2);
        
        subplot(3, 1, 1);
        plot(competition_pars, evs);
        hold on;
        plot(competition_pars, mean(evs), 'LineWidth', 4, 'Color', 'k');
        plot(competition_pars, mean(evs) + [1;-1].*std(evs), 'LineWidth', 5, 'Color', 'k', 'LineStyle', '--');
        ylim([0 1]);
        title('Total');
        
        subplot(3, 1, 2);
        plot(competition_pars, evs_prey);
        hold on;
        plot(competition_pars, mean(evs_prey_c), 'LineWidth', 4, 'Color', 'g');
        plot(competition_pars, mean(evs_prey_c) + [1;-1].*std(evs_prey_c), 'LineWidth', 4, 'Color', 'g', 'LineStyle', '--');
        plot(competition_pars, mean(evs_prey), 'LineWidth', 4, 'Color', 'k');
        plot(competition_pars, mean(evs_prey) + [1;-1].*std(evs_prey), 'LineWidth', 4, 'Color', 'k', 'LineStyle', '--');
        difference = evs_prey_c - evs_prey;
        plot(competition_pars, mean(difference), 'LineWidth', 4, 'Color', 'b');
        plot(competition_pars, mean(difference) + [1;-1].*std(difference), 'LineWidth', 4, 'Color', 'b', 'LineStyle', '--');
        ylim([0, 1]);
        title('Prey');
        ylabel('Evenness');
        
        subplot(3, 1, 3);
        plot(competition_pars, evs_pred);
        hold on;
        plot(competition_pars, mean(evs_pred), 'LineWidth', 4, 'Color', 'k');
        plot(competition_pars, mean(evs_pred) + [1;-1].*std(evs_pred), 'LineWidth', 5, 'Color', 'k', 'LineStyle', '--');
        ylim([0, 1]);
        title('Pred');
        xlabel('Competition parameter');
        
    case 'preyCount'
        competition_pars = resultsAsMatrix(resultsArray, 'competition_par');
        count = resultsAsMatrix(resultsArray, 'speciesCount');
        
        cnt_prey2 = count(:, :, 5);
        difference = cnt_prey2;
        
        area(competition_pars, mean(difference));
        text = sprintf('Prey count \n Case: %s', resultsArray{1,1}.id);
        title(text);
        xlabel('Competition parameter \epsilon');
        ylabel('Prey count');
        
    case 'preyEven'
        competition_pars = resultsAsMatrix(resultsArray, 'competition_par');
        evs = resultsAsMatrix(resultsArray, 'evenness');
        
        evs_prey = evs(:, :, 2);
        evs_prey_c = evs(:, :, 4);
        
        difference = evs_prey_c - evs_prey;
        
        %area(competition_pars, probChaos_using_z1_2, 'FaceColor', [254 127 127]./255);
        area(competition_pars, mean(difference));
        text = sprintf('Prey evenness \n Case: %s', resultsArray{1,1}.id);
        title(text);
        xlabel('Competition parameter \epsilon');
        ylabel('Prey evenness');
        
    case 'biodchaosvsregular'
        competition_pars = resultsAsMatrix(resultsArray, 'competition_par');
        nprey = resultsArray{1,1}.dims(1);
        resultsTable = resultsAsTable(resultsArray);
        
        biod_chaos = NaN(1, npars);
        biod_regular = NaN(1, npars);
        ratio_chaos = NaN(1, npars);
        for i = 1:npars
            % Filtering process
            subset = resultsTable(resultsTable.competition_par == competition_pars(i), :);
            subset_chaos = subset(subset.z12 == true, :);
            subset_regular = subset(subset.z12 == false, :);
            
            [biod_regular(i), biod_chaos(i), ratio_chaos(i)] = biodByChaos(subset_regular, subset_chaos, [0.05, 0.995]);
        end
        
        scatter(biod_chaos, biod_regular, '.');
        hold on;
        plot([0 nprey], [0 nprey], '--', 'Color', 'k');
        title('Biodiversity');
        xlabel('For chaotic cases');
        ylabel('For non chaotic cases');
        
    case 'evenchaosvsregular'
        competition_pars = resultsAsMatrix(resultsArray, 'competition_par');
        nprey = resultsArray{1,1}.dims(1);
        resultsTable = resultsAsTable(resultsArray);
        
        even_chaos = NaN(1, npars);
        even_regular = NaN(1, npars);
        ratio_chaos = NaN(1, npars);
        for i = 1:npars
            % Filtering process
            subset = resultsTable(resultsTable.competition_par == competition_pars(i), :);
            subset_chaos = subset(subset.z12 == true, :);
            subset_regular = subset(subset.z12 == false, :);
            
            n_chaos = height(subset_chaos);
            n_total = height(subset);
            ratio_chaos(i) = n_chaos/n_total;
            
            even_chaos(i) = mean(subset_chaos.evennessPrey(:, 1)); % Second column contains standard deviations
            even_regular(i) = mean(subset_regular.evennessPrey(:, 1)); % Second column contains standard deviations
        end
        
        c = (ratio_chaos > 0.05) & (ratio_chaos < 0.995);
        scatter(even_chaos, even_regular, 200, c, '.');
        colormap(jet);
        hold on;
        plot([0 1], [0 1], '--', 'Color', 'k');
        title('Evenness');
        xlabel('For chaotic cases');
        ylabel('For non chaotic cases');
        
    case 'biodboxandwhisker'
        resultsTable = resultsAsTable(resultsArray);        
        boxplot(resultsTable.nPreySpeciesAlive2(:,1), resultsTable.dynamics);
        
        xlabel('Dynamics');
        ylabel('Prey biodiversity');
        
    case 'summarymerged'
        nPrey = resultsArray{1,1}.dims(1);
        
        % Probability of chaos
        subplot(1, 4, [1,3]);
        createFigures(resultsArray, 'z12');
        ylabel('Probability of chaos');
        
        % ... add a new axis to the right ...
        yyaxis right;
        ax = gca;
        ax.YColor = 'k';
        
        % ... containing biodiversity information
        createFigures(resultsArray, 'biodsplitbychaos');
        xlim([-0.8, 0.8]);
        ylim([0, nPrey + 1]);
        xlabel('Competition parameter \epsilon');
        ylabel('');
        
        title('A. Effects of the competition parameter');
        legend({'Probability of chaos', 'Biodiversity: regular group', 'Biodiversity: chaotic group', 'Biodiversity: total'});
        
        % Last but not least, box and whisker
        subplot(1, 4, 4);
        createFigures(resultsArray, 'biodboxandwhisker');
        title('B. Effects of chaos on biodiversity');
        ylim([0, nPrey + 1]);
        
    case 'biodvslyap'
        resultsTable = resultsAsTable(resultsArray);
        
        maxLyaps = resultsTable.maxLyapunov;
        biod = resultsTable.nPreySpeciesAlive2(:, 1);
        
        scatter(maxLyaps, biod, '.');
        xlabel('Maximum Lyapunov exponent');
        ylabel('Prey biodiversity');
        
    case 'biodsplitbychaos'
        competition_pars = resultsAsMatrix(resultsArray, 'competition_par');
        nprey = resultsArray{1,1}.dims(1);
        resultsTable = resultsAsTable(resultsArray);
        
        biod_chaos = NaN(1, npars);
        biod_regular = NaN(1, npars);
        ratio_chaos = NaN(1, npars);
        for i = 1:npars
            % Filtering process
            subset = resultsTable(resultsTable.competition_par == competition_pars(i), :);
            subset_chaos = subset(subset.z12 == true, :);
            subset_regular = subset(subset.z12 == false, :);
            
            [biod_regular(i), biod_chaos(i), ratio_chaos(i)] = biodByChaos(subset_regular, subset_chaos, [0.00, 0.99999]);
        end
        ratio_regular = 1 - ratio_chaos; % The ratio of regular cases is the complementary to the chaos cases
        biod_average = ratio_regular.*biod_regular + ratio_chaos.*biod_chaos;
        
        scatter(competition_pars, biod_regular, 100.*ratio_regular, 'k', 'filled');
        hold on;
        scatter(competition_pars, biod_chaos, 100.*ratio_chaos, 'k');
        plot(competition_pars, biod_average, 'Color', 'k', 'LineStyle', '--');
        colormap(jet);

        title('Biodiversity');
        xlabel('Competition parameter');
        ylabel('Biodiversity');
        xlim([-1 1]);
        
        case 'dynamics'
        competition_pars = resultsAsMatrix(resultsArray, 'competition_par');
        resultsTable = resultsAsTable(resultsArray);
        
        ratio_stable = NaN(1, npars);
        ratio_cyclic = NaN(1, npars);
        ratio_chaotic = NaN(1, npars);
        for i = 1:npars
            % Filtering process
            subset = resultsTable(resultsTable.competition_par == competition_pars(i), :);
            n_reps = height(subset);
            
            subset_stable = subset(subset.dynamics == string('stable'), :);
            n_stable = height(subset_stable);
            ratio_stable(i) = n_stable/n_reps;
            
            subset_cyclic = subset(subset.dynamics == string('cyclic'), :);
            n_cyclic = height(subset_cyclic);
            ratio_cyclic(i) = n_cyclic/n_reps;
            
            subset_chaotic = subset(subset.dynamics == string('chaotic'), :);
            n_chaotic = height(subset_chaotic);
            ratio_chaotic(i) = n_chaotic/n_reps;
            
        end
       
        plot(competition_pars, ratio_stable);
        hold on;
        plot(competition_pars, ratio_cyclic);
        plot(competition_pars, ratio_chaotic);
        
        legend({'Group: stable dynamics', 'Group: cyclic dynamics', 'Group: chaotic dynamics'});
        
        title('Ratio of each dynamic regime');
        xlabel('Competition parameter');
        ylabel('Ratio');
        xlim([-0.8 0.8]);
        
    case 'biodsplitbydynamics'
        competition_pars = resultsAsMatrix(resultsArray, 'competition_par');
        nprey = resultsArray{1,1}.dims(1);
        resultsTable = resultsAsTable(resultsArray);
        
        biod = NaN(1, npars);
        biod_stable = NaN(1, npars); ratio_stable = NaN(1, npars);
        biod_cyclic = NaN(1, npars); ratio_cyclic = NaN(1, npars);
        biod_chaotic = NaN(1, npars); ratio_chaotic = NaN(1, npars);
        for i = 1:npars
            % Filtering process
            subset = resultsTable(resultsTable.competition_par == competition_pars(i), :);
            biod(i) = mean(subset.nPreySpeciesAlive2(:, 1));
            n_reps = height(subset);
            
            subset_stable = subset(subset.dynamics == string('stable'), :);
            biod_stable(i) = mean(subset_stable.nPreySpeciesAlive2(:, 1));
            n_stable = height(subset_stable);
            ratio_stable(i) = n_stable/n_reps;
            
            subset_cyclic = subset(subset.dynamics == string('cyclic'), :);
            biod_cyclic(i) = mean(subset_cyclic.nPreySpeciesAlive2(:, 1));
            n_cyclic = height(subset_cyclic);
            ratio_cyclic(i) = n_cyclic/n_reps;
            
            subset_chaotic = subset(subset.dynamics == string('chaotic'), :);
            biod_chaotic(i) = mean(subset_chaotic.nPreySpeciesAlive2(:, 1));
            n_chaotic = height(subset_chaotic);
            ratio_chaotic(i) = n_chaotic/n_reps;
            
        end
        
        scatter(competition_pars, biod_stable, 100.*ratio_stable + 0.01, [0, 0.4470, 0.7410], 'filled');
        hold on;
        scatter(competition_pars, biod_cyclic, 100.*ratio_cyclic  + 0.01, [0.8500, 0.3250, 0.0980], 'filled');
        scatter(competition_pars, biod_chaotic, 100.*ratio_chaotic  + 0.01, [0.9290, 0.6940, 0.1250], 'filled');
        plot(competition_pars, biod, 'Color', 'k', 'LineStyle', '--');
        
        legend({'Group: stable dynamics', 'Group: cyclic dynamics', 'Group: chaotic dynamics', 'Total'});
        
        title('Biodiversity');
        xlabel('Competition parameter');
        ylabel('Biodiversity');
        xlim([-0.8 0.8]);
        
    case 'biodsplitbychaosdiff'
        competition_pars = resultsAsMatrix(resultsArray, 'competition_par');
        nprey = resultsArray{1,1}.dims(1);
        resultsTable = resultsAsTable(resultsArray);
        
        biod_chaos = NaN(1, npars);
        biod_regular = NaN(1, npars);
        ratio_chaos = NaN(1, npars);
        for i = 1:npars
            % Filtering process
            subset = resultsTable(resultsTable.competition_par == competition_pars(i), :);
            subset_chaos = subset(subset.z12 == true, :);
            subset_regular = subset(subset.z12 == false, :);
            
            [biod_regular(i), biod_chaos(i), ratio_chaos(i)] = biodByChaos(subset_regular, subset_chaos, [0.05, 0.995]);
        end
        
        scatter(competition_pars, biod_chaos - biod_regular, 'filled');
        colormap(jet);
        hold on;
        plot([-1 1], [0 0], 'Color', 'k', 'LineStyle', '--');

        title('Biodiversity difference');
        xlabel('Competition parameter');
        ylabel('Biodiversity difference');
        
    case 'evensplitbychaos'
        competition_pars = resultsAsMatrix(resultsArray, 'competition_par');
        nprey = resultsArray{1,1}.dims(1);
        resultsTable = resultsAsTable(resultsArray);
        
        even_chaos = NaN(1, npars);
        even_regular = NaN(1, npars);
        ratio_chaos = NaN(1, npars);
        for i = 1:npars
            % Filtering process
            subset = resultsTable(resultsTable.competition_par == competition_pars(i), :);
            subset_chaos = subset(subset.z12 == true, :);
            subset_regular = subset(subset.z12 == false, :);
            
            n_chaos = height(subset_chaos);
            n_total = height(subset);
            ratio_chaos(i) = n_chaos/n_total;
            
            even_chaos(i) = mean(subset_chaos.evennessPrey(:, 1)); % Second column contains standard deviations
            even_regular(i) = mean(subset_regular.evennessPrey(:, 1)); % Second column contains standard deviations
        end
        
        c = (ratio_chaos > 0.05) & (ratio_chaos < 0.995);
        scatter(competition_pars, even_regular, [], c, 'filled');
        hold on;
        scatter(competition_pars, even_chaos, [], c);
        colormap(jet);

        xlabel('Competition parameter');
        ylabel('Evenness');
        
    otherwise
        error('Wrong type of figure. See help createFigures for valid types');
        
end

end

function [biod_regular, biod_chaos, ratio_chaos] = biodByChaos(subset_regular, subset_chaos, thresholds)

%% Set default threshold
if nargin == 2
    thresholds = [0, 1];
end

%% Count sizes
n_chaos = height(subset_chaos);
n_total = height(subset_regular) + height(subset_chaos);

%% Filter out extremes
temp_ratio = n_chaos/n_total;
if (temp_ratio >= thresholds(1)) && (temp_ratio <= thresholds(2))
    ratio_chaos = temp_ratio;
    biod_chaos = mean(subset_chaos.nPreySpeciesAlive2(:, 1)); % Second column contains standard deviations
    biod_regular = mean(subset_regular.nPreySpeciesAlive2(:, 1)); % Second column contains standard deviations
else
    ratio_chaos = NaN;
    biod_chaos = NaN;
    biod_regular = NaN;
end

end

function [biod_stable, biod_cyclic, biod_chaos] = biodByDynamics(subsetStable, subsetCyclic, subsetChaotic)

%% Measure
biod_stable = mean(subsetStable.nPreySpeciesAlive2(:, 1)); % Second column contains standard deviations
biod_cyclic = mean(subsetCyclic.nPreySpeciesAlive2(:, 1)); % Second column contains standard deviations
biod_chaos = mean(subsetChaotic.nPreySpeciesAlive2(:, 1)); % Second column contains standard deviations

end