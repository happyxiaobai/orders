function ind=roulette_choose(tauk)
%% 轮盘赌选择一个出来

tt=cumsum(tauk/sum(tauk));
ind= find(tt>=rand(),1,'first');


