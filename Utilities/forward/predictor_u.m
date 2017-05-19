function [u_star, v] = predictor_u(x_star)

global ModelInfo

xu = ModelInfo.xu;
yu = ModelInfo.yu;
hyp = ModelInfo.hyp;

D = size(xu,2);

y = yu;

L=ModelInfo.L;

psi = k(x_star, xu, hyp(1:D+1),0);

% calculate prediction
u_star = psi*(L'\(L\y));

v = k(x_star, x_star, hyp(1:D+1),0) ...
  - psi*(L'\(L\psi'));

v = abs(diag(v));