function visualResults = visualInspection(results)
%VISUALINSPECTION Shows time series and results of the tests one by one
%   Left mouse button shows next plot
%   Right mouse button for finishing

rows = size(results, 1);
cols = size(results, 2);
N = rows.*cols;

visualResults = NaN(rows, cols);

switch nargout
    case 0
        button = 1; % 1 represents left mouse button. 49 represents 1, 48 represents 0
        counter = 1;
        for i = 1:rows
            for j = 1:cols
                if (button == 1) % Left button for continuing
                    fprintf('Case %i of %i \n', counter, N);
                    displayCase(results, i, j);
                    [~, ~, button] = ginput(1); % Input only one click. Ignore position.
                    counter = counter + 1;
                else % Terminate if another button is pressed
                    close all;
                    return;
                end
            end
        end
    case 1
        button = 49; % 49 represents key 1
        counter = 1;
        for i = 1:rows
            for j = 1:cols
                if (button == 48) || (button == 49) % Left button for continuing
                    displayCase(results, i, j);
                    [~, ~, button] = ginput(1); % Input only one click. Ignore position.
                    if button == 49 % Key 1
                        visualResults(i,j) = 1;
                    elseif button == 48 % Key 0
                        visualResults(i,j) = 0;
                    end
                    counter = counter + 1;
                else % Terminate if another button is pressed
                    close all;
                    return;
                end
            end
        end
    otherwise
        error('Wrong nargout');
end