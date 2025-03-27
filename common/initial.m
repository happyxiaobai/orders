function [pop,fitness]=initial(popsize)
%% 初始化函数
%% pop：初始化个体
%% fitness：初始化适应度值

global popmin popmax  dim nfuns P
nvars=dim;
pop=zeros(popsize,nvars);
fitness=zeros(popsize,nfuns);

%%
for j=1:popsize
    %%
    judge=0;
    while judge==0
        x=popmin+(popmax-popmin).*rand(1,nvars);
        judge=test(x);
    end
    %%
    pop(j,:)=x;
    fitness(j,:)=fun(x);
end