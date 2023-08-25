clc;clear all;close all;
% Generate design matrix
N = 20; M = 40;
Phi = randn(N, M);

% Generate sparse weight vector
D0 = 7;
w = zeros(M, 1);
w(randperm(M, D0)) = randn(D0, 1);

% Generate observations with different noise variances
noise_variances = [10^(-20/10), 10^(-15/10), 10^(-10/10), 10^(-5/10), 1];
t_all = zeros(N, length(noise_variances));
for i = 1:length(noise_variances)
    noise = sqrt(noise_variances(i))*randn(N, 1);
    t_all(:,i) = Phi*w + noise;
end

% Apply SBL algorithm to get MAP estimate of weight vector
alpha = 1e-6;
beta = 1e-6;
w_MAP_all = zeros(M, length(noise_variances));
for i = 1:length(noise_variances)
    t = t_all(:,i);
    [U, S, V] = svd(Phi);
    lambdas = diag(S).^2;
    A = alpha*eye(M) + beta*(Phi'*Phi);
    m = beta*inv(A)*Phi'*t;
    post_var = inv(A);
    options = optimoptions('fminunc', 'Display', 'off', 'Algorithm', 'quasi-newton');
    w_MAP_all(:,i) = fminunc(@(w) neg_log_posterior(w, Phi, t, alpha, beta, lambdas), m, options); % or = m
end

function [neg_log_post] = neg_log_posterior(w, Phi, t, alpha, beta, lambdas)
    neg_log_post = (length(t)/2)*log(beta) + (length(w)/2)*log(alpha) - (beta/2)*norm(t - Phi*w)^2 - (alpha/2)*norm(w)^2 + sum(log(alpha/beta + lambdas/ beta)/2);
end
