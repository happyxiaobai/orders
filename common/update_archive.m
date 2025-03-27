function Archive=update_archive(Archive,pop,fit)
%% 更新archive集合

%% 合并Archive 集和第一序列支配解
combine_pop=[Archive.pop;pop];
combine_fit=[Archive.fit;fit];
[~,ind]=unique(combine_fit,'rows');
combine_pop=combine_pop(ind,:);
combine_fit=combine_fit(ind,:);

%% 非支配排序
[crowding_record1,pareto_record1,F1]=crowding_degree(combine_fit);
%% 保留种群个体 Ar_N 个
if 1%length(F1(1).ss)<=Archive.Ar_N
    index=F1(1).ss;
else
    pr=crowding_record1(F1(1).ss);
    [value_sort,index_sort]=sort(pr,'descend');
    index=F1(1).ss(index_sort(1:Archive.Ar_N));
end

%% 更新 Archive
Archive.pop=combine_pop(index,:);
Archive.fit=combine_fit(index,:);
Archive.N=size(Archive.fit,1);
[Archive.density,Archive.Web_N,Archive.NN]=cal_density(Archive.fit);