function [new_pop,new_fitness,F_pop]=sbx_fun(pop,fitness)
%% 基础ga算法对种群个体进行优化：
global popsize nvars popmin popmax nfuns  cp mp

%% 锦标赛选择法选择个体
[choose_pop,~]=tournament_choose(fitness,pop);

%% 交叉
cross_pop=choose_pop; 
[N,D]=size(cross_pop);
for j=1:N
    jj=randperm(N,1);
    while jj==j;  jj=randperm(N,1); end
    v=rand(1,D); 
    xj= choose_pop(j,:).*v+ choose_pop(jj,:).*(1-v);
    xj=modify(xj);
    ind=rand(1,D)<cp;
    cross_pop(j,ind)=xj(ind);
end
cross_pop=[cross_pop;choose_pop];

%% 多项式变异
mutate_pop=cross_pop;
for j=1:size(mutate_pop,1)
    ind=rand(1,D)<mp;
    mutate_pop(j,ind)=popmin+(popmax-popmin)*rand(1,sum(ind));
    mutate_pop(j,:)=modify(mutate_pop(j,:));
end

%% 得到新的个体
new_pop=[mutate_pop];
N=size(new_pop,1);
new_fitness=zeros(N,nfuns);
F_pop={};
for j=1:N
    [new_fitness(j,:),F_pop{j}]=fun(new_pop(j,:));
end


