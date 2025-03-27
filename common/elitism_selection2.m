function [elitism_pop,elitism_fitness,elitism_F_pop]=elitism_selection2(Combine_pop,Combine_fitness,Conbine_F_pop)
%% 精英保留策略
%% 将pareto等级相同的的种群整个放入子代种群中，直到某个等级的的个体不能全部放入
%% 此时，原本的算法是：对这个等级的个体，按照拥挤度，从大到小选取，直到子代种群放满为止，但是会导致结果的
%% 分散性和随机性强，直观的就是前沿解的跳动剧烈。我们改进一下：
%% 删除拥挤度最小的点，重新计算拥挤度，如此循环，直到满足popsize

global popsize
%% 精英个体
elitism_person=zeros(popsize,1);

%% 计算每个个体的拥挤度、每个个体的pareto等级、个体支配排序情况
[crowding_record,pareto_record,F]=crowding_degree(Combine_fitness);


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
        % 如果该等级的个体不可以全部放入,选择拥挤度最大的个体放入
        % 需要多少个体
        remain_number=popsize-Ok_number;
        % 删除拥挤度最小的点，直到满足popsize
        while length(pareto_rank_person)~=remain_number
            % 计算pareto_rank等级的个体对应的拥挤度
            pareto_rank_crowding=crowding_degree(Combine_fitness(pareto_rank_person,:));
            % 找到最小的拥挤度删掉
            a1=find(pareto_rank_crowding==min(pareto_rank_crowding));
            pareto_rank_person(a1(1))=[];
            pareto_rank_crowding(a1(1))=[];
        end
        
        elitism_person(Ok_number+1:end)=pareto_rank_person;
        Ok_number=popsize;
    end
    
    %% 放满则跳出循环
    if Ok_number==popsize
        break;
    end
    
end

%% 记录选择的精英
elitism_pop=Combine_pop(elitism_person,:);
elitism_fitness=Combine_fitness(elitism_person,:);
% elitism_F_pop={};
% for j=1:length(elitism_person)
% elitism_F_pop{j}=Conbine_F_pop{elitism_person(j)};
% end

