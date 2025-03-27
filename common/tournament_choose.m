function [choose_pop,choose_fitness]=tournament_choose(fitness,pop)
%% ������ѡ��ѡ�����
%% ����Ⱥ��ѡ�����ɣ�tournament��������
%% ��ѡ��������ѡ��pareto�ȼ���͵ĸ��壬�ٴ�����ѡȡӵ�������ĸ���

global nvars nfuns choose_size

% ��Ⱥ��Ŀ
popsize=size(fitness,1);

%% ÿ�β����ĸ�����Ŀ
tournament=max(2,round(popsize*0.1));

%% ѡ����ٸ�����
if isempty(choose_size)
    choose_number=round(popsize*0.5);
else
    choose_number=choose_size;
end

%% ����ÿ�������ӵ���ȡ�ÿ�������pareto�ȼ�
[crowding_record,pareto_record]=crowding_degree(fitness);

%% ѡ��
ind=[];
for j=1:choose_number
    
    %% ѡ�����
    index=randperm(popsize,tournament);
    
    %% ������Сpareto�ȼ�
    min_pareto_rank=min(pareto_record(index));
    %% ѡ��pareto_record�ȼ���͸���
    Lowest_pareto_rank_person=index(find(pareto_record(index)==min_pareto_rank));
    
    %% ������Lowest_pareto_rank_person��ѡ��ӵ�������ĸ���
    [~,index]=max(crowding_record(Lowest_pareto_rank_person));
    Hightest_pareto_rank_person=Lowest_pareto_rank_person(index);
    
    %% ��¼ѡ�ĸ���
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

