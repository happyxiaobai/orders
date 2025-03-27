function ret=NSGA3()

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

%% 初始化种群并计算适应度值
[pop,fitness]=initial(popsize);


%% 理想点
global Zmin
Zmin=min(fitness);
His=[];
%% 迭代优化
for iter=1:iterations
    %% 选择
    MatingPool=Selection();
    MP_pop=pop(MatingPool,:);
    MP_fit=fitness(MatingPool,:);
    %% 进化算法
    [new_pop,new_fitness]=sbx_fun(MP_pop,MP_fit);
    %% 修改理想点
    Zmin=min([Zmin;new_fitness],[],1);
    %% 合并子代和父代
    Combine_pop=[pop;new_pop];
    Combine_fitness=[fitness;new_fitness];
    %% 精英选择策略
    [pop,fitness]=elitism_selection(Combine_pop,Combine_fitness);

        %% 画图
%         drawing_pareto([],fitness)
%         title([num2str(iter),'/',num2str(iterations)]);
%         box on;

%disp(min(fitness))
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
ret.name='NSGAIII';
ret.Best_Fit=Best_Fit;
ret.Best_pop=Best_pop;
ret.F=F;
ret.History=His;