function [f, v] = predictor_f(x_star)

global ModelInfo
hyp = ModelInfo.hyp;
xf = ModelInfo.xf;

yf = ModelInfo.yf;

y = yf;

jitter = ModelInfo.jitter;

sigma_nf = exp(hyp(end));

[nf,D] = size(xf);
n = nf;

K = g(xf, xf, hyp(1:D+1),0);

K = K + eye(nf).*sigma_nf;

K = K + eye(n).*jitter;

% Cholesky factorisation
[L,p]=chol(K,'lower');

if p > 0
    fprintf(1,'Covariance is ill-conditioned\n');
end

psi = g(x_star,xf,hyp(1:D+1),0);

% calculate prediction
f = psi*(L'\(L\y));

v = g(x_star, x_star, hyp(1:D+1),0) ...
    - psi*(L'\(L\psi'));

v = diag(v);
