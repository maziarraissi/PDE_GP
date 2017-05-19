global ModelInfo

%% Load data
load('gap_gene_data.mat')
Data = [Bcd Cad Hb Kr Gt Kni Tll ones(size(Bcd))];
weights = [0.2146; 0.0210; -0.1891; -0.0458; -0.1458; 0.0887; -0.3028; -3.5];
g = @(x) 0.5*((x./sqrt(x.^2 + 1)) + 1);
P_Kni = 16.12*g(Data*weights);
f_Kni = 0.5*(TX(:,1) < 16).*P_Kni + 0.0*(TX(:,1) >= 16 & TX(:,1) < 21).*P_Kni + 1.0*(TX(:,1) >= 21).*P_Kni;

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
ModelInfo.y_u = Kni;

% Data on f(x)
ModelInfo.x_f = TX;
ModelInfo.y_f = f_Kni;

%% Optimize model
% hyp = [logsigma logthetat logthetax lambda alpha logsigma_n_u logsigma_n_f]
hyp = [log([1 1 1]) 0.065 0.51 -2 -2];
options = optimoptions('fminunc','GradObj','on','Display','iter',...
     'Algorithm','trust-region','Diagnostics','on','DerivativeCheck','on','FinDiffType','central');
ModelInfo.hyp = fminunc(@likelihood,hyp,options);
%[ModelInfo.hyp,~,~] = minimize(hyp, @likelihood, -10000);

lambda_Kni = ModelInfo.hyp(4);
alpha_Kni = ModelInfo.hyp(5);
fprintf(1,'lambda = %f\n\n', lambda_Kni);
fprintf(1,'alpha = %f\n\n', alpha_Kni);

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

[pred_Kni_star, var_Kni_star] = predictor_u(x_star);
[pred_f_Kni_star, var_f_Kni_star] = predictor_f(x_star);

save Kni_pred_data x_star lambda_Kni alpha_Kni pred_Kni_star var_Kni_star pred_f_Kni_star var_f_Kni_star