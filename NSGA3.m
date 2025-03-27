function ret=NSGA3()

%% ��������
global P
P=Load_Data();

%% NSGA3 �㷨
%% ����
global dim popsize iterations popmin popmax nfuns cp mp
dim=P.nvars; % ά��
nfuns=P.nfuns;  % Ŀ�꺯������
popsize=P.popsize; % ��Ⱥ��ģ
iterations=P.iterations; % ��������
popmin=P.popmin; % ������Сֵ
popmax=P.popmax; % �������ֵ
cp=P.cp; % �������
mp=P.mp; % �������

%% ����һ���Բο��⣬����moead�㷨�е�Ȩ��ϵ��
global Weight Neighbor
[Weight,Neighbor]=inital_weight();

%% ��ʼ����Ⱥ��������Ӧ��ֵ
[pop,fitness]=initial(popsize);


%% �����
global Zmin
Zmin=min(fitness);
His=[];
%% �����Ż�
for iter=1:iterations
    %% ѡ��
    MatingPool=Selection();
    MP_pop=pop(MatingPool,:);
    MP_fit=fitness(MatingPool,:);
    %% �����㷨
    [new_pop,new_fitness]=sbx_fun(MP_pop,MP_fit);
    %% �޸������
    Zmin=min([Zmin;new_fitness],[],1);
    %% �ϲ��Ӵ��͸���
    Combine_pop=[pop;new_pop];
    Combine_fitness=[fitness;new_fitness];
    %% ��Ӣѡ�����
    [pop,fitness]=elitism_selection(Combine_pop,Combine_fitness);

        %% ��ͼ
%         drawing_pareto([],fitness)
%         title([num2str(iter),'/',num2str(iterations)]);
%         box on;

%disp(min(fitness))
    His(iter,:)=min(fitness,[],1);

end


% %% ��¼��һǰ��
% Fit_F1=fitness;
% pop_F1=pop;

%% ��֧������
[F,pareto_record]=Non_dominant_sort(fitness);
%% ��¼��һǰ��
Fit_F1=fitness(F(1).ss,:);
pop_F1=pop(F(1).ss,:);

%% ɾ���ظ���
[~,index]=unique(Fit_F1,'rows');


%% ��¼ǰ�ؽ�
Best_Fit=Fit_F1(index,:);
Best_pop=pop_F1(index,:);
[~,F]=fun(Best_pop(1,:));
n=0;
for j=1:size(Best_pop,1)
    [~,c]=fun(Best_pop(j,:));
    %Best_Fit(j,:)=c.y_test;
    n=n+1;
    F(n)=c;
end



%% 
ret=[];
ret.name='NSGAIII';
ret.Best_Fit=Best_Fit;
ret.Best_pop=Best_pop;
ret.F=F;
ret.History=His;