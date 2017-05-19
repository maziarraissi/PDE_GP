function G = g(xx, yy, hyp, i)

logthetat = hyp(2);
logthetax = hyp(3);

t = xx(:,1);
x = xx(:,2);
    
s = yy(:,1);
y = yy(:,2);

K = k(xx,yy,hyp,0);

if i == 0
%     kt = @(t,s) 3*exp(-2*logthetax) + exp(-2*logthetat)*(exp(logthetat) - (s - t).^2);
%     kx = @(x,y) -6*exp(-3*logthetax)*(x - y).^2 + exp(-4*logthetax)*(x - y).^4;
%     K = G.* (  bsxfun(kt,t,s') + bsxfun(kx,x,y'));
    
    kt = @(t,s) 1 + exp(-logthetat) - exp(-2*logthetat)*(s - t).^2;
    kx = @(x,y) exp(-2*logthetax)*(3 + (x - y).^2) -6*exp(-3*logthetax)*(x - y).^2 + ...
        exp(-4*logthetax)*(x - y).^4 - cosh(logthetax) + sinh(logthetax);
    ktt = @(t,s) 2*(exp(-logthetat - logthetax))*(s - t);
    kxx = @(x,y) (x - y);
    
    G = K.*(bsxfun(kt,t,s') + bsxfun(kx,x,y') + bsxfun(ktt,t,s').*bsxfun(kxx,x,y'));

elseif i==1
    kt = @(t,s) exp(4*logthetax)*(exp(logthetat) + exp(2*logthetat) - (s - t).^2);
    kx = @(x,y) exp(2*(logthetat + logthetax))*(3 + (x - y).^2) - ...
        6*exp(2*logthetat + logthetax)*(x - y).^2 + exp(2*logthetat)*(x - y).^4;
    
    ktt = @(t,s) (s-t);
    kxx = @(x,y) (x-y);
    
    C = -exp(logthetat + 3*logthetax)*(exp(logthetat) - 2*bsxfun(ktt,t,s').*bsxfun(kxx,x,y'));
    
    G = exp(-2*(logthetat + 2*logthetax))*( C +  bsxfun(kt,t,s') + bsxfun(kx,x,y')   );
    G = K.*G;
    
elseif i == 2
    kt = @(t,s) exp(logthetat + 4*logthetax)*(-2 + (s - t).^2) + ...
        5*exp(4*logthetax)*(s - t).^2 - exp(-logthetat + 4*logthetax)*(s - t).^4;
    
    ktt = @(t,s) (s-t);
    kxx = @(x,y) (x-y);
    
    C1 = exp(logthetat + 2*logthetax)* bsxfun(ktt,t,s').^2.*(3 + bsxfun(kxx,x,y').^2);
    
    C2 = -exp(logthetat + 3*logthetax)*bsxfun(ktt,t,s').*(bsxfun(ktt,t,s') + 4*bsxfun(kxx,x,y'));
    
    C3 = 2*exp(3*logthetax)*bsxfun(ktt,t,s').^3.*bsxfun(kxx,x,y');
    
    C4 = -6*exp(logthetat + logthetax)*bsxfun(ktt,t,s').^2.*bsxfun(kxx,x,y').^2;
    
    C5 = exp(logthetat)*bsxfun(ktt,t,s').^2.*bsxfun(kxx,x,y').^4;
    
    G = 0.5*exp(-2*(logthetat + 2*logthetax))* ( bsxfun(kt,t,s') + C1 + C2 + C3 + C4 + C5     );
    
    G = K.*G;
    
elseif i==3
    
    kt = @(t,s) (s-t);
    kx = @(x,y) (x-y);
    G = (1/2).*exp(1).^((-2).*logthetat+(-5).*logthetax).*(exp(1).^(logthetat+3.*logthetax).*((-1).*exp(1).^logthetat.*(12+5.*bsxfun(kx,x,y').^2)+2.*bsxfun(kt,t,s').*bsxfun(kx,x,y').^3)+exp(1).^(4.*logthetax).*(exp(1).^(2.*logthetat).*(2+bsxfun(kx,x,y').^2)+(-1).*bsxfun(kt,t,s').^2.*bsxfun(kx,x,y').^2+exp(1).^logthetat.*bsxfun(kx,x,y').*((-4).*bsxfun(kt,t,s')+ bsxfun(kx,x,y')))+exp(1).^(2.*(logthetat+logthetax)).*(39+bsxfun(kx,x,y').^2).*bsxfun(kx,x,y').^2+(-14).*exp(1).^(2.*logthetat+logthetax).*bsxfun(kx,x,y').^4+exp(1).^(2.*logthetat).*bsxfun(kx,x,y').^6);

    G = K.*G;
end

end

