function [H] = h(xx, yy, hyp,i)

logthetat = hyp(2);
logthetax = hyp(3);

t = xx(:,1);
x = xx(:,2);

s = yy(:,1);
y = yy(:,2);

K = k(xx,yy,hyp,0);

if i == 0 || i == 1
    H = exp(1).^((-1).*logthetax)+exp(1).^((-1).*logthetat).*((bsxfun(@minus,t,s')))+( ...
        -1).*exp(1).^((-2).*logthetax).*((bsxfun(@minus,x,y'))).^2;
    
    H = K.*H;
    
elseif i == 2
    
    H = (-1/2).*exp(1).^((-2).*(logthetat+logthetax)).*(((-bsxfun(@minus,t,s')))).*(exp( ...
        1).^(2.*logthetax).*((-2).*exp(1).^logthetat+(((-bsxfun(@minus,t,s')))).^2)+exp( ...
        1).^(logthetat+logthetax).*((bsxfun(@minus,t,s')))+exp(1).^logthetat.*...
        (((-bsxfun(@minus,t,s')))).*((bsxfun(@minus,x,y'))).^2);
    
    H = K.*H;
    
elseif i == 3
    
    H = (1/2).*exp(1).^((-1).*logthetat+(-3).*logthetax).*(exp(1).^(2.* ...
        logthetax).*((-2).*exp(1).^logthetat+(-1).*(((-bsxfun(@minus,t,s')))).*...
        ((bsxfun(@minus,x,y'))).^2)+5.*exp(1).^(logthetat+logthetax).*((bsxfun(@minus,x,y'))).^2+(-1).*exp( ...
        1).^logthetat.*((bsxfun(@minus,x,y'))).^4);
    
    H = K.*H;
end

