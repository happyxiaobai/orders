function [choose_pop,choose_fitness]=tournament_choose(fitness,pop)
%% 锦标赛选择法选择个体
%% 从种群中选出若干（tournament）个个体
%% 从选出个体中选出pareto等级最低的个体，再从其中选取拥挤度最大的个体

global nvars nfuns choose_size

% 种群数目
popsize=size(fitness,1);

%% 每次产生的个体数目
tournament=max(2,round(popsize*0.1));

%% 选择多少个个体
if isempty(choose_size)
    choose_number=round(popsize*0.5);
else
    choose_number=choose_size;
end

%% 计算每个个体的拥挤度、每个个体的pareto等级
[crowding_record,pareto_record]=crowding_degree(fitness);

%% 选择
ind=[];
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
    
    %% 记录选的个体
    ind(end+1)=Hightest_pareto_rank_person;
%     choose_pop(j,:)=pop(Hightest_pareto_rank_person,:);
%     choose_fitness(j,:)=fitness(Hightest_pareto_rank_person,:);
end
if ~isstruct(pop)
choose_pop=pop(ind,:); 
else
    choose_pop=pop(ind);
end
choose_fitness=fitness(ind,:);

