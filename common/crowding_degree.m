function [crowding_record,pareto_record,F]=crowding_degree(fitness)
%% 计算拥挤度
%% crowding_record：每个个体的拥挤度
%% pareto_record：每个个体的pareto等级
%% F：个体支配排序情况

[popsize,nfuns]=size(fitness);

%% 记录拥挤度
crowding_record=zeros(popsize,1);

%% 快速非支配排序
[F,pareto_record]=Non_dominant_sort(fitness);

%% 对个体拥挤度进行计算

%% 计算每个等级个体的拥挤度
for pareto_rank=1:length(F)
    %% 提取出pareto_rank等级的个体
    pareto_rank_person=F(pareto_rank).ss;
    %% 提取出pareto_rank等级的个体对应的函数值
    pareto_rank_fitness=fitness(pareto_rank_person,:);
    %% pareto_rank等级的个体数目
    pareto_rank_number=length(pareto_rank_person);
    %% 初始化拥挤度=0
    nd=zeros(pareto_rank_number,nfuns);
    
    %% 对每个目标函数进行个体排序
    for ff=1:nfuns
        %% 第ff个目标函数值自小到大排序
        [sort_value,sort_index]=sort(pareto_rank_fitness(:,ff));
        %% 最值
        ff_min=sort_value(1);
        ff_max=sort_value(end);
        %% 将排序后的两个边界的拥挤度设置为inf
        nd(sort_index(1),ff)=inf;
        nd(sort_index(end),ff)=inf;
        
        %% 计算剩余个体的拥挤度
        for j=2:pareto_rank_number-1
            nd(sort_index(j),ff)=(sort_value(j+1)-sort_value(j-1))/(ff_max-ff_min);
        end
    end % 结束ff
    
    %% 记录拥挤度: 对每个个体的nfuns个函数的拥挤度求和
    crowding_record(pareto_rank_person)=sum(nd,2);
    
end %结束pareto_rank

