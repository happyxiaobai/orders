function F=Amend(x)
%% 解码：算法最重要的步骤
global P xx


%xx=x.*(P.max_value-P.min_value)+P.min_value;
xx=x; xx(P.need_must)=max(abs(xx(P.need_must)),eps);

%% 每个区域转换成哪些类型
to_k= (xx'-P.power_k(:,1:end-1)>=0) & (xx'-P.power_k(:,2:end)<=0);
to_k=to_k*[1:7]';
% x如果小于等于0不需要转换
change= (xx'>0);

%% 将类型放入到原来的里面去 % 1'序号'	2'潜力等级'	3'潜力等级1'	 4'用地类型'	5'转换规则'	6'X'	7'Y'
info=P.info;
info(P.need_change(change),4)=to_k(change);
% 用地类型
class=info(:,4);

% 提取每个类型的dmax
dmax=zeros(1,5);
for k=1:5
    dmax(k)=max( P.dmin(class==k));
end


%% f1
% 首先计算5种类型的分别的值
V_1=zeros(1,5);
for k=1:5
    V_1(k)= sum( ( 1-P.dmin(class==k)/dmax(k))*P.s );
end
% 然后计算f1
f(1)=V_1(2)/sum(V_1([1 3 4 5]));

%% f2
% 先算每个值
V_2=zeros(1,5);
for k=1:5
    V_2(k)=sum( P.Fark(k)*P.s*P.Ik(k)*P.Ak(k)* ( 1-P.dmin(class==k)/dmax(k)) );
end
%
f(2)=sum(V_2);

%% f3
% 先算每个值
V_3=zeros(1,4);
for k=[1 3 4]
    V_3(k)= P.s* P.Fark(k)*sum(class==k);
end
%
f(3)=sum(V_3);

%% f4
Rk=zeros(1,11);
for k=1:11
    Rk(k)=sum(class==k)/P.allN;
end
f(4)=-sum( Rk.*log(Rk+eps));



%% 这里计算一下相似度
y0= info(P.need_change,4); % 需要规划的类型
y1= P.neighbor(P.need_change,:);
for i=1:P.Nnor
    y1(:,i)= info( P.neighbor(P.need_change,i),4);
end
coeff=mse(y1-y0);

%% 约束，这里主要是利用率的约束
% 比例约束
restraint(1)= sum(max(Rk(1:7)-P.max,0)) + sum(max(P.min-Rk(1:7),0));
% 相似度约束
restraint(2)=max(coeff-11,0);

restraint=round(restraint,3);
%
res=sum(restraint)*1e4;

fit=-f+[10,1e9,1e9,100]*res;
%fit=res;

F=[];
F.fit=fit;
F.f=f;
F.info=info;
F.V1=V_1;
F.V2=V_2;
F.V3=V_3;
F.Rk=Rk;
F.restraint=restraint;
F.x=x;
F.coeff=coeff;
