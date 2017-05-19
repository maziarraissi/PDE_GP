function H = h(x, y, hyp,i)

logtheta = hyp(2:end);

D = length(hyp)-1;

n = size(x,1);
m = size(y,1);

H = zeros(n,m);

K = k(x,y,hyp,i);

for d = 1:D
    if i-1 == d
        hh = @(x,y) (1/2).*exp(1).^((-3).*logtheta(d)).*(2.*exp(1).^(2.* ...
            logtheta(d))+(-5).*exp(1).^logtheta(d).*( ...
            x+(-1).*y).^2+(x+(-1).* ...
            y).^4);
        
        H = H + k(x,y,hyp,0).*bsxfun(hh,x(:,d),y(:,d)');
    else
        hh = @(x,y) (exp(1).^((-2).*logtheta(d)).*((-1).*exp(1).^ ...
            logtheta(d)+(x+(-1).*y).^2)...
            );
        
        H = H + K.*bsxfun(hh,x(:,d),y(:,d)');
    end
end

end