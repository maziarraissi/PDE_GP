function u = u(xx)
    t = xx(:,1);
    x = xx(:,2);
    
    u = exp(-t).*sin(2*pi*x);
end