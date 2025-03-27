function drawing_pareto(fitness,Best_Fit)
%% 绘制pareto图
global P
nfuns=size(Best_Fit,2);

%% 两个目标函数
if nfuns==2
    pause(0.01)
    clf()
    if length(fitness)~=0
        plot(fitness(:,1),fitness(:,2),'ro')
        hold on
    end
    plot(Best_Fit(:,1),Best_Fit(:,2),'ko','MarkerFaceColor','k','Markersize',5)
    xlabel('Function-1')
    ylabel('Function-2')
    set(gca,'XMinorGrid','on')
    set(gca,'YMinorGrid','on')
    set(gca,'fontsize',10)
end


%% 三个目标函数
if nfuns==3
    pause(0.01)
    clf()
    if length(fitness)~=0
        plot3(fitness(:,1),fitness(:,2),fitness(:,3),'ro')
        hold on
    end
    plot3(Best_Fit(:,1),Best_Fit(:,2),Best_Fit(:,3),'bo','MarkerFaceColor','k','Markersize',4)
    xlabel('fit1')
    ylabel('fit2')
    zlabel('fit3')
    set(gca,'XMinorGrid','on')
    set(gca,'YMinorGrid','on')
    set(gca,'ZMinorGrid','on')
    set(gca,'fontsize',10)
end