function [NLML,D_NLML]=likelihood(hyp)

global ModelInfo
xu = ModelInfo.xu;
xf = ModelInfo.xf;

yu = ModelInfo.yu;
yf = ModelInfo.yf;

y=[yu;yf];

jitter = ModelInfo.jitter;

sigma_nf = exp(hyp(end));
sigma_nu = exp(hyp(end-1));

nu = size(xu,1);
[nf,D] = size(xf);
n = nu+nf;

Kuu = k(xu, xu, hyp(1:D+1),0) + eye(nu).*sigma_nu;
Kuf = h(xu, xf, hyp(1:D+1),0);
Kfu = Kuf';
Kff = g(xf, xf, hyp(1:D+1),0) + eye(nf).*sigma_nf;

K = [Kuu Kuf;
    Kfu Kff];

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
    DKuu = k(xu, xu, hyp(1:D+1),i);
    DKuf = h(xu, xf, hyp(1:D+1),i);
    DKfu = DKuf';
    DKff = g(xf, xf, hyp(1:D+1),i);

    DK = [DKuu DKuf;
        DKfu DKff];

    D_NLML(i) = sum(sum(Q.*DK))/2;
end

D_NLML(end-1) = sigma_nu*trace(Q(1:nu,1:nu))/2;
D_NLML(end) = sigma_nf*trace(Q(nu+1:end,nu+1:end))/2;