clear;close all;
%% Sample data from the true function
% t = 5x^3-x^2+x
N = 100; % Number of training points
x = sort(10*rand(N,1)-5);
t = 5*x.^3 - x.^2 + x;
noise_var = 300;
t = t + randn(size(x)).*sqrt(noise_var);

% Chop out some x data
pos = find(x>0 & x<2);
x(pos) = [];
t(pos) = [];

testx = (-5:0.1:5)';

%% Plot the data
figure(1);
hold off
plot(x,t,'k.','markersize',10);
xlabel('x');
ylabel('t');

%% Fit models of various orders
orders = [1, 3, 6]; % Linear, cubic, and sixth-order models
colors = {'r', 'g', 'b'}; % Colors for error bars
for i = 1:length(orders)
    %%
    X = [];
    testX = [];
    for k = 0:orders(i)
        X = [X x.^k];
        testX = [testX testx.^k];
    end
    w = inv(X'*X)*X'*t;
    ss = (1/N)*(t'*t - t'*X*w);
    testmean = testX*w;
    testvar = ss * diag(testX*inv(X'*X)*testX');
    % Plot the data and predictions
    figure(1);
    hold on
    errorbar(testx, testmean, sqrt(testvar), colors{i})
    ti = sprintf('Order %g',orders(i));
    title(ti);
end

