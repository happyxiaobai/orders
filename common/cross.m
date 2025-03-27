function ret=cross(pop)
%% ģ�¶����ƽ���
global popsize cp

eta=2;
%cp=CP(iter);
%pop=Choosepop;

%% ��ģ
[N,D]=size(pop);

%% ��������
a=randperm(N,N);
pop=pop(a,:);

%% ��һ��
parent1=pop(1:floor(N/2),:);
parent2=pop(1+floor(N/2):N,:);

%%
NN=size(parent1,1);
%% �Ӵ�
child1=zeros(NN,D);
child2=zeros(NN,D);


for n=1:NN
    judge=0;
    while judge==0
        %% beta
        beta=zeros(1,D);
        %% �����
        mu=rand(1,D);
        %% ����beta
        % <=0.5
        a1=(mu<=0.5);
        beta(a1)=(mu(a1)*2).^(1./(1+eta));
        % >0.5
        a2=(mu>0.5);
        beta(a2)=(2-mu(a2)*2).^(-1./(1+eta));
        % ����ӻ��
        beta=beta.*((-1).*randi([0,1],1,D));
        % ���ո��ʱ�Ϊ1�����������˼��������>cp
        beta(rand(1,D)>cp)=1;
        
        %% ����
        x1=0.5*((1+beta).*parent1(n,:)+(1-beta).*parent2(n,:));
        x1=modify(x1);
        x2=0.5*((1-beta).*parent1(n,:)+(1+beta).*parent2(n,:));
        x2=modify(x2);
        judge=test(x1)&&test(x2);
    end
    
    child1(n,:)=x1;
    child2(n,:)=x2;
    
end

ret=[child1;child2;pop];
