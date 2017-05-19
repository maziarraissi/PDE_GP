function f=f(xx)
    t = xx(:,1);
    x = xx(:,2);
    
    f = exp(1).^((-1).*t).*((-1)+4.*pi.^2).*sin(2.*pi.*x);
end