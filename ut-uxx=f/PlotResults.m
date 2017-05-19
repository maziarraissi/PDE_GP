addpath /users/mraissi/export_fig/
set(0,'defaulttextinterpreter','latex')

nn = 50;
x1 = linspace(lb(1), ub(1), nn)';
x2 = linspace(lb(2), ub(2), nn)';
[Xplot, Yplot] = meshgrid(x1,x2);
x_star = reshape([Xplot Yplot], nn^2, 2);
Nts = size(x_star,1);


% Predictor
[pred_u_star, var_u_star] = predictor_u(x_star);
[pred_f_star, var_f_star] = predictor_f(x_star);

u_star = u(x_star);
f_star = f(x_star);

fprintf(1,'Relative L2 error u: %e\n', (norm(pred_u_star-u_star,2)/norm(u_star,2)));
fprintf(1,'Relative L2 error RHS_H: %e\n', (norm(pred_f_star-f_star,2)/norm(f_star,2)));


color2 = [217,95,2]/255;


Exactplot = griddata(x_star(:,1),x_star(:,2),u_star,Xplot,Yplot,'cubic');
Predplot = griddata(x_star(:,1),x_star(:,2),pred_u_star,Xplot,Yplot,'cubic');
Varplot = griddata(x_star(:,1),x_star(:,2),var_u_star,Xplot,Yplot,'cubic');

Exactplot_rhs = griddata(x_star(:,1),x_star(:,2),f_star,Xplot,Yplot,'cubic');
Predplot_rhs = griddata(x_star(:,1),x_star(:,2),pred_f_star,Xplot,Yplot,'cubic');
Varplot_rhs = griddata(x_star(:,1),x_star(:,2),var_f_star,Xplot,Yplot,'cubic');

EH = griddata(x_star(:,1),x_star(:,2),f_star,Xplot,Yplot,'cubic');


figure('units','normalized','outerposition',[0 0 1 1])
clear h;
clear leg;
subplot(1,2,1)
hold

s1 = surf(Xplot,Yplot,Predplot);
set(s1,'FaceColor',[100,100,100]/255,'EdgeColor',[100,100,100]/255, 'LineWidth',0.001,'FaceAlpha',0.1);

%contour(Xplot,Yplot,Exactplot,20);

plot3(ModelInfo.xu(:,1), ModelInfo.xu(:,2), ModelInfo.yu,'s', 'MarkerFaceColor','m', 'MarkerSize',10);
view(3)
zz = get(gca,'ZTick');
set(gca,'ZTickLabel',sprintf('%3.1f\n',zz));

if time_dep == 1
    %leg{1} = 'Predictive mean $\overline{u}(t,x)$';
    leg{1} = 'Exact solution $u(t,x)$';
    leg{2} = sprintf('Initial/Boundary data (%d points)',size(ModelInfo.xu,1));
else
    %leg{1} = 'Predictive mean $\overline{u}(x)$';
    leg{1} = 'Exact solution $u(x)$';
    leg{2} = sprintf('Boundary data (%d points)',size(ModelInfo.xu,1));
end

hl = legend(leg,'Location','southoutside');
legend boxoff
set(hl,'Interpreter','latex')
title('(a)')

if time_dep ==1
    xlabel('$t$')
    ylabel('$x$')
    zlabel('$u(t,x)$')
else
    xlabel('$x_1$')
    ylabel('$x_2$')
    zlabel('$u(x)$')
end
axis square
set(gca,'FontSize',18);
set(gcf, 'Color', 'w');



clear h;
clear leg;
subplot(1,2,2)
hold
%shift = 50;
shift = 0;

s1 = surf(Xplot,Yplot,Predplot_rhs+shift);
set(s1,'FaceColor',[100,100,100]/255,'EdgeColor',[100,100,100]/255, 'LineWidth',0.001,'FaceAlpha',0.1);

%contour(Xplot,Yplot,Exactplot_rhs,20);

