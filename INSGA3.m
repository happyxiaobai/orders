function ret=INSGA3()

%% 导入数据
global P
P=Load_Data();

%% NSGA3 算法
%% 参数
global dim popsize iterations popmin popmax nfuns cp mp
dim=P.nvars; % 维度
nfuns=P.nfuns;  % 目标函数个数
popsize=P.popsize; % 种群规模
iterations=P.iterations; % 迭代次数
popmin=P.popmin; % 粒子最小值
popmax=P.popmax; % 粒子最大值
cp=P.cp; % 交叉概率
mp=P.mp; % 变异概率

%% 生成一致性参考解，就是moead算法中的权重系数
global Weight Neighbor
[Weight,Neighbor]=inital_weight();




%% 初始化种群并计算适应度值 -  cplex初始化
% [pop,fitness]=initial(popsize);
% pop=P.pop(1:popsize,:);
% fitness=P.fitness(1:popsize,:);
%[pop,fitness]=elitism_selection(P.pop,P.fitness);
% ind=randperm(size(P.pop,1),popsize);
% pop=P.pop(ind,:);
% fitness=P.fitness(ind,:);
load F.mat
pop=F.x; fitness=F.fit;
for j=2:popsize
    pop(end+1,:)=mutate(F.x);
    fitness(end+1,:)=fun(pop(end,:));
end

%% 理想点
global Zmin
Zmin=min(fitness,[],1);

His=[];
%% 迭代优化
for iter=1:iterations

    %% 2：自适应概率
    cp_base=0.5; cp_max=0.7;
    mp_base=0.001; mp_max=0.01;
    g=0.5;
    m=iter; M=iterations;
    if m<=g*M
        cp=cp_base+m/g/M*(cp_max-cp_base);
        mp=mp_base+m/g/M*(mp_max-mp_base);
    else
        cp=cp_max-(m-g*M)/(1-g)/M*(cp_max-cp_base);
        mp=mp_max-(m-g*M)/(1-g)/M*(mp_max-mp_base);
    end



    %% 选择
    MatingPool=Selection();
    MP_pop=pop(MatingPool,:);
    MP_fit=fitness(MatingPool,:);
    %% 进化算法
    [new_pop,new_fitness]=isbx_fun(MP_pop,MP_fit);
    %% 修改理想点
    Zmin=min([Zmin;new_fitness],[],1);
    %% 合并子代和父代
    Combine_pop=[pop;new_pop];
    Combine_fitness=[fitness;new_fitness];
    %% 精英选择策略
    [pop,fitness]=elitism_selection(Combine_pop,Combine_fitness);

    %% 画图
    %         drawing_pareto([],fitness)
             disp([num2str(iter),'/',num2str(iterations)]);
    %         box on;

    His(iter,:)=min(fitness,[],1);

end


% %% 记录第一前沿
% Fit_F1=fitness;
% pop_F1=pop;

%% 非支配排序
[F,pareto_record]=Non_dominant_sort(fitness);
%% 记录第一前沿
Fit_F1=fitness(F(1).ss,:);
pop_F1=pop(F(1).ss,:);

%% 删除重复的
[~,index]=unique(Fit_F1,'rows');


%% 记录前沿解
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
ret.name='INSGAIII';
ret.Best_Fit=Best_Fit;
ret.Best_pop=Best_pop;
ret.F=F;
ret.History=His;