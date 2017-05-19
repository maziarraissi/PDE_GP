function f=f(xx)
    t = xx(:,1);
    x = xx(:,2);

    alpha = sqrt(2);
    lambda = 0.5;
    f = exp(1).^((-1).*t).*((-1)+lambda+4.*alpha.*pi.^2).*sin(2.*pi.*x);
end