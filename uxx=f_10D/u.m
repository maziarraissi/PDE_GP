function u=u(x)
    % u = prod(sin(pi*x(1:2:end)),2);
    u = sin(2*pi*x(:,1)).*sin(2*pi*x(:,5));
end