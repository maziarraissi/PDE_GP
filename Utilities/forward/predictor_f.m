function [f_star, v] = predictor_f(x_star)

global ModelInfo

xu = ModelInfo.xu;
yu = ModelInfo.yu;
hyp = ModelInfo.hyp;

D = size(xu,2);

y = yu;

L=ModelInfo.L;

psi = h(xu, x_star, hyp(1:D+1),0)';

% calculate prediction
f_star = psi*(L'\(L\y));

v = g(x_star, x_star, hyp(1:D+1),0) ...
  - psi*(L'\(L\psi'));

v = abs(diag(v));