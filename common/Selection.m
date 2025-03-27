function MatingPool=Selection(fitness)
%% 竞标赛选择
global popsize
Number=ceil(popsize/4)*4;

MatingPool=randi(popsize,1,Number);


%{
%% 锦标赛选择法选择个体
%% 从种群中选出若干（tournament）个个体
%% 从选出个体中选出pareto等级最低的个体，再从其中选取拥挤度最大的个体

global nvars nfuns

%% 每次产生的个体数目
tournament=round(popsize*0.1);

%% 选择多少个个体
choose_number=Number;
choose_pop=zeros(choose_number,nvars);
choose_fitness=zeros(choose_number,nfuns);


%% 计算每个个体的拥挤度、每个个体的pareto等级
[crowding_record,pareto_record]=crowding_degree(fitness);

%% 选择
for j=1:choose_number
    
    %% 选择个体
    index=randperm(popsize,tournament);
    
    %% 计算最小pareto等级
   min_pareto_rank=min(pareto_record(index));
    %% 选出pareto_record等级最低个体
    Lowest_pareto_rank_person=index(find(pareto_record(index)==min_pareto_rank));
    
    %% 继续从Lowest_pareto_rank_person中选择拥挤度最大的个体
   [~,index]=max(crowding_record(Lowest_pareto_rank_person));
   Hightest_pareto_rank_person=Lowest_pareto_rank_person(index);
   
  MatingPool(j)=Hightest_pareto_rank_person;
    
end
%}
