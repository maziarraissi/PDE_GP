clear all
clc
close all

addpath ../Utilities

rng('default')

global ModelInfo

%% Setup
dim = 10;
Ntr = 60;
Nu = 40;
lb = zeros(1,dim);
ub = ones(1,dim);
jitter = eps;
ModelInfo.jitter = jitter;

%% Optimize model

% Training data for RHS

ModelInfo.xf = bsxfun(@plus,lb,bsxfun(@times,   lhsdesign(Ntr,dim)    ,(ub-lb)));
ModelInfo.xu = bsxfun(@plus,lb,bsxfun(@times,   lhsdesign(Nu,dim)    ,(ub-lb)));

ModelInfo.yf = f(ModelInfo.xf);
ModelInfo.yf = ModelInfo.yf + 0.05*randn(size(ModelInfo.yf));

ModelInfo.yu = u(ModelInfo.xu);
ModelInfo.yu = ModelInfo.yu + 0.01*randn(size(ModelInfo.yu));

ModelInfo.hyp = log([1 1*ones(1,dim) 10^-6 10^-6]);
tic
[ModelInfo.hyp,~,~] = minimize(ModelInfo.hyp, @likelihood, -200);
toc


%% Make Predictions & Plot results
save_plots = 0;
time_dep = 0;
PlotResults