function [F,pareto_record,Dominanted_Number_0,Dominant_Number]=Non_dominant_sort(fitness)
%% ���ٷ�֧������
[popsize,nfuns]=size(fitness);
global P
%% ����ĸ�Ŀ�꺯�������ֵ������Ӹ���
fit=fitness.*P.style;

%% ����ÿ�����屻��������֧��
% ��¼ÿ�����屻������������֧��
Dominanted_Number=zeros(popsize,1);
% ��¼ÿ������֧����Щ����
Dominant_Pop=cell(popsize,1);
% ÿ������֧�������������
Dominant_Number=zeros(popsize,1);
%
for j=1:popsize
    % ��ֵ
    sub=fit-fit(j,:);
    % ���������������Ŀ�꺯�����������ã���֧��
    Dominanted_Number(j)=sum(prod(sub<=0,2) & sum(sub<0,2)~=0);
    % ���������������Ŀ�꺯�����ȸ����֧��ø���
    Dominant_Pop{j}=find(prod(sub>=0,2)==1 & sum(sub>0,2)~=0);
    Dominant_Number(j)=length( Dominant_Pop{j});
end
Dominanted_Number_0=Dominanted_Number;

%% ����ÿ������ķ�֧��ȼ�
% ��¼ÿ���ȼ��ĸ���
F=[];
% ��¼ÿ������ĵȼ�
pareto_record=zeros(popsize,1);
% ��һ���ȼ�
pareto_rank=1;
while 1
    % Ѱ�ұ�֧�����Ϊ0�ĸ���
    a=find(Dominanted_Number==0);
    % ����a�и���ĵȼ�
    pareto_record(a)=pareto_rank;
    % ���¸�֧��ȼ��ĸ���
    F(pareto_rank).ss=a';
    % ��a�и���ı�֧����Ŀ��ȥ1����λ
    Dominanted_Number(a)=Dominanted_Number(a)-1;
    % ��a�и����Ӧ��֧�����ı�֧����Ŀ��ȥ1����λ
    for k=1:length(a)
        Dominanted_Number(Dominant_Pop{a(k)})=Dominanted_Number(Dominant_Pop{a(k)})-1;
    end
    % ����pareto_rank�ȼ�Ϊ��һ��ѭ��
    pareto_rank=pareto_rank+1;
    % ���ȫ�����������ôDominanted_Number��Ӧ��ֵ����Ϊ<0,��ֹͣѭ��
    if sum(Dominanted_Number<0)==popsize
        break;
    end
end


