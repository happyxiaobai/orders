function [F,pareto_record,Dominanted_Number_0,Dominant_Number]=Non_dominant_sort(fitness)
%% 快速非支配排序
[popsize,nfuns]=size(fitness);
global P
%% 如果哪个目标函数求最大值，则添加负号
fit=fitness.*P.style;

%% 计算每个个体被几个个体支配
% 记录每个个体被多少其他个体支配
Dominanted_Number=zeros(popsize,1);
% 记录每个个体支配哪些个体
Dominant_Pop=cell(popsize,1);
% 每个个体支配多少其他个体
Dominant_Number=zeros(popsize,1);
%
for j=1:popsize
    % 差值
    sub=fit-fit(j,:);
    % 如果其他个体两个目标函数都比他更好，则被支配
    Dominanted_Number(j)=sum(prod(sub<=0,2) & sum(sub<0,2)~=0);
    % 如果其他个体两个目标函数都比更差，则支配该个体
    Dominant_Pop{j}=find(prod(sub>=0,2)==1 & sum(sub>0,2)~=0);
    Dominant_Number(j)=length( Dominant_Pop{j});
end
Dominanted_Number_0=Dominanted_Number;

%% 计算每个个体的非支配等级
% 记录每个等级的个体
F=[];
% 记录每个个体的等级
pareto_record=zeros(popsize,1);
% 第一个等级
pareto_rank=1;
while 1
    % 寻找被支配个数为0的个体
    a=find(Dominanted_Number==0);
    % 更新a中个体的等级
    pareto_record(a)=pareto_rank;
    % 更新各支配等级的个体
    F(pareto_rank).ss=a';
    % 将a中个体的被支配数目减去1个单位
    Dominanted_Number(a)=Dominanted_Number(a)-1;
    % 将a中个体对应的支配个体的被支配数目减去1个单位
    for k=1:length(a)
        Dominanted_Number(Dominant_Pop{a(k)})=Dominanted_Number(Dominant_Pop{a(k)})-1;
    end
    % 增加pareto_rank等级为下一次循环
    pareto_rank=pareto_rank+1;
    % 如果全部计算完毕那么Dominanted_Number对应的值都变为<0,则停止循环
    if sum(Dominanted_Number<0)==popsize
        break;
    end
end


