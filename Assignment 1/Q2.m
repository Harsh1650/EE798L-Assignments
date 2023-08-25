% Set parameter values
n = sqrt(3) * randn(6, 1);
x = linspace(0, 1, 6)';
t = 2*x - 3 + n;

% Plot the generated data
figure;
scatter(x, t, 'filled');
xlabel('x');
ylabel('t');
title('Generated Data');

% Define the regularization parameter values
lambda = [0, 1e-6, 0.01, 0.1];

% Define the design matrix
X = [ones(size(x)), x, x.^2, x.^3, x.^4, x.^5];

% Compute the regularized least squares solution for each lambda value
theta = zeros(size(X, 2), length(lambda));
for i = 1:length(lambda)
    theta(:, i) = (X'*X + lambda(i)*eye(size(X, 2))) \ (X'*t);
end

% Evaluate the fitted polynomial at a dense set of x values
x_dense = linspace(0, 1, 100)';
X_dense = [ones(size(x_dense)), x_dense, x_dense.^2, x_dense.^3, x_dense.^4, x_dense.^5];
t_fit = X_dense * theta;

% Plot the data and the fitted polynomials for different lambda values
figure;
scatter(x, t, 'filled');
hold on;
plot(x_dense, t_fit(:, 1), 'b-', 'LineWidth', 1);
plot(x_dense, t_fit(:, 2), 'g-', 'LineWidth', 1);
plot(x_dense, t_fit(:, 3), 'r-', 'LineWidth', 1);
plot(x_dense, t_fit(:, 4), 'm-', 'LineWidth', 1);
xlabel('x');
ylabel('t');
title('Regularized Least Squares Fit with Different Lambda Values');
legend('Data', 'Lambda = 0', 'Lambda = 10^{-6}', 'Lambda = 0.01', 'Lambda = 0.1', 'Location', 'SouthEast');

