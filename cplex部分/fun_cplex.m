function [fit,F]=fun_cplex(Xik,power,all_k)
global P

%% 每种类型的数量
%fit=sum( Xik.*power,'all');


%% 
fit=0;
Nmin=P.Nnor; % 最小数量
node=P.need_change;
for k=1:P.Nnor
    nor= P.neighbor(node,k); % 邻居
    fit=fit+sum((all_k(node)-all_k(nor)).^2);
end



%% 
F.fit=fit;
F.Xik=Xik;




