function y=f(xx)
    t = xx(:,1);
    x = xx(:,2);
    
    y = exp(1).^((-1).*t).*(2.*pi.*cos(2.*pi.*x)+2.*((-1)+2.*pi.^2).*sin(2.*pi.*x));
    %y = -exp(-t).*sin(2*pi*x)*(1-4*pi^2);
end
