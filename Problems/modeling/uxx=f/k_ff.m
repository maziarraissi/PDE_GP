function K_ff = k_ff(x, y, hyp,i)

D = size(x,2);
logtheta = hyp(2:D+1);
alpha = hyp(D+2);

n = size(x,1);
m = size(y,1);

K_ff = zeros(n,m);

if i <= D+1
    K_uu = k_uu(x,y,hyp(1:D+1),i);
    
    for d = 1:D
        for dp = 1:D
            if d==dp
                if i-1==d
                    kk = @(x,y) alpha^2*((1/2).*exp(1).^((-5).*logtheta(d)).*((-12).*exp(1).^(3.* ...
                        logtheta(d))+39.*exp(1).^(2.*logtheta(d)).*( ...
                        x+(-1).*y).^2+(-14).*exp(1).^ ...
                        logtheta(d).*(x+(-1).*y).^4+( ...
                        x+(-1).*y).^6) ...
                        );
                    K_ff = K_ff + k_uu(x,y,hyp(1:D+1),0).*bsxfun(kk,x(:,d),y(:,d)');
                else
                    kk = @(x,y) alpha^2*exp(1).^((-4).*logtheta(d)).*(3.* ...
                        exp(1).^(2.*logtheta(d))+(-6).*exp(1).^...
                        logtheta(d).*(x+(-1).*y).^2+(x+(-1).*y).^4);
                    
                    K_ff = K_ff + K_uu.*bsxfun(kk,x(:,d),y(:,d)');
                end
            else
                if i-1==d
                    c = alpha^2*(-1/2).*exp(1).^((-3).*logtheta(d)+(-2).* ...
                        logtheta(dp));
                    kk_1 = @(x,y) (2.*exp(1).^(2.*logtheta(d))+(-5).*exp(1).^ ...
                        logtheta(d).*(x+(-1).*y).^2+( ...
                        x+(-1).*y).^4);
                    kk_2 = @(x,y) (exp(1).^logtheta(dp)+(-1).*(x+(-1).* ...
                        y).^2 ...
                        );
                    K_ff = K_ff + k_uu(x,y,hyp(1:D+1),0).*c.*bsxfun(kk_1,x(:,d),y(:,d)').*bsxfun(kk_2,x(:,dp),y(:,dp)');
                elseif i-1==dp
                    c = alpha^2*(-1/2).*exp(1).^((-2).*logtheta(d)+(-3).* ...
                        logtheta(dp));
                    kk_1 = @(x,y) (exp(1).^logtheta(d)+(-1).*(x+(-1).* ...
                        y).^2 ...
                        );
                    kk_2 = @(x,y) (2.*exp(1).^(2.*logtheta(dp))+(-5).*exp(1).^ ...
                        logtheta(dp).*(x+(-1).*y).^2+( ...
                        x+(-1).*y).^4);
                    K_ff = K_ff + k_uu(x,y,hyp(1:D+1),0).*c.*bsxfun(kk_1,x(:,d),y(:,d)').*bsxfun(kk_2,x(:,dp),y(:,dp)');
                else
                    c = alpha^2*exp(1).^((-2).*(logtheta(d)+logtheta(dp)));
                    kk_1 = @(x,y) (exp(1).^logtheta(d)+(-1).*(x+(-1).* ...
                        y).^2);
                    kk_2 = @(x,y) (exp(1).^logtheta(dp)+(-1).*(x+(-1).* ...
                        y).^2);
                    
                    K_ff = K_ff + K_uu.*c.*bsxfun(kk_1,x(:,d),y(:,d)').*bsxfun(kk_2,x(:,dp),y(:,dp)');
                end
            end
        end
    end
    
elseif i > D+1
    K_uu = k_uu(x,y,hyp(1:D+1),0);
    for d = 1:D
        for dp = 1:D
            if d == dp
                kk = @(x,y) 2*alpha*exp(1).^((-4).*logtheta(d)).*(3.* ...
                    exp(1).^(2.*logtheta(d))+(-6).*exp(1).^...
                    logtheta(d).*(x+(-1).*y).^2+(x+(-1).*y).^4);
            
                K_ff = K_ff + K_uu.*bsxfun(kk,x(:,d),y(:,d)');
            
            else
                c = 2*alpha*exp(1).^((-2).*(logtheta(d)+logtheta(dp)));
                kk_1 = @(x,y) (exp(1).^logtheta(d)+(-1).*(x+(-1).* ...
                    y).^2);
                kk_2 = @(x,y) (exp(1).^logtheta(dp)+(-1).*(x+(-1).* ...
                    y).^2);
            
            
                K_ff = K_ff + K_uu.*c.*bsxfun(kk_1,x(:,d),y(:,d)').*bsxfun(kk_2,x(:,dp),y(:,dp)');
            end
        end
    end
end


end

