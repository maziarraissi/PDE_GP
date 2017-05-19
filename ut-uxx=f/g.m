function G = g(xx, yy, hyp, i)

logthetat = hyp(2);
logthetax = hyp(3);

t = xx(:,1);
x = xx(:,2);

s = yy(:,1);
y = yy(:,2);

K = k(xx,yy,hyp,0);

if i == 0 || i ==1
    G = 3.*exp(1).^((-2).*logthetax)+exp(1).^((-2).*logthetat).*(exp(1) ...
        .^logthetat+(-1).*(((-bsxfun(@minus,t,s')))).^2)+(-6).*exp(1).^((-3).*logthetax) ...
        .*((bsxfun(@minus,x,y'))).^2+exp(1).^((-4).*logthetax).*((bsxfun(@minus,x,y'))).^4;
    
    G = K.*G;
    
elseif i == 2
    
    G = (1/2).*exp(1).^((-3).*logthetat+(-4).*logthetax).*(exp(1).^(4.* ...
        logthetax).*((-2).*exp(1).^(2.*logthetat)+5.*exp(1).^logthetat.*...
        (((-bsxfun(@minus,t,s')))).^2+(-1).*(((-bsxfun(@minus,t,s')))).^4)+3.*exp(1).^(2.*(logthetat+ ...
        logthetax)).*(((-bsxfun(@minus,t,s')))).^2+(-6).*exp(1).^(2.*logthetat+logthetax) ...
        .*(((-bsxfun(@minus,t,s')))).^2.*((bsxfun(@minus,x,y'))).^2+exp(1).^(2.*logthetat).*...
        (((-bsxfun(@minus,t,s')))).^2.*((bsxfun(@minus,x,y'))).^4);
    
    G = K.*G;
    
elseif i==3
    
    G = (1/2).*exp(1).^((-5).*logthetax).*((-12).*exp(1).^(3.*logthetax)+ ...
        39.*exp(1).^(2.*logthetax).*((bsxfun(@minus,x,y'))).^2+exp(1).^((-2).* ...
        logthetat+4.*logthetax).*(exp(1).^logthetat+(-1).*(((-bsxfun(@minus,t,s')))).^2) ...
        .*((bsxfun(@minus,x,y'))).^2+(-14).*exp(1).^logthetax.*((bsxfun(@minus,x,y'))).^4+...
        ((bsxfun(@minus,x,y'))).^6);
    
    G = K.*G;
end

end

