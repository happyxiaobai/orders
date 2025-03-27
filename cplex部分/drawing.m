function drawing(F)
global P


% 绘制用地类型
color=xlsread('RGB表.xlsx');

info=F.info;
for k=1:11
    ind=(info(:,4)==k);
    cor=P.cor(ind,:);

    plot(cor(:,1),cor(:,2),'.'); hold on

end

%% 绘制站点
cor=P.cor_site;
plot(cor(:,1),cor(:,2),'k','LineWidth',2); hold on;