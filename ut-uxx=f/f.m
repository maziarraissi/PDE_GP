function y=f(xx)
    t = xx(:,1);
    x = xx(:,2);
    
    y =(1/4).*exp(1).^((-1/4).*t).*((-1)+16.*pi.^2).*sin(2.*pi.*x);
end