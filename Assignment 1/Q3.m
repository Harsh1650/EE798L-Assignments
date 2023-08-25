% This will produce required values on RHS
clear;close all;
load olympics;
% Extract men's 100m data
x = male100(:,1);
t = male100(:,2);
% Choose number of folds
K = 5;
% Randomise the data order
N = size(x,1);
order = randperm(N);
sizes = repmat(floor(N/K),1,K);
sizes(end) = sizes(end) + N-sum(sizes);
sizes = [0 cumsum(sizes)];
% Rescale x
x = x - x(1);
x = x./4;

X = [ones(size(x)) x];
% Comment out the following line for linear
X = [X x.^2 x.^3 x.^4];

% Scan a wide range of values of the regularisation perameter
regvals = 10.^(-12:1:12);

for r = 1:length(regvals)
    for k = 1:K
        % Extract the train and test data
        traindata = X(order,:);
        traint = t(order);
        testdata = X(order(sizes(k)+1:sizes(k+1)),:);
        testt = t(order(sizes(k)+1:sizes(k+1)));
        traindata(sizes(k)+1:sizes(k+1),:) = [];
        traint(sizes(k)+1:sizes(k+1)) = [];
        % Fit the model
        w = inv(traindata'*traindata + regvals(r)*eye(size(X,2)))*...
        traindata'*traint;
        % Compute loss on test data
        predictions = testdata*w;
        loss(r,k) = sum((predictions - testt).^2);
    end
end