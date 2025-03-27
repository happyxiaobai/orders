function [new_pop,new_fitness,F_pop]=isbx_fun(pop,fitness)
%% 基础ga算法对种群个体进行优化：
global popsize nvars popmin popmax nfuns 

%% 锦标赛选择法选择个体
[choose_pop,~]=tournament_choose(fitness,pop);

%% 模拟二进制交叉
cross_pop=cross(choose_pop);

%% 多项式变异
mutate_pop=mutate(cross_pop);

%% 得到新的个体
new_pop=[cross_pop;mutate_pop];
N=size(new_pop,1);
new_fitness=zeros(N,nfuns);
F_pop={};
for j=1:N
    [new_fitness(j,:),F_pop{j}]=fun(new_pop(j,:));
end


