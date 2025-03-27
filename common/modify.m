function ret=modify(x)
%% 对超出范围的x进行修正
global popmin popmax nvars
ret=x;


index=(x<popmin);
ret(index)=popmin+0.5*(popmax-popmin)*rand(1,sum(index));
index=(x>popmax);
ret(index)=popmax-0.5*(popmax-popmin)*rand(1,sum(index));
