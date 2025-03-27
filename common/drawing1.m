function drawing1(D,n)
%% 绘制甘特图
global P
%n=1;
name=D.name;
info=D.F(n).info;
%info=F.info;

%% 读取rgb值
a=xlsread('RGB表.xlsx');
color=a(1:end,:)/255;

%%
figure('Name',[name,'-甘特图-',num2str(n)])
for n=1:size(info,1)
    pos=[info(n,4),info(n,3)-0.4,info(n,5),0.8];
    rectangle('Position',pos,'EdgeColor','k','FaceColor',color(info(n,1),:))
    hold on
    name=[num2str(info(n,1)),'-',num2str(info(n,2))];
    text(pos(1)+pos(3)/3,pos(2)+pos(4)/2,name,'FontSize',15,'FontWeight','bold')
end
%% 设置y轴标签
xname={};
for i=1:max(info(:,3))
    xname{i}=['M',num2str(i)];
end
set(gca,'ytick',1:1:length(xname)) % handles可以指定具体坐标轴的句柄
set(gca,'yticklabel',xname)%改变横坐标
xlabel('时间')
ylabel('机器')
set(gca,'fontsize',15,'fontweight','bold')
ylim([0.5,i+0.5])


