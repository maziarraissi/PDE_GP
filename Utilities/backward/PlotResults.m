addpath /users/mraissi/export_fig/
set(0,'defaulttextinterpreter','latex')

if D == 1
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
    h(3) = plot(x_star,pred_u_star,'b--','LineWidth',3);
    [l,h(4)] = boundedline(x_star, pred_u_star, 2.0*sqrt(var_u_star), ':','alpha','cmap', color);
    outlinebounds(l,h(4));
    
    leg{1} = '$u(x)$';
    leg{2} = sprintf('%d anchor point(s)', nu);
    leg{3} = '$\overline{u}(x)$'; leg{4} = 'Two standard deviations';
    
    hl = legend(h,leg,'Location','southwest');
    legend boxoff
    set(hl,'Interpreter','latex')
    xlabel('$x$')
    ylabel('$u(x)$, $\overline{u}(x)$')
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
    h(2) = plot(ModelInfo.xf, ModelInfo.yf,'kx','MarkerSize',14, 'LineWidth',2);
    %h(3) = plot(x_star,pred_f_star,'b--','LineWidth',3);
    %[l,h(4)] = boundedline(x_star, pred_f_star, 2.0*sqrt(var_f_star), ':', 'alpha','cmap', color);
    %outlinebounds(l,h(4));
    
    
    leg{1} = '$f(x)$';
    leg{2} = sprintf('%d training data', nf);
    %leg{3} = '$\overline{f}(x)$'; leg{4} = 'Two standard deviations';
    
    hl = legend(h,leg,'Location','southwest');
    legend boxoff
    set(hl,'Interpreter','latex')
    xlabel('$x$')
    ylabel('$f(x)$')
    title('(b)')
    
    axis square
    ylim(ylim + [-diff(ylim)/10 0]);
    xlim(xlim + [-diff(xlim)/10 0]);
    set(gca,'FontSize',18);
    set(gcf, 'Color', 'w');
    
    if save_plots  == 1
        export_fig ./Figs/solution.png -r300
    end
    
