function [density,Web_N,NN]=cal_density(fit)
%% 计算密度信息
M=30;

nfuns=size(fit,2);

%fit=Archive.fit;
S=size(fit,1);
%% 最值
Min=min(fit,[],1);
Max=max(fit,[],1);

%% 网格的模
dF=(Max-Min)/M+eps;

%% 每个粒子对应的网格编号
Web_N=fix((fit-Min)./dF)+1;

%% 编号
NN=sum(Web_N.*[M+1,ones(1,nfuns-1)],2);

%% 计算密度
density=zeros(S,1);
for ss=1:S
   density(ss)=sum(NN==NN(ss)); 
end


