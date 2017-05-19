clear all
clc
close all

addpath ../Utilities

rng('default')

global ModelInfo

%% Setup
Ntr = 9;
dim = 2;
Nbc = [3,3];
lb = zeros(1,dim);
ub = ones(1,dim);
jitter = eps;
ModelInfo.jitter = jitter;

%% Optimize model

% Training data for RHS
ModelInfo.xf = bsxfun(@plus,lb,bsxfun(@times,   lhsdesign(Ntr,dim)    ,(ub-lb)));

ModelInfo.yf = f(ModelInfo.xf);

ModelInfo.yf = ModelInfo.yf + 0.05*randn(size(ModelInfo.yf));

% Initial/Boundary conditions
lt = bsxfun(@plus,lb(1),bsxfun(@times,   lhsdesign(Nbc(1),1)    ,(ub(1)-lb(1))));
onet = ones(Nbc(1),1);
lx = bsxfun(@plus,lb(2),bsxfun(@times,   lhsdesign(Nbc(2),1)    ,(ub(2)-lb(2))));
onex = ones(Nbc(2),1);
b1 = [lt onet]; b2 = [lt 0.0*onet]; b3 = [0.0*onex lx];
ModelInfo.xu = [b1; b2; b3];
ModelInfo.yu = u(ModelInfo.xu);
ModelInfo.yu = ModelInfo.yu + 0.01*randn(size(ModelInfo.yu));

ModelInfo.hyp = log([1 ones(1,dim) 10^-3 10^-3]);
[ModelInfo.hyp,~,~] = minimize(ModelInfo.hyp, @likelihood, -1000);

[NegLnLike]=likelihood(ModelInfo.hyp);

 
%% Make Predictions & Plot results
save_plots = 1;
time_dep = 1;
PlotResults