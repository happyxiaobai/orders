function [GApop,fitness]=iga_evaluate(GApop,fitness)
%% 改进遗传算法进化操作
%% 选择
Choosepop=choose(GApop,fitness);
%% 交叉
Crosspop=cross(Choosepop);
%% 变异
[Mutatepop]=mutate(Crosspop);
fit3=[];
for i=1:size(Mutatepop,1)
    fit3(i,1)=fun(Mutatepop(i,:));
end
%% 精英保留策略更新父代
[GApop,fitness]=elitism_selection3([GApop;Mutatepop],[fitness;fit3]);


