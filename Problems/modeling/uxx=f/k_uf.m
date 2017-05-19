function K_uf = k_uf(x, y, hyp,i)

D = size(x,2);
logtheta = hyp(2:D+1);
alpha = hyp(D+2);

n = size(x,1);
m = size(y,1);

K_uf = zeros(n,m);

if i <= D+1
    K_uu = k_uu(x,y,hyp(1:D+1),i);
    for d = 1:D
        if i-1 == d
            kk = @(x,y) alpha*(1/2).*exp(1).^((-3).*logtheta(d)).*(2.*exp(1).^(2.* ...
                logtheta(d))+(-5).*exp(1).^logtheta(d).*( ...
                x+(-1).*y).^2+(x+(-1).* ...
                y).^4);
            
            K_uf = K_uf + k_uu(x,y,hyp(1:D+1),0).*bsxfun(kk,x(:,d),y(:,d)');
        else
            kk = @(x,y) alpha*exp(1).^((-2).*logtheta(d)).*((-1).* ...
                exp(1).^logtheta(d)+(x+(-1).*y ...
                ).^2);
            
            K_uf = K_uf + K_uu.*bsxfun(kk,x(:,d),y(:,d)');
        end
    end
    
elseif i > D+1
    K_uu = k_uu(x,y,hyp(1:D+1),0);
    for d = 1:D
        kk = @(x,y) exp(1).^((-2).*logtheta(d)).*((-1).* ...
            exp(1).^logtheta(d)+(x+(-1).*y ...
            ).^2);
        
        K_uf = K_uf + K_uu.*bsxfun(kk,x(:,d),y(:,d)');
        
    end
end