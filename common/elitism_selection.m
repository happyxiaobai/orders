function [elitism_pop,elitism_fitness]=elitism_selection(Combine_pop,Combine_fitness)
%% ��Ӣ��������
%% ��pareto�ȼ���ͬ�ĵ���Ⱥ���������Ӵ���Ⱥ�У�ֱ��ĳ���ȼ��ĵĸ��岻��ȫ������
%% ��ʱ��������ȼ��ĸ��壬��Ҫ����һ���ķ�������ȡ��
global popsize


%% ��Ӣ����
elitism_person=zeros(popsize,1);

%% ����ÿ�������ӵ���ȡ�ÿ�������pareto�ȼ�������֧���������
[F,pareto_record]=Non_dominant_sort(Combine_fitness);

%% �ѷ����Ӵ��ĸ�����Ŀ
Ok_number=0;

for pareto_rank=1:length(F)
    %% ����pareto_rank�ȼ��ĸ���
    pareto_rank_person=F(pareto_rank).ss;
    
    %% ����pareto_rank�ȼ��ĸ�����Ŀ
    pareto_rank_number=length(pareto_rank_person);
    % ����õȼ��ĸ������ȫ������
    if Ok_number+pareto_rank_number<=popsize
        elitism_person(Ok_number+1:Ok_number+pareto_rank_number)=pareto_rank_person;
        Ok_number=Ok_number+pareto_rank_number;
    else
        
        %%  ����õȼ��ĸ��岻����ȫ������, ���ղ��Է��룬�������ѵĲ���
        % ��Ҫ���ٸ���
        remain_number=popsize-Ok_number;
        % �Ѿ�ѡ������ĸ���
        ok_person=elitism_person(1:Ok_number);
        % ѡ�����һ��ĸ���
        Choose = LastSelection(Combine_fitness(ok_person,:),Combine_fitness(pareto_rank_person,:),remain_number);
        %Choose = LastSelection_knee(Combine_fitness(ok_person,:),Combine_fitness(pareto_rank_person,:),remain_number);
        % 
        elitism_person(Ok_number+1:end)=pareto_rank_person(Choose);
        
      
        Ok_number=popsize;
    end
    
    %% ����������ѭ��
    if Ok_number==popsize
        break;
    end
    
end

%% ��¼ѡ��ľ�Ӣ
if ~isstruct(Combine_pop)
elitism_pop=Combine_pop(elitism_person,:);
else
elitism_pop=Combine_pop(elitism_person);
end
elitism_fitness=Combine_fitness(elitism_person,:);

