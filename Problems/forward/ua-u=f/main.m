%% Pre-processing
clearvars
clc
close all

addpath ../../../Utilities
addpath ../../../Utilities/forward

global ModelInfo
ModelInfo.alpha = 0.8;

%% Setup
nu = 10;
D = 1;
lb = zeros(1,D);
ub = ones(1,D);
ModelInfo.jitter = eps;
noise_u = 0.06;

%% Generate Data
rng('default')

% Data on u(x)
ModelInfo.xu = bsxfun(@plus,lb,bsxfun(@times,   lhsdesign(nu,D)    ,(ub-lb)));
ModelInfo.yu = u(ModelInfo.xu).*(1 + noise_u*(-1+2*rand(nu,1)));

%% Training
% hyp = [logsigma logtheta logsigma_nu]
hyp = log([1 1 10^-3]);
[ModelInfo.hyp,~,~] = minimize(hyp, @likelihood, -2000);

%% Make Predictions & Plot results
save_plots = 1;
PlotResults

%% Post-processing
rmpath ../../../Utilities
rmpath ../../../Utilities/forward