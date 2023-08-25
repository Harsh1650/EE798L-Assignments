%% Start of code
clear;close all; clc;
%% Question 3
%% Generate synthetic data set
% This is repeated from Q1 only with data given in question set
N = 500;
mu1 = [3; 3];
Sigma1 = [1 0; 0 2];
mu2 = [1; -3];
Sigma2 = [2 0; 0 1];
pi1 = 0.8;
pi2 = 0.2;
data = zeros(N,2); % This is our data set to store generated points
for i = 1:N
    if rand < pi1
        data(i,:) = mvnrnd(mu1,Sigma1); % Sampling from data 1
    else
        data(i,:) = mvnrnd(mu2,Sigma2); % Sampling from data 2
    end
end

%% This is copied from question 2
% Initialize model parameters based on EM model and forulas given
K = 2; % Given in question 2 and 3
pi_k = ones(1,K) / K;
mu_k = randn(K,2);
Sigma_k = repmat(eye(2),1,1,K);

% Initialize assignment probabilities as per given in question instructions
qnk = rand(N,K); % Store qnk
qnk = qnk ./ sum(qnk,2); % To normalise the valuse of Q so we will have sum = 1

% EM algorithm
tolerance = 1e-6; % Generic to take in iterative methods
logLikelihood = -inf; % For easy updatation in first loop
while(1) % Go on till we satisfy our conditions
    % E-step: update assignment probabilities, same from Q2
    for k = 1:K
        qnk(:,k) = pi_k(k) * mvnpdf(data, mu_k(k,:), Sigma_k(:,:,k));
    end
    qnk = qnk ./ sum(qnk,2);
    
    % M-step: update model parameters
    Nk = sum(qnk);
    for k = 1:K
        pi_k(k) = Nk(k) / N;
        mu_k(k,:) = sum(qnk(:,k) .* data) / Nk(k);
        Sigma_k(:,:,k) = (data - mu_k(k,:))' * (qnk(:,k) .* (data - mu_k(k,:))) / Nk(k);
    end

    % Check for convergence as per given conditions, if true exit or keep going
    newLogLikelihood = sum(log(sum(qnk .* pi_k)));
    if abs(newLogLikelihood - logLikelihood) < tolerance % Condition
        break;
    end
    logLikelihood = newLogLikelihood; % Update value every loop
end

% Assign data points to clusters
[~, clusterAssignment] = max(qnk,[],2); % This will give the cluster data point vaule shown in workspace
Sigma_k(:,:,1)
Sigma_k(:,:,2)
%% We can check rest values in workspace
%% End of code