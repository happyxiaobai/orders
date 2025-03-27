function Dk=cal_best_fit(Dk)


fit=[]; pop=[]; FF=[];
for j=1:length(Dk.F)
    fit=[fit;Dk.F{j}.Best_Fit];
    pop=[pop,Dk.F{j}.F];
end

%% 删除重复的
[~,index]=unique(fit,'rows');
fit=fit(index,:);
pop=pop(index);

[F,pareto_record]=Non_dominant_sort(fit);

%% 记录第一前沿
Best_Fit=fit(F(1).ss,:);
Best_pop=pop(F(1).ss);

Dk.Best_Fit=Best_Fit;
Dk.Best_pop=Best_pop;