% Set parameter values
w0 = 1;
w1 = -2;
w2 = 0.5;

% Set random seed for reproducibility
rng(42);

% Generate N = 200 values of x uniformly distributed between -5 and 5
N = 200;
x = linspace(-5, 5, N)';

% Generate random noise from N(0,1) distribution
n = randn(N, 1);

% Calculate t for each x value using the given model
t = w0 + w1*x + w2*x.^2 + n;
 %% Plot the data
figure(1);
hold off
plot(x,t,'k.','markersize',10);
xlabel('x');
ylabel('t');
title('Data');

% Fit linear model using least squares approach
X_linear = [ones(N, 1), x];
w_linear = (X_linear' * X_linear) \ (X_linear' * t);

% Fit quadratic model using least squares approach
X_quadratic = [ones(N, 1), x, x.^2];
w_quadratic = (X_quadratic' * X_quadratic) \ (X_quadratic' * t);


% Plot linear model
figure;
scatter(x, t);
hold on;
x_range = linspace(-5, 5, 100)';
X_linear_range = [ones(100, 1), x_range];
t_linear_range = X_linear_range * w_linear;
plot(x_range, t_linear_range, 'r');
xlabel('x');
ylabel('t');
title('Linear Model');

% Plot quadratic model
figure;
scatter(x, t);
hold on;
X_quadratic_range = [ones(100, 1), x_range, x_range.^2];
t_quadratic_range = X_quadratic_range * w_quadratic;
plot(x_range, t_quadratic_range, 'r');
xlabel('x');
ylabel('t');
title('Quadratic Model');
