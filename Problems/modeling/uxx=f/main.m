%% Pre-processing
clear all
clc
close all

addpath ../../../Utilities
addpath ../../../Utilities/modeling

global ModelInfo

%% Setup
n_f = 30;
n_u = 30;
D = 4;
lb = zeros(1,D);
ub = ones(1,D);
ModelInfo.jitter = eps;
noise_u = 0.00;
noise_f = 0.00;

%% Generate Data
rng(1111)
% Data on u(x)
ModelInfo.x_u = bsxfun(@plus,lb,bsxfun(@times,   lhsdesign(n_u,D)    ,(ub-lb)));
ModelInfo.y_u = u(ModelInfo.x_u) + noise_u*randn(n_u,1);

rng(2222)
% Data on f(x)
ModelInfo.x_f = bsxfun(@plus,lb,bsxfun(@times,   lhsdesign(n_f,D)    ,(ub-lb)));
ModelInfo.y_f = f(ModelInfo.x_f) + noise_f*randn(n_f,1);

%% Optimize model
% hyp = [logsigma (logtheta_1 ... logtheta_D) (alpha_1 ... alpha_D) logsigma_n_u logsigma_n_f]
hyp = log([1 ones(1,D) exp(1.5) 10^-3 10^-3]);
[ModelInfo.hyp,~,~] = minimize(hyp, @likelihood, -5000);

fprintf(1,'alpha = %f\n\n', ModelInfo.hyp(D+2:end-2));

%% Make Predictions & Plot results
save_plots = 0;
time_dep = 0;
PlotResults

%% Post-processing
rmpath ../../../Utilities
rmpath ../../../Utilities/modeling