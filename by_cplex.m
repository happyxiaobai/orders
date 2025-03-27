%function F=by_cplex(power)
%%
clear all;clc;close all;
yalmip('clear')
global P
P=Load_Data();
power=ones(P.N,11);

%% 定义变量
% 转那种类型
Xik=binvar(P.N,11,'full');

% 计算所有节点的类型
all_k=sdpvar(P.allN,1);


%% 添加约束
Con=[];
% 定义域
Con=[Con,Xik>=0,Xik<=1,sum(Xik,2)==1,all_k<=11,all_k>=1];


% 可规划区域
%Con=[Con,all_k(P.x01==1,:)-Xik==0];
Con=[Con,all_k(P.x01==1)-Xik*([1:11]')==0];
% 不可规划区域
%Con=[Con,all_k(P.x01==0,:)-P.all_k(P.x01==0,:)==0];
Con=[Con,all_k(P.x01==0)-P.all_k(P.x01==0)==0];



% % 下面这个时最复杂的约束，保持邻居节点的相似性
% Nmin=3; % 最小数量
% % 
% for i=P.need_change'
% %     for k=1:7
% %     Con=[Con,sum( all_k(P.neighbor(i,:),k))-Nmin*all_k(i,k)>=0];
% %     end
%     Con=[Con,sum( all_k(P.neighbor(i,:),:))-Nmin*all_k(i,:)>=0];
% end


% 范围约束
Con=[Con,Xik-P.yes_k<=0];
% 范围约束
ratio=sum(Xik)/P.allN+P.ratio;
Con=[Con,ratio(1:7)-P.max<=0,ratio(1:7)-P.min>=0];
%% 定义函数
Objective=fun_cplex(Xik,power,all_k);


%% 设置选项（方法等）
options = sdpsettings('verbose',2,'solver','cplex');
%options.threads = 32; % 根据CPU核心数调整
options.cplex.timelimit=3600*10; % 最大时间（秒）
% options.threads = 8;                    % 使用8线程
% options.lpmethod = 4;                   % 内点法
% options.mip.strategy.nodeselect = 3;    % 动态节点选择策略

%% 求解
sol=optimize(Con,Objective,options);
disp( sol.info )


%%
Xik=value(Xik);
all_k=value(all_k);
%% 计算载荷率
info=P.info;
for i=1:P.N
    j=P.need_change(i);
    ind=find(Xik(i,:)>=0.95);
    info(j,4)=ind;
end
% 计算比例
for k=1:11
    ratio(k)= sum(info(:,4)==k)/P.allN;
end
% 是否符合约束
res= sum( max(ratio(1:7)-P.max,0)+max(P.min-ratio(1:7),0) );
% 下面是将其转成遗传的染色体形式
x=zeros(1,P.N);
for i=1:P.N
    j=P.need_change(i);
    k=info(j,4); % 方式
    % 如果运输方式没有变,就是-0.1~0之间
    if k==P.info(j,4)
        x(i)=rand()*P.popmin;
    else % 变了，选择一个
        x(i)=P.power_k(i,k)+(P.power_k(i,k+1)-P.power_k(i,k))*rand();
    end
end
%x=(x-P.min_value)./(P.max_value-P.min_value);
%% 计算一下
F=Amend(x);
%F.all_k=all_k;

drawing(F)

save F.mat F
