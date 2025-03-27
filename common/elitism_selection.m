function [elitism_pop,elitism_fitness]=elitism_selection(Combine_pop,Combine_fitness)
%% 精英保留策略
%% 将pareto等级相同的的种群整个放入子代种群中，直到某个等级的的个体不能全部放入
%% 此时，对这个等级的个体，需要计用一定的方法进行取舍
global popsize


%% 精英个体
elitism_person=zeros(popsize,1);

%% 计算每个个体的拥挤度、每个个体的pareto等级、个体支配排序情况
[F,pareto_record]=Non_dominant_sort(Combine_fitness);

%% 已放入子代的个体数目
Ok_number=0;

for pareto_rank=1:length(F)
    %% 计算pareto_rank等级的个体
    pareto_rank_person=F(pareto_rank).ss;
    
    %% 计算pareto_rank等级的个体数目
    pareto_rank_number=length(pareto_rank_person);
    % 如果该等级的个体可以全部放入
    if Ok_number+pareto_rank_number<=popsize
        elitism_person(Ok_number+1:Ok_number+pareto_rank_number)=pareto_rank_person;
        Ok_number=Ok_number+pareto_rank_number;
    else
        
        %%  如果该等级的个体不可以全部放入, 按照策略放入，这是最难的部分
        % 需要多少个体
        remain_number=popsize-Ok_number;
        % 已经选择出来的个体
        ok_person=elitism_person(1:Ok_number);
        % 选择最后一层的个体
        Choose = LastSelection(Combine_fitness(ok_person,:),Combine_fitness(pareto_rank_person,:),remain_number);
        %Choose = LastSelection_knee(Combine_fitness(ok_person,:),Combine_fitness(pareto_rank_person,:),remain_number);
        % 
        elitism_person(Ok_number+1:end)=pareto_rank_person(Choose);
        
      
        Ok_number=popsize;
    end
    
    %% 放满则跳出循环
    if Ok_number==popsize
        break;
    end
    
end

%% 记录选择的精英
if ~isstruct(Combine_pop)
elitism_pop=Combine_pop(elitism_person,:);
else
elitism_pop=Combine_pop(elitism_person);
end
elitism_fitness=Combine_fitness(elitism_person,:);

