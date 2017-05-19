clear all
global ModelInfo

%% Load data
load('gap_gene_data.mat')
Data = [Bcd Cad Hb Kr Gt Kni Tll ones(size(Bcd))];
weights = [0.1114; -0.0054; 0.0293; -0.0124; 0.0553; -0.3903; 0.0144; -3.5];
g = @(x) 0.5*((x./sqrt(x.^2 + 1)) + 1);
P_Hb = 32.03*g(Data*weights);
f_Hb = 0.5*(TX(:,1) < 16).*P_Hb + 0.0*(TX(:,1) >= 16 & TX(:,1) < 21).*P_Hb + 1.0*(TX(:,1) >= 21).*P_Hb;

%% Setup
n_f = size(TX,1);
n_u = size(TX,1);
D = 2;
lb = [0 35];
ub = [68 92];
ModelInfo.jitter = eps;

%% Generate Data
% Data on u(x)
ModelInfo.x_u = TX;
ModelInfo.y_u = Hb;

% Data on f(x)
ModelInfo.x_f = TX;
ModelInfo.y_f = f_Hb;

%% Optimize model
% hyp = [logsigma logthetat logthetax lambda alpha logsigma_n_u logsigma_n_f]
hyp = [log([1 1 1]) 0.136 2.25 -2 -2];
options = optimoptions('fminunc','GradObj','on','Display','iter',...
     'Algorithm','trust-region','Diagnostics','on','DerivativeCheck','on','FinDiffType','central');
ModelInfo.hyp = fminunc(@likelihood,hyp,options);
%[ModelInfo.hyp,~,~] = minimize(hyp, @likelihood, -10000);

lambda_Hb = ModelInfo.hyp(4);
alpha_Hb = ModelInfo.hyp(5);
fprintf(1,'lambda = %f\n\n', lambda_Hb);
fprintf(1,'alpha = %f\n\n', alpha_Hb);

fprintf(1,'sigma_f = %f\n\n', sqrt(exp(ModelInfo.hyp(1))));
fprintf(1,'theta_t = %f\n\n', sqrt(exp(ModelInfo.hyp(2))));
fprintf(1,'theta_x = %f\n\n', sqrt(exp(ModelInfo.hyp(3))));

fprintf(1,'sigma_n_u = %f\n\n', sqrt(exp(ModelInfo.hyp(end-1))));
fprintf(1,'sigma_n_f = %f\n\n', sqrt(exp(ModelInfo.hyp(end))));

%% Make Predictions
nn = 100;
x1 = sort([unique(TX(:,1)); 33]);
x2 = linspace(lb(2), ub(2), nn)';
[Xplot, Yplot] = meshgrid(x1,x2);
x_star = reshape([Xplot Yplot], nn*length(x1), 2);
n_star = size(x_star,1);

[pred_Hb_star, var_Hb_star] = predictor_u(x_star);
[pred_f_Hb_star, var_f_Hb_star] = predictor_f(x_star);

save Hb_pred_data lambda_Hb alpha_Hb pred_Hb_star var_Hb_star pred_f_Hb_star var_f_Hb_star