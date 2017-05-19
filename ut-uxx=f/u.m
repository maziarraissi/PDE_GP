function y = u(xx)
    t = xx(:,1);
    x = xx(:,2);
    
    y = exp(1).^((-1/4).*t).*sin(2.*pi.*x);
end