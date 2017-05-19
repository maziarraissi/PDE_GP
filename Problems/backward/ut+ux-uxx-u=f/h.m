function [H] = h(xx, yy, hyp,i)

logthetat = hyp(2);
logthetax = hyp(3);

t = xx(:,1);
x = xx(:,2);

s = yy(:,1);
y = yy(:,2);

K = k(xx,yy,hyp,0);

if i == 0
    ht = @(t,s) -1 + exp(-logthetat)*(-s + t);
    hx = @(x,y) -exp(-2*logthetax)*(x - y).^2 + exp(-logthetax)*(1 + x - y);

    H = K.*(bsxfun(ht,t,s') + bsxfun(hx,x,y'));
elseif i == 1
    ht = @(t,s) (t-s);
    hx = @(x,y) (x-y);
    H = (-1)+exp(1).^((-1).*logthetat).*bsxfun(ht,t,s')+(-1).*exp(1).^((-2).*logthetax).*(bsxfun(hx,x,y')).^2+exp(1).^((-1).*logthetax).*(1+bsxfun(hx,x,y'));
    
    H = K.*H;
elseif i == 2
    ht = @(t,s) (s-t);
    hx = @(x,y) (x-y);
    H = (-1/2).*exp(1).^((-2).*(logthetat+logthetax)).*(bsxfun(ht,t,s')).*(exp(1).^(2.*logthetax).*(exp(1).^logthetat.*((-2)+bsxfun(ht,t,s'))+(bsxfun(ht,t,s')).^2)+exp(1).^logthetat.*(bsxfun(ht,t,s')).*(bsxfun(hx,x,y')).^2+(-1).*exp(1).^(logthetat+logthetax).*(bsxfun(ht,t,s')).*(1+bsxfun(hx,x,y')));
  
    H = K.*H;
elseif i == 3
    ht = @(t,s) (s-t);
    hx = @(x,y) (x-y);
    
    hxx = @(x,y) 2+2.*x+x.^2+(-2).*(1+x).*y+y.^2;
    
    H = (1/2).*exp(1).^((-1).*logthetat+(-3).*logthetax).*((-1).*exp(1).^logthetat.*(bsxfun(hx,x,y')).^4+exp(1).^(logthetat+logthetax).*(bsxfun(hx,x,y')).^2.*(5+bsxfun(hx,x,y'))+exp(1).^(2.*logthetax).*((-1).*(bsxfun(ht,t,s')).*(bsxfun(hx,x,y')).^2+(-1).*exp(1).^logthetat.*(bsxfun(hxx,x,y'))));
  
    H = K.*H;
end

