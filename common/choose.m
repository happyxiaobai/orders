function [pop1,fit1]=choose(pop,fitness,N)
%% ����ѡ�����

%% ��ģ
popsize=size(pop,1);
%% ���û��ָ��ѡ����ٸ����������趨Ϊpopsize/2
if nargin<3
    N=popsize/2;
end

%% ����ÿ�������ѡ�����
fit=1./(fitness+eps);
fit=fit./sum(fit);
fit=cumsum(fit);

%% ���̶�ѡ��
a=zeros(1,N);
for n=1:N
    c=rand();
    index=find(fit>=c);
    a(n)=index(1);
end

pop1=pop(a,:);
fit1=fitness(a,:);