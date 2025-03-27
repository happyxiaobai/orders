function b=Dominates(x,y)
%% 计算非支配关系
%% b=1 x非支配y
b=all(x<=y,2) && any(x<y,2);  % 支配解的定义

end