plot3(ModelInfo.xf(:,1), ModelInfo.xf(:,2), ModelInfo.yf+shift,'o', 'MarkerFaceColor','r', 'MarkerEdgeColor','r','MarkerSize',10);

view(3)
zz = get(gca,'ZTick');
set(gca,'ZTickLabel',sprintf('%3.1f\n',zz-shift));

if time_dep == 1
%    leg{1} = 'Predictive mean $\overline{f}(t,x)$';
    leg{1} = 'Exact forcing $f(t,x)$';
else
%    leg{1} = 'Predictive mean $\overline{f}(x)$';
    leg{1} = 'Exact forcing $f(x)$';
end
leg{2} = sprintf('Training data (%d points)',size(ModelInfo.xf,1));

hl = legend(leg,'Location','southoutside');
legend boxoff
set(hl,'Interpreter','latex')
title('(b)')

if time_dep == 1
    xlabel('$t$')
    ylabel('$x$')
    %zlabel('$f(t,x), \overline{f}(t,x)$')
    zlabel('$f(t,x)$')
else
    xlabel('$x_1$')
    ylabel('$x_2$')
    %zlabel('$f(x), \overline{f}(x)$')
    zlabel('$f(x)$')
end
axis square
set(gca,'FontSize',18);
set(gcf, 'Color', 'w');

if save_plots  == 1
    export_fig solution.png -r300
end


figure('units','normalized','outerposition',[0 0 1 1])
clear h;
clear leg;
subplot(1,2,1)
hold

contourf(Xplot,Yplot,2*sqrt(Varplot));
plot(ModelInfo.xf(:,1), ModelInfo.xf(:,2), 'o','MarkerFaceColor','r', 'MarkerEdgeColor','r','MarkerSize',10);
plot(ModelInfo.xu(:,1), ModelInfo.xu(:,2), 's','MarkerFaceColor','m', 'MarkerEdgeColor','m','MarkerSize',10);

leg{1} = 'Two standard deviations';
leg{2} = sprintf('Training data (%d points)',size(ModelInfo.xf,1));
if time_dep == 1
    leg{3} = sprintf('Initial/Boundary data (%d points)',size(ModelInfo.xu,1));
else
    leg{3} = sprintf('Boundary data (%d points)',size(ModelInfo.xu,1));
end
colorbar
hl = legend(leg,'Location','northoutside');
legend boxoff
set(hl,'Interpreter','latex')

title('(a)');

if time_dep == 1
    xlabel('$t$')
    ylabel('$x$')
else
    xlabel('$x_1$')
    ylabel('$x_2$')
end
axis square
set(gca,'FontSize',18);
set(gcf, 'Color', 'w');

clear h;
clear leg;
subplot(1,2,2)
hold

contourf(Xplot,Yplot,abs(Exactplot - Predplot));
shading interp
plot(ModelInfo.xf(:,1), ModelInfo.xf(:,2), 'o','MarkerFaceColor','r', 'MarkerEdgeColor','r','MarkerSize',10);
plot(ModelInfo.xu(:,1), ModelInfo.xu(:,2), 's','MarkerFaceColor','m', 'MarkerEdgeColor','m','MarkerSize',10);

leg{1} = 'Absolute error';
leg{2} = sprintf('Training data (%d points)',size(ModelInfo.xf,1));
if time_dep == 1
    leg{3} = sprintf('Initial/Boundary data (%d points)',size(ModelInfo.xu,1));
else
    leg{3} = sprintf('Boundary data (%d points)',size(ModelInfo.xu,1));
end
colorbar

hl = legend(leg,'Location','northoutside');
legend boxoff
set(hl,'Interpreter','latex')
title('(b)');


if time_dep == 1
    xlabel('$t$')
    ylabel('$x$')
else
    xlabel('$x_1$');
    ylabel('$x_2$');
end
axis square
set(gca,'FontSize',18);
set(gcf, 'Color', 'w');
if save_plots  == 1
    export_fig error.png -r300
end

