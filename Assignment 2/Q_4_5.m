%% Q4, this also contains answer to Q5 as well
% --- STARTING OF GENERATIVE AND ITERATIVE CODE ---
%% Starting and generating the values
clc;
clearvars;
close all;

% Generate design matrix
N = 20;
M = 40;
Phi = randn(N, M);

% Generate sparse weight vector
D0 = 7;
w = zeros(M, 1);
w(randperm(M, D0)) = randn(D0, 1);

% Test Variances given to us.
variances_dB = [-20, -15, -10, -5, 0];
variances = 10.^(variances_dB./10);

% Preallocate arrays for results
nmse = zeros(1, length(variances));
w_mp = zeros(M, length(variances));
nmse_particular_variance = zeros(1, length(variances));
t_all = zeros(N, length(variances)); % this contains value of t for all sigma or variance given to us

% Number of iterations for Monte Carlo
Iterations = 50000;

% Loop for each value of variances and storing their NMSE
for i = 1:length(variances)
    % Choose a particular variance
    var = variances(i);
    Beta = 1/var; % We can iterate and change value of beta but that is another case
    % Iterate through the total number of iteration provided by us
    for j = 1:Iterations
        % Assume all hyperparameters Alpha equal to 100 initially as told to us in calls
        Alpha = 100;
        A = Alpha * eye(M); % Fit it into an Identity matrix
        % Generate noise
        noise = sqrt(var) * randn(N, 1);
        % Generate target values
        t = Phi * w + noise;
        t_all(:,i) = t; % Stores value of t for every Alpha in corresponding position
        % Calculate posterior mean and covariance
        SIGMA = inv((Phi'*Phi*Beta)+A); % SIGMA is posterior covariance
        posterior_mean = (SIGMA*Phi'*t)*Beta; % Using equation 12 and 13
        
        % Iterate until convergence
        eps = 1e-3; % This is given condition for convergance
        while true
            Gamma = (1-(diag(A).*diag(SIGMA)))'; % This stored the gamma value that is gamma_i = 1 - Alpha_i*Sigma_ii
            Alpha = Gamma'./(posterior_mean.^2); % Calculation of updated hyperparameter
            A = diag(Alpha); % Contains hyperparameters
            SIGMA = inv((Phi'*Phi*Beta)+A); % Updated prosterior covariance
            posterior_mean_new = (SIGMA*Phi'*t)*Beta; % Iterated prosterior mean
            if norm(posterior_mean_new - posterior_mean)^2 <= eps*(norm(posterior_mean)^2) || det(SIGMA) < 1e-50
                w_mp(:, j) = posterior_mean_new; % When the condition is satisfied we can exit the loop and store mean as W_map
                break;
            end
            posterior_mean = posterior_mean_new; % Updating value for next loop
        end
        nmse_particular_variance(j) = norm(w_mp(:, j) - w)^2 / norm(w)^2;
    end
    % Do Monte Carlo averaging to get better NMSE values
    nmse(i) = mean(nmse_particular_variance); % we use mean for convinence and Monte Carlo
end

% --- END OF GENERATIVE AND ITERATIVE CODE ---

%% Q5
% --- STARTING OF PLOT CODE ---

% In this we need to plot the obtained values
% Create a new figure and plot the data

% Define the figure size and position
fig = figure('Units', 'normalized', 'Position', [0 0 1 1]);

% Plot the NMSE vs. variance data with markers and custom line colors
plot(variances, nmse, '-o', 'Color', '#0072BD', 'LineWidth', 2, 'MarkerSize', 8);

% Add a title and axis labels with custom font styles
title('NMSE vs. Variances', 'FontSize', 20, 'FontWeight', 'bold');
xlabel('Variance', 'FontSize', 18, 'FontWeight', 'bold');
ylabel('NMSE', 'FontSize', 18, 'FontWeight', 'bold');

% Adjust the axis limits and tick marks for better readability
xlim([min(variances) - 0.005, max(variances) + 0.005]);
xticks(min(variances) - 0.005 : 0.05 : max(variances) + 0.005);
ylim([min(nmse) - 0.005, max(nmse) + 0.005]);
yticks(min(nmse) - 0.005 : 0.05 : max(nmse) + 0.005);

% Customize the grid lines and tick labels with custom font styles
grid on;
grid minor;
set(gca, 'FontSize', 14, 'FontWeight', 'bold', 'GridColor', '#CCCCCC');

% Display the data values for variances and NMSEs
variances
nmse

% We can get different kinds of plot because of 
% The graph obtained does not have to be monotonically increasing. In fact, 
% it is expected to have a U-shape, with the NMSE initially decreasing as the
%  variance increases until it reaches a minimum, and then increasing as the 
% variance continues to increase. This is because a lower variance corresponds
%  to a higher signal-to-noise ratio, which improves the accuracy of the estimates,
%  while a higher variance introduces more noise into the system, leading to lower accuracy.
%  However, if the variance becomes too large, the data becomes dominated by noise,
%  making it difficult to estimate the true underlying model, and resulting in higher NMSE.
% --- END OF PLOT CODE ---
