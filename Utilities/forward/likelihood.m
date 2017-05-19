function [NLML,D_NLML]=likelihood(hyp)

global ModelInfo
xu = ModelInfo.xu;

yu = ModelInfo.yu;

y=yu;

jitter = ModelInfo.jitter;

sigma_nu = exp(hyp(end));

[nu,D] = size(xu);
n = nu;


K = k(xu, xu, hyp(1:D+1),0);

K = K + eye(nu).*sigma_nu;

K = K + eye(n).*jitter;

% Cholesky factorisation
[L,p]=chol(K,'lower');

ModelInfo.L = L;

if p > 0
    fprintf(1,'Covariance is ill-conditioned\n');
end

alpha = L'\(L\y);
NLML = 0.5*y'*alpha + sum(log(diag(L))) + log(2*pi)*n/2;


D_NLML = 0*hyp;
Q =  L'\(L\eye(n)) - alpha*alpha';
for i=1:D+1

    DK = k(xu, xu, hyp(1:D+1),i);

    D_NLML(i) = sum(sum(Q.*DK))/2;
end

D_NLML(end) = sigma_nu*trace(Q)/2;