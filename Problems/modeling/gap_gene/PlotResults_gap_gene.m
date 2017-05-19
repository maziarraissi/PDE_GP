addpath /users/mraissi/export_fig/
set(0,'defaulttextinterpreter','latex')

load('Hb_pred_data.mat')
load('Kr_pred_data.mat')
load('Gt_pred_data.mat')
load('Kni_pred_data.mat')


fig = figure(2);
set(fig,'units','normalized','outerposition',[0 0 1 1])
clf
clear h;
clear leg;
times = [11 24 30 33 37 49 62];
for i = 1:length(times)
    subplot(length(times),2,2*(i-1)+1)
    hold
    ind = x_star(:,1)==times(i);
    
    plot(x_star(ind,2),pred_Hb_star(ind),'--','LineWidth',3,'Color',spring(1))
    [l,h(1)] = boundedline(x_star(ind,2), pred_Hb_star(ind), 2.0*sqrt(var_Hb_star(ind)), ':','alpha','cmap', spring);%,'cmap', color);
    outlinebounds(l,h(1));
    
    plot(x_star(ind,2),pred_Kr_star(ind),'--','LineWidth',3,'Color',summer(1))
    [l,h(2)] = boundedline(x_star(ind,2), pred_Kr_star(ind), 2.0*sqrt(var_Kr_star(ind)), ':','alpha','cmap', summer);%,'cmap', color);
    outlinebounds(l,h(2));
    
    plot(x_star(ind,2),pred_Gt_star(ind),'--','LineWidth',3,'Color',autumn(1))
    [l,h(3)] = boundedline(x_star(ind,2), pred_Gt_star(ind), 2.0*sqrt(var_Gt_star(ind)), ':','alpha','cmap', autumn);%,'cmap', color);
    outlinebounds(l,h(3));
    
    plot(x_star(ind,2),pred_Kni_star(ind),'--','LineWidth',3,'Color',winter(1))
    [l,h(4)] = boundedline(x_star(ind,2), pred_Kni_star(ind), 2.0*sqrt(var_Kni_star(ind)), ':','alpha','cmap', winter);%,'cmap', color);
    outlinebounds(l,h(4));
    
    axis tight
    set(gca,'FontSize',16);
    set(gcf, 'Color', 'w');
    box on
    
    
    subplot(length(times),2,2*i)
    hold
    ind = x_star(:,1) == times(i);

    plot(x_star(ind,2),pred_f_Hb_star(ind),'--','LineWidth',3,'Color',spring(1))
    [l,h(1)] = boundedline(x_star(ind,2), pred_f_Hb_star(ind), 2.0*sqrt(var_f_Hb_star(ind)), ':','alpha','cmap', spring);
    outlinebounds(l,h(1));
    
    plot(x_star(ind,2),pred_f_Kr_star(ind),'--','LineWidth',3,'Color',summer(1))
    [l,h(2)] = boundedline(x_star(ind,2), pred_f_Kr_star(ind), 2.0*sqrt(var_f_Kr_star(ind)), ':','alpha','cmap', summer);
    outlinebounds(l,h(2));
    
    plot(x_star(ind,2),pred_f_Gt_star(ind),'--','LineWidth',3,'Color',autumn(1))
    [l,h(3)] = boundedline(x_star(ind,2), pred_f_Gt_star(ind), 2.0*sqrt(var_f_Gt_star(ind)), ':','alpha','cmap', autumn);%,'cmap', color);
    outlinebounds(l,h(3));
    
    plot(x_star(ind,2),pred_f_Kni_star(ind),'--','LineWidth',3,'Color',winter(1))
    [l,h(4)] = boundedline(x_star(ind,2), pred_f_Kni_star(ind), 2.0*sqrt(var_f_Kni_star(ind)), ':','alpha','cmap', winter);%,'cmap', color);
    outlinebounds(l,h(4)); 
    
    
    axis tight
    set(gca,'FontSize',16);
    set(gcf, 'Color', 'w');
    box on
end

legend(h,{'Hb','Kr','Gt','Kni'},'Orientation','Horizontal')

if save_plots  == 1
    export_fig ./Figs/solution.png -r300
end