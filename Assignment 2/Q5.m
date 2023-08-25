% Generate data
N = 20;
M = 40;
D0 = 7;
w_true = zeros(M, 1);
nonzero_indices = randsample(M, D0);
w_true(nonzero_indices) = randn(D0, 1);
Phi = randn(N, M);
sigma_values = [0.1, 0.1778, 0.3162, 0.5623, 1];

% Calculate NMSE for each noise level
nmse_values = zeros(length(sigma_values), 1);
for i = 1:length(sigma_values)
    sigma2 = sigma_values(i)^2;
    noise = randn(N, 1) * sigma_values(i);
    t = Phi * w_true + noise;
    [w_est, alpha] = SBL(Phi, t, sigma2);
    nmse = calc_NMSE(w_true, w_est, sigma2);
    nmse_values(i) = nmse;
end

% Plot NMSE vs noise variance
figure;
plot(10*log10(sigma_values.^2), nmse_values, 'o-');
xlabel('Noise Variance (dB)');
ylabel('NMSE (dB)');
title('Normalized Mean Squared Error (NMSE) vs Noise Variance');

function nmse = calc_NMSE(w_true, w_est, sigma2)
    nmse = norm(w_est - w_true)^2 / norm(w_true)^2;
    nmse = 10*log10(nmse); % Convert to dB scale
    nmse = nmse + 10*log10(sigma2); % Add noise variance in dB scale
end
