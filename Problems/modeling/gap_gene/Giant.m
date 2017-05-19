global ModelInfo

%% Load data
load('gap_gene_data.mat')
Data = [Bcd Cad Hb Kr Gt Kni Tll ones(size(Bcd))];
weights = [0.0738; 0.0180; -0.0008; -0.0758; 0.0157; 0.0056; -0.0031; -3.5];
g = @(x) 0.5*((x./sqrt(x.^2 + 1)) + 1);
P_Gt = 25.15*g(Data*weights);
f_Gt = 0.5*(TX(:,1) < 16).*P_Gt + 0.0*(TX(:,1) >= 16 & TX(:,1) < 21).*P_Gt + 1.0*(TX(:,1) >= 21).*P_Gt;

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
ModelInfo.y_u = Gt;

% Data on f(x)
ModelInfo.x_f = TX;
ModelInfo.y_f = f_Gt;

%% Optimize model
% hyp = [logsigma logthetat logthetax lambda alpha logsigma_n_u logsigma_n_f]
hyp = [log([1 1 1]) 1 0.17 -2 -2];
options = optimoptions('fminunc','GradObj','on','Display','iter',...
     'Algorithm','trust-region','Diagnostics','on','DerivativeCheck','on','FinDiffType','central');
ModelInfo.hyp = fminunc(@likelihood,hyp,options);
%[ModelInfo.hyp,~,~] = minimize(hyp, @likelihood, -10000);

lambda_Gt =  ModelInfo.hyp(4);
alpha_Gt =  ModelInfo.hyp(5);
fprintf(1,'lambda = %f\n\n', lambda_Gt);
fprintf(1,'alpha = %f\n\n', alpha_Gt);

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

[pred_Gt_star, var_Gt_star] = predictor_u(x_star);
[pred_f_Gt_star, var_f_Gt_star] = predictor_f(x_star);

save Gt_pred_data lambda_Gt alpha_Gt pred_Gt_star var_Gt_star pred_f_Gt_star var_f_Gt_star