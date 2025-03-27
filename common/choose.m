function [pop1,fit1]=choose(pop,fitness,N)
%% 轮盘选择操作

%% 规模
popsize=size(pop,1);
%% 如果没有指定选择多少个出来，就设定为popsize/2
if nargin<3
    N=popsize/2;
end

%% 计算每个个体的选择概率
fit=1./(fitness+eps);
fit=fit./sum(fit);
fit=cumsum(fit);

%% 轮盘赌选择
a=zeros(1,N);
for n=1:N
    c=rand();
    index=find(fit>=c);
    a(n)=index(1);
end

pop1=pop(a,:);
fit1=fitness(a,:);