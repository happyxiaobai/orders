function [Weight,Neighbor]=inital_weight()
%% 初始化权重向量
global popsize nfuns Vector_Number

%% 权重向量
%% 权重向量
H=10;
%
a=[zeros(1,H),zeros(1,nfuns-1)];
a1=nchoosek(1:length(a),nfuns-1);
a1=flipud(a1);
b=zeros(size(a1,1),length(a));
for i=1:size(a1,1)
    b(i,a1(i,:))=1;
end
%
Weight=[];
%
[n,m]=size(b);
%
for i=1:n
    c=b(i,:);
    w=[];
    s=0;
    for j=1:m
        if c(j)==1
            d=(j-s-1)/H;
            s=j;
            w=[w,d];
        end
    end
    w=[w,1-sum(w)];
    Weight=[Weight;w];
end
Weight(Weight==0)=1e-6;
Weight=Weight./sum(Weight,2);

popsize=size(Weight,1);
%% 领域向量编号 Neighbor
Distance=zeros(popsize,popsize);
% 计算向量之间的距离
for j=1:popsize
    a=Weight-Weight(j,:);
    b=a.^2;
    c=sum(b,2);
    d=sqrt(c);
    Distance(:,j)=d;
end

% 计算每个向量离最近的Vector_Number个体
[~,index]=sort(Distance,2);
Neighbor=index(:,1:Vector_Number);