elseif D == 2
    
    nn = 50;
    x1 = linspace(lb(1), ub(1), nn)';
    x2 = linspace(lb(2), ub(2), nn)';
    [Xplot, Yplot] = meshgrid(x1,x2);
    x_star = reshape([Xplot Yplot], nn^2, 2);
    n_star = size(x_star,1);

    [pred_u_star, var_u_star] = predictor_u(x_star);
    [pred_f_star, var_f_star] = predictor_f(x_star);
    
    u_star = u(x_star);
    f_star = f(x_star);
    
    fprintf(1,'Relative L2 error u: %e\n', (norm(pred_u_star-u_star,2)/norm(u_star,2)));
    fprintf(1,'Relative L2 error f: %e\n', (norm(pred_f_star-f_star,2)/norm(f_star,2)));
    
    u_star_plot = griddata(x_star(:,1),x_star(:,2),u_star,Xplot,Yplot,'cubic');
    pred_u_star_plot = griddata(x_star(:,1),x_star(:,2),pred_u_star,Xplot,Yplot,'cubic');
    var_u_star_plot = griddata(x_star(:,1),x_star(:,2),var_u_star,Xplot,Yplot,'cubic');
    
    f_star_plot = griddata(x_star(:,1),x_star(:,2),f_star,Xplot,Yplot,'cubic');
    pred_f_star_plot = griddata(x_star(:,1),x_star(:,2),pred_f_star,Xplot,Yplot,'cubic');
    var_f_star_plot = griddata(x_star(:,1),x_star(:,2),var_f_star,Xplot,Yplot,'cubic');
      
    figure('units','normalized','outerposition',[0 0 1 1])
    clear h;
    clear leg;
    subplot(1,2,1)
    hold
    
    s1 = surf(Xplot,Yplot,u_star_plot);
    set(s1,'FaceColor',[100,100,100]/255,'EdgeColor',[100,100,100]/255, 'LineWidth',0.001,'FaceAlpha',0.1);
    
    plot3(ModelInfo.xu(:,1), ModelInfo.xu(:,2), ModelInfo.yu,'s', 'MarkerEdgeColor','k', 'MarkerSize',10,'LineWidth',2);
    view(3)
    zz = get(gca,'ZTick');
    set(gca,'ZTickLabel',sprintf('%3.1f\n',zz));
    
    leg = cell(1,2);
    if time_dep == 1
        leg{1} = '$u(t,x)$';
        leg{2} = sprintf('Anchor points (%d points)',size(ModelInfo.xu,1));
    else
        leg{1} = '$u(x)$';
        leg{2} = sprintf('Anchor points (%d points)',size(ModelInfo.xu,1));
    end
    
    hl = legend(leg,'Location','southwest');
    legend boxoff
    set(hl,'Interpreter','latex')
    
    if time_dep ==1
        xlabel('$t$')
        ylabel('$x$')
        zlabel('$u(t,x)$')
    else
        xlabel('$x_1$')
        ylabel('$x_2$')        
        zlabel('$u(x)$')
    end
    title('(a)')
    
    axis square
    set(gca,'FontSize',18);
    set(gcf, 'Color', 'w');
    
    
    clear h;
    clear leg;
    subplot(1,2,2)
    hold
    
    s1 = surf(Xplot,Yplot,f_star_plot);
    set(s1,'FaceColor',[100,100,100]/255,'EdgeColor',[100,100,100]/255, 'LineWidth',0.001,'FaceAlpha',0.1);
            
    plot3(ModelInfo.xf(:,1), ModelInfo.xf(:,2), ModelInfo.yf,'o', 'MarkerEdgeColor','k','MarkerSize',10,'LineWidth',2);
    
    view(3)
    zz = get(gca,'ZTick');
    set(gca,'ZTickLabel',sprintf('%3.1f\n',zz));
    
    if time_dep == 1
        leg{1} = '$f(t,x)$';
    else
        leg{1} = '$f(x)$';
    end        
    leg{2} = sprintf('Training data (%d points)',size(ModelInfo.xf,1));
    
    hl = legend(leg,'Location','southwest');
    legend boxoff
    set(hl,'Interpreter','latex')
    
    if time_dep == 1
        xlabel('$t$')
        ylabel('$x$')
        zlabel('$f(t,x)$')
    else
        xlabel('$x_1$')
        ylabel('$x_2$')        
        zlabel('$f(x)$')
    end
    title('(b)')
    
    axis square
    set(gca,'FontSize',18);
    set(gcf, 'Color', 'w');
    
    if save_plots  == 1
        export_fig ./Figs/data.png -r300
    end 
    
    figure('units','normalized','outerposition',[0 0 1 1])
    clear h
    clear leg
    subplot(1,2,1)
    hold
    contourf(Xplot,Yplot,abs(u_star_plot - pred_u_star_plot));
    colormap('cool')
    h(1) = plot(ModelInfo.xf(:,1), ModelInfo.xf(:,2), 'o', 'MarkerEdgeColor','k','MarkerSize',10,'LineWidth',2);
    h(2) = plot(ModelInfo.xu(:,1), ModelInfo.xu(:,2), 's', 'MarkerEdgeColor','k','MarkerSize',10,'LineWidth',2);
    
    leg{1} = sprintf('Training data (%d points)',size(ModelInfo.xf,1));
    if time_dep == 1
        leg{2} = sprintf('Anchor Points (%d points)',size(ModelInfo.xu,1));
    else
        leg{2} = sprintf('Anchor Points (%d points)',size(ModelInfo.xu,1));
    end
    
    hl = legend(h,leg,'Location','southoutside');
    legend boxoff
    set(hl,'Interpreter','latex')
    
    if time_dep == 1
        title('(a) Error $|u(t,x) - \overline{u}(t,x)|$');
    else
        title('(a) Error $|u(x) - \overline{u}(x)|$');
    end
    
    colorbar
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
    
    
    clear h
    clear leg
    subplot(1,2,2)
    hold
    contourf(Xplot,Yplot,sqrt(var_u_star_plot));
    h(1) = plot(ModelInfo.xf(:,1), ModelInfo.xf(:,2), 'o', 'MarkerEdgeColor','k','MarkerSize',10,'LineWidth',2);
    h(2) = plot(ModelInfo.xu(:,1), ModelInfo.xu(:,2), 's', 'MarkerEdgeColor','k','MarkerSize',10,'LineWidth',2);
    
    leg{1} = sprintf('Training data (%d points)',size(ModelInfo.xf,1));
    leg{2} = sprintf('Anchor Points (%d points)',size(ModelInfo.xu,1));
    
    hl = legend(h,leg,'Location','southoutside');
    legend boxoff
    set(hl,'Interpreter','latex')
    
    title({'(b) Standard deviation'});
    colorbar
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
    
    if save_plots  == 1
        export_fig ./Figs/solution.png -r300
    end
       
end