% Q2 
% This is to test how our matrix is developed and see them, we will use them in Q3 and Q4 as well
clc;clearvars;close all; % Clear
N = 100; % number of rows
M = 50; % number of columns

% generate N x M design matrix with entries drawn from N(0,1)
Phi = randn(N, M);

M = 50; % number of columns
D0 = 5; % number of nonzero entries in w

% generate M x 1 weight vector with D0 randomly selected nonzero entries
w = zeros(M, 1);
nonzero_idx = randperm(M, D0); % randomly select D0 indices for nonzero entries randperm(M, D0) generates a random permutation of the integers from 1 to M and selects the first D0 indices
w(nonzero_idx) = randn(D0, 1); % assign Gaussian-distributed nonzero components

N = 100; % number of samples
sigma = 0.1; % standard deviation of noise

% generate noise vector e with N samples drawn from N(0, sigma^2)
e = sigma * randn(N, 1);

% compute observations t = Phi * w + e
t = Phi * w + e;