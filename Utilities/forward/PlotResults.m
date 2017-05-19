addpath /users/mraissi/export_fig/
set(0,'defaulttextinterpreter','latex')

n_star = 200;
x_star = linspace(lb(1), ub(1), n_star)';

[pred_u_star, var_u_star] = predictor_u(x_star);
[pred_f_star, var_f_star] = predictor_f(x_star);

u_star = u(x_star);
f_star = f(x_star);

fprintf(1,'Relative L2 error u: %e\n', (norm(pred_u_star-u_star,2)/norm(u_star,2)));
fprintf(1,'Relative L2 error f: %e\n', (norm(pred_f_star-f_star,2)/norm(f_star,2)));

color = [55,126,184]/255;

figure('units','normalized','outerposition',[0 0 1 1])
clear h;
clear leg;
subplot(1,2,1)
hold
h(1) = plot(x_star, u_star,'k','LineWidth',2);
h(2) = plot(ModelInfo.xu, ModelInfo.yu,'k+','MarkerSize',14, 'LineWidth',2);
%h(3) = plot(x_star,pred_u_star,'b--','LineWidth',3);
%[l,h(4)] = boundedline(x_star, pred_u_star, 2.0*sqrt(var_u_star), ':','alpha','cmap', color);
%outlinebounds(l,h(4));

leg{1} = '$u(x)$';
leg{2} = sprintf('%d training data', nu);
%leg{3} = '$\overline{u}(x)$'; leg{4} = 'Two standard deviation band';

hl = legend(h,leg,'Location','southwest');
legend boxoff
set(hl,'Interpreter','latex')
xlabel('$x$')
ylabel('$u(x)$')
title('(a)')

axis square
ylim(ylim + [-diff(ylim)/10 0]);
xlim(xlim + [-diff(xlim)/10 0]);
set(gca,'FontSize',18);
set(gcf, 'Color', 'w');


clear h;
clear leg;
subplot(1,2,2)
hold
h(1) = plot(x_star, f_star,'k','LineWidth',2);
%h(2) = plot(ModelInfo.xf, ModelInfo.yf,'kx','MarkerSize',14, 'LineWidth',2);
h(2) = plot(x_star,pred_f_star,'b--','LineWidth',3);
[l,h(3)] = boundedline(x_star, pred_f_star, 2.0*sqrt(var_f_star), ':', 'alpha','cmap', color);
outlinebounds(l,h(3));


leg{1} = '$f(x)$';
%leg{2} = sprintf('%d training data', nf);
leg{2} = '$\overline{f}(x)$'; leg{3} = 'Two standard deviations';

hl = legend(h,leg,'Location','southwest');
legend boxoff
set(hl,'Interpreter','latex')
xlabel('$x$')
ylabel('$f(x), \overline{f}(x)$')
title('(b)')

axis square
ylim(ylim + [-diff(ylim)/10 0]);
xlim(xlim + [-diff(xlim)/10 0]);
set(gca,'FontSize',18);
set(gcf, 'Color', 'w');

if save_plots  == 1
    export_fig ./Figs/solution.png -r300
end


