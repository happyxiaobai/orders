function [elitism_pop,elitism_fitness,elitism_F_pop]=elitism_selection2(Combine_pop,Combine_fitness,Conbine_F_pop)
%% ��Ӣ��������
%% ��pareto�ȼ���ͬ�ĵ���Ⱥ���������Ӵ���Ⱥ�У�ֱ��ĳ���ȼ��ĵĸ��岻��ȫ������
%% ��ʱ��ԭ�����㷨�ǣ�������ȼ��ĸ��壬����ӵ���ȣ��Ӵ�Сѡȡ��ֱ���Ӵ���Ⱥ����Ϊֹ�����ǻᵼ�½����
%% ��ɢ�Ժ������ǿ��ֱ�۵ľ���ǰ�ؽ���������ҡ����ǸĽ�һ�£�
%% ɾ��ӵ������С�ĵ㣬���¼���ӵ���ȣ����ѭ����ֱ������popsize

global popsize
%% ��Ӣ����
elitism_person=zeros(popsize,1);

%% ����ÿ�������ӵ���ȡ�ÿ�������pareto�ȼ�������֧���������
[crowding_record,pareto_record,F]=crowding_degree(Combine_fitness);


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
        % ����õȼ��ĸ��岻����ȫ������,ѡ��ӵ�������ĸ������
        % ��Ҫ���ٸ���
        remain_number=popsize-Ok_number;
        % ɾ��ӵ������С�ĵ㣬ֱ������popsize
        while length(pareto_rank_person)~=remain_number
            % ����pareto_rank�ȼ��ĸ����Ӧ��ӵ����
            pareto_rank_crowding=crowding_degree(Combine_fitness(pareto_rank_person,:));
            % �ҵ���С��ӵ����ɾ��
            a1=find(pareto_rank_crowding==min(pareto_rank_crowding));
            pareto_rank_person(a1(1))=[];
            pareto_rank_crowding(a1(1))=[];
        end
        
        elitism_person(Ok_number+1:end)=pareto_rank_person;
        Ok_number=popsize;
    end
    
    %% ����������ѭ��
    if Ok_number==popsize
        break;
    end
    
end

%% ��¼ѡ��ľ�Ӣ
elitism_pop=Combine_pop(elitism_person,:);
elitism_fitness=Combine_fitness(elitism_person,:);
% elitism_F_pop={};
% for j=1:length(elitism_person)
% elitism_F_pop{j}=Conbine_F_pop{elitism_person(j)};
% end

