function Choose = LastSelection(PopObj1,PopObj2,K)
% 最后一层的个体选择

% PopObj1=Population_objs(Next,:); % 已经被选择的个体
% PopObj2=Population_objs(Last,:); % 最后一个等级待选择个体
% K=N-sum(Next);

global Zmin Weight nfuns Zmax yes_or_no

Z=Weight;

%% 合并种群并减去 Zmin
PopObj = [PopObj1;PopObj2] - Zmin;

%% 
[N,M]  = size(PopObj); 
N1     = size(PopObj1,1);
N2     = size(PopObj2,1);
NZ     = size(Z,1); 

%% Normalization
% 检测极值点
Extreme = zeros(1,M);
w       = 1e-6+eye(M);
for i = 1 : M
    [~,Extreme(i)] = min(max(PopObj./w(i,:),[],2));
end


%% 计算极值构造的超平面的截距
% 点与超平面
%Hyperplane = PopObj(Extreme,:)\ones(M,1);
Hyperplane=pinv(PopObj(Extreme,:))*ones(M,1);
a = 1./Hyperplane;
if any(isnan(a))
    a = max(PopObj,[],1)';
end
% 规则化
a = a'-Zmin;
PopObj = PopObj./a;


% %% 计算到超平面的距离，由此来确定knee点
% % 计算每个解到超平面的距离
% c=1./a;
% c1=-(sum(Z.*c-1,2))/sqrt(c*c');
% % 最大距离
% [~,index]=max(c1);
% % 更新权值
% Z=Z+2*rand(1,nfuns).*(Z-Z(index,:));






%% 将每个解决方案与一个参考点相关联
% 计算每个解到每个参考向量的距离
% Cosine   = 1 - pdist2(PopObj,Z,'cosine');
% Distance =sqrt(sum(PopObj.^2,2)).*sqrt(1-Cosine.^2);
Distance = pdist2(PopObj,Z,'euclidean');%上面注释的两个语句也可以哦
% 计算每个个体距离参考点的最小距离，以及对一个哪个参考点
[d,pi] = min(Distance',[],1);
%[d,pi] = min(Distance,[],2);

%% 除了最后front的每一个参考点，计算关联解的个数
rho = hist(pi(1:N1),1:NZ);

%% 选择个体
Choose  = false(1,N2); % 候选解中选择哪些个体 1 选择 0 不选择
Zchoose = true(1,NZ); % 可供选择的个体
% 
while sum(Choose) < K
    % 选择最不拥挤的参考点
    Temp = find(Zchoose);
    Jmin = find(rho(Temp)==min(rho(Temp)));
    j    = Temp(Jmin(randi(length(Jmin))));
    I    = find(Choose==0 & pi(N1+1:end)==j);
    % 选择与这个参考点关联的个体
    if ~isempty(I)
        if rho(j) == 0
            [~,s] = min(d(N1+I));
        else
            s = randi(length(I));
        end
        Choose(I(s)) = true;
        rho(j) = rho(j) + 1;
    else
        Zchoose(j) = false;
    end
end

%% 

