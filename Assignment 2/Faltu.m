% Clear workspace and generate design matrix
clc;
clearvars;
close all;

N = 20;
M = 40;
Phi = randn(N, M);

% Generate sparse weight vector
D0 = 7;
w = zeros(M, 1);
w(randperm(M, D0)) = randn(D0, 1);

% Define noise variances to test
variances_dB = [-20, -15, -10, -5, 0];
variances = 10.^(variances_dB ./ 10);

% Number of iterations for Monte Carlo averaging
num_iterations = 50000;

% Preallocate arrays for results
num_variances = length(variances);
nmse = zeros(1, num_variances);
w_mp = zeros(M, num_iterations, num_variances);
nmse_per_variance = zeros(num_iterations, num_variances);
t_all = zeros(N, num_variances);

for i = 1:num_variances
    % Choose a particular variance
    variance = variances(i);
    
    for j = 1:num_iterations
        % Assume all hyperparameters alpha equal to 100 initially
        alpha = 100;
        alpha_matrix = alpha * eye(M);
        
        % Generate noise
        noise = sqrt(variance) * randn(N, 1);
        
        % Generate target values
        targets = Phi * w + noise;
        t_all(:,i) = targets;
        
        % Calculate posterior mean and covariance
        posterior_covariance = inv((Phi' * Phi / variance) + alpha_matrix);
        posterior_mean = (posterior_covariance * Phi' * targets) / variance;
        
        % Iterate until convergence
        convergence_threshold = 1e-3;
        while true
            gamma = (1 - (diag(alpha_matrix) .* diag(posterior_covariance)))';
            alpha = gamma' ./ (posterior_mean.^2);
            alpha_matrix = diag(alpha);
            posterior_covariance = inv((Phi' * Phi / variance) + alpha_matrix);
            posterior_mean_new = (posterior_covariance * Phi' * targets) / variance;
            
            if norm(posterior_mean_new - posterior_mean)^2 <= convergence_threshold * (norm(posterior_mean)^2) || det(posterior_covariance) < 1e-50
                w_mp(:, j, i) = posterior_mean_new;
                break;
            end
            posterior_mean = posterior_mean_new;
        end
        
        nmse_per_variance(j, i) = norm(w_mp(:, j, i) - w)^2 / norm(w)^2;
    end
    
    % Do Monte Carlo averaging to get better NMSE values
    nmse(i) = mean(nmse_per_variance(:, i));
end

%% Q5
% In this we need to plot the obtained values
% Create a new figure and plot the data
figure('Units','normalized','Position',[0 0 1 1]) % Set figure size to be edge-to-edge
plot(variances, nmse, '-o', 'Color', '#0072BD', 'LineWidth', 2, 'MarkerSize', 8);

% Add labels and title
title('NMSE vs. Variances', 'FontSize', 20, 'FontWeight', 'bold');
xlabel('Variance', 'FontSize', 18, 'FontWeight', 'bold');
ylabel('NMSE', 'FontSize', 18, 'FontWeight', 'bold');

% Adjust axis limits and tick marks
xlim([min(variances)-0.05, max(variances)+0.05])
xticks(min(variances)-0.05:0.05:max(variances)+0.05)
ylim([min(nmse)-0.05, max(nmse)+0.05])
yticks(min(nmse)-0.05:0.05:max(nmse)+0.05)

% Customize grid lines and tick labels
grid on
grid minor
set(gca, 'FontSize', 14, 'FontWeight', 'bold', 'GridColor', '#CCCCCC')

nmse 
variances