M = 3;  % degree of polynomial basis function
Phi = zeros(size(X,1), M+1);
for i = 0:M
    Phi(:,i+1) = X.^i;
end

alpha = 1e-6;  % initial value of hyperparameter alpha
N = size(X,1);  % number of data points
M = size(Phi,2);  % number of basis functions
w_prior_mean = zeros(M,1);  % zero-mean Gaussian prior
w_prior_cov = eye(M)/alpha;  % diagonal covariance matrix

function [w_mean, w_cov] = compute_posterior(alpha, beta, Phi, t)
    w_cov = inv(alpha*eye(size(Phi,2)) + beta*(Phi'*Phi));
    w_mean = beta*w_cov*Phi'*t;
end

function [alpha, beta] = estimate_hyperparameters(X, t)
    alpha = 1e-6;  % initial value of hyperparameter alpha
    beta = 1;  % initial value of hyperparameter beta
    prev_log_marginal_likelihood = -inf;
    converged = false;
    while ~converged
        % Compute the posterior distribution
        [w_mean, w_cov] = compute_posterior(alpha, beta, Phi, t);
        
        % Update the hyperparameters
        gamma = sum(diag(w_cov));
        alpha = gamma / sum(w_mean.^2);
        beta = (N - gamma) / norm(t - Phi*w_mean)^2;
        
        % Compute the marginal likelihood
        log_marginal_likelihood = 0.5*N*log(beta) - 0.5*beta*norm(t - Phi*w_mean)^2 ...
            - 0.5*sum(log(alpha*ones(M,1) + gamma/M));
        
        % Check for convergence
        if abs(log_marginal_likelihood - prev_log_marginal_likelihood) < 1e-6
            converged = true;
        else
            prev_log_marginal_likelihood = log_marginal_likelihood;
        end
    end
end
