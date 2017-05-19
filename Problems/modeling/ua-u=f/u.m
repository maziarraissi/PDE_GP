function u=u(x)

global ModelInfo;

alpha = ModelInfo.alpha;

u = (1/2).*exp(1).^((sqrt(-1)*(-2)).*pi.*x).*(((-1)+((sqrt(-1)*(-2)).* ...
    pi).^alpha).^(-1).*((sqrt(-1)*(-1))+2.*pi)+exp(1).^((sqrt(-1)*4).* ...
    pi.*x).*((-1)+((sqrt(-1)*2).*pi).^alpha).^(-1).*(sqrt(-1)+2.*pi));

u = real(u);

end