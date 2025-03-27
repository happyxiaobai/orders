%% 循环运行多个算法
clear all;clc;close all

%% 参数设置
global P
P=Load_Data(); % 读取数据

%%
aimFcn=[{@INSGA3}];
%%
S=struct('name',[],'F',[],'Best_Fit',[],'Best_pop',[]);
D=repmat(S,length(aimFcn),1);
%load D.mat
%% 迭代循环
cnt_max = 5; % 每个算法运行5次做对比
for n=1:length(aimFcn)
    % 循环计算多次
    for cnt =1:cnt_max
        % 跑算法
        F=aimFcn{n}();
        % 记录
        D(n).name=F.name; D(n).F{cnt}=F;
        v=min(F.Best_Fit.*P.style,[],1).*P.style;
        fprintf('%s算法,第%d/%d次计算，求得最优解个数为：%d \n',F.name,cnt,cnt_max,length(F.F))
    end
    D(n)=cal_best_fit(D(n));
% 
%     if length(D(n).Best_Fit)>P.popsize
%         global popsize
%         popsize=P.popsize;
%         [D(n).Best_pop,D(n).Best_Fit]=elitism_selection(D(n).Best_pop,D(n).Best_Fit);
%     end
end



%% 保存
save D.mat D

