%% Pre-processing
clearvars
clc
close all

addpath ../../../Utilities
addpath ../../../Utilities/backward

global ModelInfo

%% Setup
nu = 1;
nf = 7;
D = 1;
lb = zeros(1,D);
ub = ones(1,D);
ModelInfo.jitter = eps;
noise_u = 0.00;
noise_f = 0.06;

%% Generate Data
rng('default')

% Data on u(x)
ModelInfo.xu = bsxfun(@plus,lb,bsxfun(@times,   lhsdesign(nu,D)    ,(ub-lb)));
ModelInfo.yu = u(ModelInfo.xu).*(1 + noise_u*(-1+2*rand(nu,1)));

% Data on f(x)
ModelInfo.xf = bsxfun(@plus,lb,bsxfun(@times,   lhsdesign(nf,D)    ,(ub-lb)));
ModelInfo.yf = f(ModelInfo.xf).*(1 + noise_f*(-1+2*rand(nf,1)));

%% Training
% hyp = [logsigma logtheta logsigma_nu logsigma_nf]
hyp = log([1 1 10^-3 10^-3]);

[ModelInfo.hyp,~,~] = minimize(hyp, @likelihood, -2000);

%% Make Predictions & Plot results
save_plots = 1;
PlotResults

%% Post-procesing
rmpath ../../../Utilities
rmpath ../../../Utilities/backward
