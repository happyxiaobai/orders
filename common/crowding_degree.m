function [crowding_record,pareto_record,F]=crowding_degree(fitness)
%% ����ӵ����
%% crowding_record��ÿ�������ӵ����
%% pareto_record��ÿ�������pareto�ȼ�
%% F������֧���������

[popsize,nfuns]=size(fitness);

%% ��¼ӵ����
crowding_record=zeros(popsize,1);

%% ���ٷ�֧������
[F,pareto_record]=Non_dominant_sort(fitness);

%% �Ը���ӵ���Ƚ��м���

%% ����ÿ���ȼ������ӵ����
for pareto_rank=1:length(F)
    %% ��ȡ��pareto_rank�ȼ��ĸ���
    pareto_rank_person=F(pareto_rank).ss;
    %% ��ȡ��pareto_rank�ȼ��ĸ����Ӧ�ĺ���ֵ
    pareto_rank_fitness=fitness(pareto_rank_person,:);
    %% pareto_rank�ȼ��ĸ�����Ŀ
    pareto_rank_number=length(pareto_rank_person);
    %% ��ʼ��ӵ����=0
    nd=zeros(pareto_rank_number,nfuns);
    
    %% ��ÿ��Ŀ�꺯�����и�������
    for ff=1:nfuns
        %% ��ff��Ŀ�꺯��ֵ��С��������
        [sort_value,sort_index]=sort(pareto_rank_fitness(:,ff));
        %% ��ֵ
        ff_min=sort_value(1);
        ff_max=sort_value(end);
        %% �������������߽��ӵ��������Ϊinf
        nd(sort_index(1),ff)=inf;
        nd(sort_index(end),ff)=inf;
        
        %% ����ʣ������ӵ����
        for j=2:pareto_rank_number-1
            nd(sort_index(j),ff)=(sort_value(j+1)-sort_value(j-1))/(ff_max-ff_min);
        end
    end % ����ff
    
    %% ��¼ӵ����: ��ÿ�������nfuns��������ӵ�������
    crowding_record(pareto_rank_person)=sum(nd,2);
    
end %����pareto_rank

