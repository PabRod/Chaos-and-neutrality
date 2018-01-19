function createFigures(resultsArrayLocation, prompt)
%CREATEFIGURES Summary of this function goes here
%   Detailed explanation goes here

%% Load results
resultsArray = loadResults(resultsArrayLocation);

%% Measure the input
[nreps, npars] = size(resultsArray);
N = nreps.*npars;

switch prompt
    
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
end