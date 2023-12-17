clear;
addpath(genpath('./'));
rand('state', 16);

r = 0;
gamma = 1;
q = r/gamma + 0.5;
epsilon = 0.1; % standard deviation
n = 2e3;

X_train = rand(n, 1);
y_noise = spline_function(0, X_train, q)' + randn(n, 1) * epsilon;

X = X_train;
y = y_noise;

save(['./data/simulated_', num2str(r), '_', num2str(gamma), '.mat'], 'X', 'y')