set(0,'defaulttextinterpreter','latex')

if dim == 1
    nn = 200;
    Xts = linspace(lb(1), ub(1), nn)';
    Nts = size(Xts,1);
elseif dim == 2
    nn = 50;
    x1 = linspace(lb(1), ub(1), nn)';
    x2 = linspace(lb(2), ub(2), nn)';
    [Xplot, Yplot] = meshgrid(x1,x2);
    Xts = reshape([Xplot Yplot], nn^2, 2);
    Nts = size(Xts,1);
else
    rng('default');
    Nts = 1000;
    xts = rand(Nts,dim);
    Xts = bsxfun(@plus,lb,bsxfun(@times,xts,(ub-lb)));
    idx = 1;
    nplt = 80;
    Xplot = [linspace(lb(idx), ub(idx),nplt)' ones(nplt,dim-1)/4];
end

% Predictor
[Kpred, Kvar] = predictor_u(Xts);
[Kpred_rhs, Kvar_rhs] = predictor_f(Xts);

Exact_u = u(Xts);
Exact_f = f(Xts);

fprintf(1,'Relative L2 error u: %e\n', (norm(Kpred-Exact_u,2)/norm(Exact_u,2)));
fprintf(1,'Relative L2 error RHS_H: %e\n', (norm(Kpred_rhs-Exact_f,2)/norm(Exact_f,2)));
fprintf(1,'Relative L2 error RHS_L: %e\n', (norm(Kpred_rhs_L-Exact_rhs_L,2)/norm(Exact_rhs_L,2)));


% buf = sprintf('Exact_d%d_n1-%d_n2-%d.txt', size(Xts,2), size(ModelInfo.x1,1), size(ModelInfo.x2,1));
% save(buf,'-ascii','-double','Exact');
% buf = sprintf('Kpred_d%d_n1-%d_n2-%d.txt', size(Xts,2), size(ModelInfo.x1,1), size(ModelInfo.x2,1));
% save(buf,'-ascii','-double','Kpred');


color2 = [217,95,2]/255;

if dim == 1
    figure(1)
    clf
    hold
    plot(Xts, Exact_u,'b','LineWidth',3)
    plot(Xts,Kpred,'r--','LineWidth',3)
    [l,p] = boundedline(Xts, Kpred, 2.0*sqrt(Kvar), ':', 'alpha','cmap', color2);
    outlinebounds(l,p);
    hl = legend('Exact solution', 'GP posterior mean', 'Two standard deviation band','Location','eastoutside');
    set(hl,'Interpreter','latex')
    xlabel('$x$')
    ylabel('$u_{2}(x)$')
    axis square
    set(gca,'FontSize',24);
    set(gcf, 'Color', 'w');
    if save_plots  == 1
        export_fig solution.png -r300
    end
    
    figure(2)
    clf
    hold
    h(1) = plot(Xts, Exact_f,'b','LineWidth',3);
    h(2) = plot(Xts,Kpred_rhs,'r--','LineWidth',3);
    [l,h(3)] = boundedline(Xts, Kpred_rhs, 2.0*sqrt(Kvar_rhs), ':', 'alpha','cmap', color2);
    outlinebounds(l,h(3));
    
    h(4) = plot(Xts, Exact_rhs_L,'k','LineWidth',2);
    h(5) = plot(Xts,Kpred_rhs_L,'m--','LineWidth',2);
    [l,h(6)] = boundedline(Xts, Kpred_rhs_L, 2.0*sqrt(Kvar_rhs_L), ':', 'alpha','cmap', color2);
    outlinebounds(l,h(6));
    
    h(7) = plot(ModelInfo.x2, ModelInfo.y2,'kx','MarkerSize',16, 'LineWidth',3);
    h(8) = plot(ModelInfo.x1, ModelInfo.y1,'r+','MarkerSize',16, 'LineWidth',3);
    
    buf1 = sprintf('High-fidelity training data (%d points)', Ntr(2));
    buf2 = sprintf('Low-fidelity training data (%d points)', Ntr(1));
    leg{1} = 'Exact hight-fidelity forcing'; leg{2} ='Predictive mean (high-fidelity)';
    leg{3} ='Two standard deviation band (high-fidelity)';
    
    leg{4} = 'Exact low-fidelity forcing'; leg{5} ='Predictive mean (low-fidelity)';
    leg{6} ='Two standard deviation band (low-fidelity)';
    
    leg{7} = buf1; leg{8} = buf2;
    
    xlabel('$x$')
    ylabel('$f_{1}(x), f_{2}(x)$')
    hl = legend(h,leg,'Location','eastoutside');
    set(hl,'Interpreter','latex')
    axis square
    set(gca,'FontSize',24);
    set(gcf, 'Color', 'w');
    if save_plots  == 1
        export_fig forcing.png -r300
    end
    
    
    figure(3)
    clf
    hold
    h(1) = plot(Exact_rhs_L, Exact_f,'b','LineWidth',3);
    xlabel('$f_{1}(x)$');
    ylabel('$f_{2}(x)$');
    title('$f_{1}(x),f_{2}(x)$ Cross-correlation');
    axis square
    set(gca,'FontSize',48);
    set(gca,'Xtick',[]);
    set(gca,'Ytick',[]);
    set(gcf, 'Color', 'w');
    if save_plots  == 1
        export_fig correlation.png -r300
    end
    
elseif dim > 2
    miny = min(Exact_u);
    maxy = max(Exact_u);
    
    [ev, idx] = sort(Exact_u);
    
    figure(1)
    clf
    hold
    plot(ev, Kpred(idx), 'ko','MarkerSize', 8);
    plot(ev, ev, 'r-.','LineWidth',3);
    
    xlim([miny maxy]);
    ylim([miny maxy]);
    axis square
    buf = {'GP posterior mean','Exact'};
    
    xlabel('$u_{2}(x)$')
    ylabel('$\overline{u}_{2}(x)$')
    hl = legend(buf,'Location','southoutside');
    set(hl,'Interpreter','latex')
    axis square
    set(gca,'FontSize',24);
    set(gcf, 'Color', 'w');
    if save_plots  == 1
        export_fig scatter.png -r300
    end
    
    % 1D Predictor
    Eplt = Exact_solution(Xplot);
    [Kp_plt, Kv_plt] = predictor(Xplot);
    
    
    figure(2)
    clf
    hold
    plot(Xplot(:,1), Eplt,'b','LineWidth',3)
    plot(Xplot(:,1),Kp_plt,'r--','LineWidth',3)
    [l,p] = boundedline(Xplot(:,1), Kp_plt, 2.0*sqrt(Kv_plt), ':', 'alpha','cmap', color2);
    outlinebounds(l,p);
    hl = legend('Exact solution', 'GP posterior mean', 'Two standard deviation band','Location','eastoutside');
    set(hl,'Interpreter','latex')
    xlabel('$x_1$')
    ylabel('$u_{2}(x)$')
    axis square
    set(gca,'FontSize',24);
    set(gcf, 'Color', 'w');
    if save_plots  == 1
        export_fig solution.png -r300
    end
    
    Rhs_H_plt = RHS_H(Xplot);
    Rhs_L_plt = RHS_L(Xplot);
    [Rhs_H_p_plt, Rhs_H_v_plt] = predictor_rhs_H(Xplot);
    [Rhs_L_p_plt, Rhs_L_v_plt] = predictor_rhs_L(Xplot);
    
    figure(3)
    clf
    hold
    h(1) = plot(Xplot(:,1), Rhs_H_plt,'b','LineWidth',3);
    h(2) = plot(Xplot(:,1),Rhs_H_p_plt,'r--','LineWidth',3);
    [l,h(3)] = boundedline(Xplot(:,1), Rhs_H_p_plt, 2.0*sqrt(Rhs_H_v_plt), ':', 'alpha','cmap', color2);
    outlinebounds(l,h(3));
    
    h(4) = plot(Xplot(:,1), Rhs_L_plt,'k','LineWidth',2);
    h(5) = plot(Xplot(:,1),Rhs_L_p_plt,'m--','LineWidth',2);
    [l,h(6)] = boundedline(Xplot(:,1), Rhs_L_p_plt, 2.0*sqrt(Rhs_L_v_plt), ':', 'alpha','cmap', color2);
    outlinebounds(l,h(6));
    
    
    buf1 = sprintf('High-fidelity training data (%d points)', Ntr(2));
    buf2 = sprintf('Low-fidelity training data (%d points)', Ntr(1));
    leg{1} = 'Exact hight-fidelity forcing'; leg{2} ='Predictive mean (high-fidelity)';
    leg{3} ='Two standard deviation band (high-fidelity)';
    
    leg{4} = 'Exact low-fidelity forcing'; leg{5} ='Predictive mean (low-fidelity)';
    leg{6} ='Two standard deviation band (low-fidelity)';
    
    xlabel('$x_1$')
    ylabel('$f_{1}(x), f_{2}(x)$')
    hl = legend(h,leg,'Location','eastoutside');
    set(hl,'Interpreter','latex')
    axis square
    set(gca,'FontSize',24);
    set(gcf, 'Color', 'w');
    if save_plots  == 1
        export_fig forcing.png -r300
    end

    
    figure(4)
    clf
    clear leg
    clear h
    hold all
    h(1) = histogram(Exact_u,30,'Normalization','probability');
    h(2) = histogram(Kpred,30,'Normalization','probability');
    leg{1} = 'Exact solution $u_2(x)$';
    leg{2} = 'Predictive mean $\overline{u}_2(x)$';
    
    xlabel('$u_{2}(x), \overline{u}_{2}(x)$')
    ylabel('Normalized frequency')
    hl = legend(h,leg,'Location','southoutside');
    set(hl,'Interpreter','latex')
    axis square
    xlim([-1.2,1.2])
    set(gca,'FontSize',24);
    set(gcf, 'Color', 'w');
    if save_plots  == 1
        export_fig histogram.png -r300
    end
    
    D = size(ModelInfo.x1,2);
    figure(5)
    clf
    hold
    temp = [1./exp(ModelInfo.hyp(2:D+1));1./exp(ModelInfo.hyp(D+3:2*D+2))]';
    h = bar(temp);
    set(gca,'XTick',1:D)
    xlim([0,D+1])
    xlabel('Dimension $d=1,\ldots,D$')
    ylabel('ARD weights')
    hl = legend(h,{'High-fidelity','Low-fidelity'},'Location','southoutside');
    set(hl,'Interpreter','latex')
    axis square
    set(gca,'FontSize',24);
    set(gcf, 'Color', 'w');
    if save_plots  == 1
        export_fig ARDweights.png -r300
    end
    
    
elseif dim == 2
    
    Exactplot = griddata(Xts(:,1),Xts(:,2),Exact_u,Xplot,Yplot,'cubic');
    Predplot = griddata(Xts(:,1),Xts(:,2),Kpred,Xplot,Yplot,'cubic');
    Varplot = griddata(Xts(:,1),Xts(:,2),Kvar,Xplot,Yplot,'cubic');
    
    Exactplot_rhs = griddata(Xts(:,1),Xts(:,2),Exact_f,Xplot,Yplot,'cubic');
    Predplot_rhs = griddata(Xts(:,1),Xts(:,2),Kpred_rhs,Xplot,Yplot,'cubic');
    Varplot_rhs = griddata(Xts(:,1),Xts(:,2),Kvar_rhs,Xplot,Yplot,'cubic');
    
    EH = griddata(Xts(:,1),Xts(:,2),Exact_f,Xplot,Yplot,'cubic');
    EL = griddata(Xts(:,1),Xts(:,2),Exact_rhs_L,Xplot,Yplot,'cubic');
    
    
    figure(1)
    clf
    hold
    
    s1 = surf(Xplot,Yplot,Predplot+1.5);
    set(s1,'FaceColor',[100,100,100]/255,'EdgeColor',[100,100,100]/255, 'LineWidth',0.001,'FaceAlpha',0.1);
    
    contour(Xplot,Yplot,Exactplot,20);
    
    plot3(ModelInfo.x0(:,1), ModelInfo.x0(:,2), ModelInfo.u0+1.5,'s', 'MarkerFaceColor','m', 'MarkerSize',10);
    view(3)
    zz = get(gca,'ZTick');
    set(gca,'ZTickLabel',sprintf('%3.1f\n',zz-1.5));
    
    buf = cell(1,3);
    if time_dep == 1
        buf{1} = 'GP posterior mean $\overline{u}_{2}(t,x)$';
        buf{2} = 'Exact solution $u_{2}(t,x)$';
        buf{3} = sprintf('Initial/Boundary data (%d points)',size(ModelInfo.x0,1));
    else
        buf{1} = 'GP posterior mean $\overline{u}_{2}(x)$';
        buf{2} = 'Exact solution $u_{2}(x)$';
        buf{3} = sprintf('Boundary data (%d points)',size(ModelInfo.x0,1));
    end
    
    hl = legend(buf,'Location','northoutside');
    set(hl,'Interpreter','latex')
    
    if time_dep ==1
        xlabel('$t$')
        ylabel('$x$')
        zlabel('$u_{2}(t,x), \overline{u}_{2}(t,x)$')
    else
        xlabel('$x_1$')
        ylabel('$x_2$')        
        zlabel('$u_{2}(x), \overline{u}_{2}(x)$')
    end
    axis square
    set(gca,'FontSize',24);
    set(gcf, 'Color', 'w');
    if save_plots  == 1
        export_fig solution.png -r300
    end
    
    
    shift = 100;
    figure(2)
    clf
    hold
    
    s1 = surf(Xplot,Yplot,Predplot_rhs+shift);
    set(s1,'FaceColor',[100,100,100]/255,'EdgeColor',[100,100,100]/255, 'LineWidth',0.001,'FaceAlpha',0.35);
    
    contour(Xplot,Yplot,Exactplot_rhs,20);
    
    s2 = surf(Xplot,Yplot,EL+shift);
    set(s2,'FaceColor',[250,159,181]/255,'EdgeColor',[250,159,181]/255, 'LineWidth',0.001,'FaceAlpha',0.01);
    
    plot3(ModelInfo.x1(:,1), ModelInfo.x1(:,2), ModelInfo.y1+shift,'o', 'MarkerFaceColor',[122,1,119]/255, 'MarkerEdgeColor',[122,1,119]/255,'MarkerSize',6);
    %     plot3(ModelInfo.x2(:,1), ModelInfo.x2(:,2), ModelInfo.y2+shift,'o', 'MarkerFaceColor',[30,30,30]/255, 'MarkerEdgeColor',[30,30,30]/255,'MarkerSize',10);
    plot3(ModelInfo.x2(:,1), ModelInfo.x2(:,2), ModelInfo.y2+shift,'o', 'MarkerFaceColor','r', 'MarkerEdgeColor','r','MarkerSize',10);
    
    view(3)
    zz = get(gca,'ZTick');
    set(gca,'ZTickLabel',sprintf('%3.1f\n',zz-shift));
    
    if time_dep == 1
        buf{1} = 'GP posterior mean $\overline{f}_{2}(t,x)$';
        buf{2} = 'Exact forcing $f_{2}(t,x)$';
        buf{3} = 'Exact forcing $f_{1}(t,x)$';
    else
        buf{1} = 'GP posterior mean $\overline{f}_{2}(x)$';
        buf{2} = 'Exact forcing $f_{2}(x)$';
        buf{3} = 'Exact forcing $f_{1}(x)$';
    end        
    buf{4} = sprintf('Low-fidelity training data (%d points)',size(ModelInfo.x1,1));
    buf{5} = sprintf('High-fidelity training data (%d points)',size(ModelInfo.x2,1));
    
    hl = legend(buf,'Location','northoutside');
    set(hl,'Interpreter','latex')
    
    if time_dep == 1
        xlabel('$t$')
        ylabel('$x$')
        zlabel('$f_{1}(t,x), f_{2}(t,x), \overline{f}_{2}(t,x)$')
    else
        xlabel('$x_1$')
        ylabel('$x_2$')        
        zlabel('$f_{1}(x), f_{2}(x), \overline{f}_{2}(x)$')
    end
    axis square
    set(gca,'FontSize',24);
    set(gcf, 'Color', 'w');
    if save_plots  == 1
        export_fig forcing.png -r300
    end
    
    
    
    figure(3)
    clear h
    clear buf
    clf
    hold
    pcolor(Xplot,Yplot,2*sqrt(Varplot));
    shading interp
    h(1) = plot(ModelInfo.x1(:,1), ModelInfo.x1(:,2), 'o','MarkerFaceColor',[122,1,119]/255, 'MarkerEdgeColor',[122,1,119]/255,'MarkerSize',6);
    h(2) = plot(ModelInfo.x2(:,1), ModelInfo.x2(:,2), 'o','MarkerFaceColor','r', 'MarkerEdgeColor','r','MarkerSize',10);
    h(3) = plot(ModelInfo.x0(:,1), ModelInfo.x0(:,2), 's','MarkerFaceColor','m', 'MarkerEdgeColor','m','MarkerSize',10);
    
    buf{1} = sprintf('Low-fidelity training data (%d points)',size(ModelInfo.x1,1));
    buf{2} = sprintf('High-fidelity training data (%d points)',size(ModelInfo.x2,1));
    buf{3} = sprintf('Boundary data (%d points)',size(ModelInfo.x0,1));
    
    hl = legend(h,buf,'Location','southoutside');
    set(hl,'Interpreter','latex')
    
    title('Two standard deviations');
    colorbar
    if time_dep == 1
        xlabel('$t$')
        ylabel('$x$')
    else
        xlabel('$x_1$')
        ylabel('$x_2$')
    end        
    axis square
    set(gca,'FontSize',24);
    set(gcf, 'Color', 'w');
    if save_plots  == 1
        export_fig variance.png -r300
    end
    
    figure(4)
    clear h
    clear buf
    clf
    hold
    pcolor(Xplot,Yplot,abs(Exactplot - Predplot));
    shading interp
    h(1) = plot(ModelInfo.x1(:,1), ModelInfo.x1(:,2), 'o','MarkerFaceColor',[122,1,119]/255, 'MarkerEdgeColor',[122,1,119]/255,'MarkerSize',6);
    h(2) = plot(ModelInfo.x2(:,1), ModelInfo.x2(:,2), 'o','MarkerFaceColor','r', 'MarkerEdgeColor','r','MarkerSize',10);
    h(3) = plot(ModelInfo.x0(:,1), ModelInfo.x0(:,2), 's','MarkerFaceColor','m', 'MarkerEdgeColor','m','MarkerSize',10);
    
    buf{1} = sprintf('Low-fidelity training data (%d points)',size(ModelInfo.x1,1));
    buf{2} = sprintf('High-fidelity training data (%d points)',size(ModelInfo.x2,1));
    if time_dep == 1
        buf{3} = sprintf('Initial/Boundary data (%d points)',size(ModelInfo.x0,1));
    else
        buf{3} = sprintf('Boundary data (%d points)',size(ModelInfo.x0,1));
    end
    
    hl = legend(h,buf,'Location','southoutside');
    set(hl,'Interpreter','latex')
    
    title('Absolute error');
    colorbar
    if time_dep == 1
        xlabel('$t$')
        ylabel('$x$')
    else
        xlabel('$x_1$');
        ylabel('$x_2$');
    end
    axis square
    set(gca,'FontSize',24);
    set(gcf, 'Color', 'w');
    if save_plots  == 1
        export_fig error.png -r300
    end
    
    %     figure(5)
    %     clf
    %     hold
    % %     pcolor(Xplot,Yplot,corr(EH,EL));
    % %     shading interp
    % %     colorbar
    %     h(1) = plot(Exact_rhs_L, Exact_rhs_H,'bo','LineWidth',1);
    %     h(2) = plot(Exact_rhs_H, Exact_rhs_H,'k','LineWidth',1);
    %     xlabel('$f_{1}(x)$');
    %     ylabel('$f_{2}(x)$');
    %     title('$f_{1}(x),f_{2}(x)$ Cross-correlation');
    %     axis square
    %     set(gca,'FontSize',48);
    %     set(gca,'Xtick',[]);
    %     set(gca,'Ytick',[]);
    %     set(gcf, 'Color', 'w');
    %     if save_plots  == 1
    %         export_fig correlation.png -r300
    %     end
    
    %
    %     figure(3)
    %     clf
    %     hold
    %     contourf(Xplot,Yplot,abs(Exactplot - Predplot));
    %     scatter(ModelInfo.x1(:,1), ModelInfo.x1(:,2), 'r*');
    %     scatter(ModelInfo.x2(:,1), ModelInfo.x2(:,2), 'g*');
    %     colorbar
    %     title('Absolute error');
    %     axis square
    %
    %
    %     figure(4)
    %     clf
    %     hold
    %
    %     s1=surf(Xplot,Yplot,Exactplot_rhs);
    %     set(s1,'FaceColor',[0.0 0.2 0.0],'FaceAlpha',0.6);
    %     s2=surf(Xplot,Yplot,Predplot_rhs);
    %     set(s2,'FaceColor',[0 0 1],'FaceAlpha',0.6);
    %     legend('Exact RHS', 'Prediction RHS');
    %     title('RHS prediction');
    %     axis square
    %
    %     figure(5)
    %     clf
    %     hold
    %     contourf(Xplot,Yplot,Varplot_rhs);
    %     scatter(ModelInfo.x1(:,1), ModelInfo.x1(:,2), 'r*');
    %     scatter(ModelInfo.x2(:,1), ModelInfo.x2(:,2), 'g*');
    %     title('RHS variance');
    %     colorbar
    %     axis square
    
end


