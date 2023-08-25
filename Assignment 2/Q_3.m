% Q3
% We will plot norm of t for each vaue of noise given to us
clc;clearvars;close all; % Clear
N = 20; % number of samples
M = 40; % number of columns in design matrix
D0 = 7; % number of nonzero entries in weight vector
sigma_db = [-20, -15, -10, -5, 0]; % noise variance in dB
sigma = 10.^(sigma_db/20); % noise standard deviation

% generate design matrix Phi
Phi = randn(N, M);

% generate sparse weight vector w
w = zeros(M, 1);
nonzero_idx = randperm(M, D0);
w(nonzero_idx) = randn(D0, 1);

% generate noisy observations t for each noise variance
t_all = zeros(N, length(sigma_db)); % this contains value of t for all sigma or variance given to us
for i = 1:length(sigma_db)
    e = sigma(i) * randn(N, 1); % generate noise vector
    t = Phi * w + e; % compute observations
    t_all(:,i) = t; % Stores value of t for every alpha in corresponding position
    fprintf('Noise variance: %d dB, ||t||_2 = %.4f\n', sigma_db(i), norm(t)); % print L2-norm of t
    % plot results
    subplot(length(sigma), 1, i);
    plot(t);
    title(sprintf('Noise variance: %.2f dB', 20*log10(sigma(i))));
    xlabel('Data point index');
    ylabel('Observation value');
end
