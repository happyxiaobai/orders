function Choose = LastSelection(PopObj1,PopObj2,K)
% ���һ��ĸ���ѡ��

% PopObj1=Population_objs(Next,:); % �Ѿ���ѡ��ĸ���
% PopObj2=Population_objs(Last,:); % ���һ���ȼ���ѡ�����
% K=N-sum(Next);

global Zmin Weight nfuns Zmax yes_or_no

Z=Weight;

%% �ϲ���Ⱥ����ȥ Zmin
PopObj = [PopObj1;PopObj2] - Zmin;

%% 
[N,M]  = size(PopObj); 
N1     = size(PopObj1,1);
N2     = size(PopObj2,1);
NZ     = size(Z,1); 

%% Normalization
% ��⼫ֵ��
Extreme = zeros(1,M);
w       = 1e-6+eye(M);
for i = 1 : M
    [~,Extreme(i)] = min(max(PopObj./w(i,:),[],2));
end


%% ���㼫ֵ����ĳ�ƽ��Ľؾ�
% ���볬ƽ��
%Hyperplane = PopObj(Extreme,:)\ones(M,1);
Hyperplane=pinv(PopObj(Extreme,:))*ones(M,1);
a = 1./Hyperplane;
if any(isnan(a))
    a = max(PopObj,[],1)';
end
% ����
a = a'-Zmin;
PopObj = PopObj./a;


% %% ���㵽��ƽ��ľ��룬�ɴ���ȷ��knee��
% % ����ÿ���⵽��ƽ��ľ���
% c=1./a;
% c1=-(sum(Z.*c-1,2))/sqrt(c*c');
% % ������
% [~,index]=max(c1);
% % ����Ȩֵ
% Z=Z+2*rand(1,nfuns).*(Z-Z(index,:));






%% ��ÿ�����������һ���ο��������
% ����ÿ���⵽ÿ���ο������ľ���
% Cosine   = 1 - pdist2(PopObj,Z,'cosine');
% Distance =sqrt(sum(PopObj.^2,2)).*sqrt(1-Cosine.^2);
Distance = pdist2(PopObj,Z,'euclidean');%����ע�͵��������Ҳ����Ŷ
% ����ÿ���������ο������С���룬�Լ���һ���ĸ��ο���
[d,pi] = min(Distance',[],1);
%[d,pi] = min(Distance,[],2);

%% �������front��ÿһ���ο��㣬���������ĸ���
rho = hist(pi(1:N1),1:NZ);

%% ѡ�����
Choose  = false(1,N2); % ��ѡ����ѡ����Щ���� 1 ѡ�� 0 ��ѡ��
Zchoose = true(1,NZ); % �ɹ�ѡ��ĸ���
% 
while sum(Choose) < K
    % ѡ���ӵ���Ĳο���
    Temp = find(Zchoose);
    Jmin = find(rho(Temp)==min(rho(Temp)));
    j    = Temp(Jmin(randi(length(Jmin))));
    I    = find(Choose==0 & pi(N1+1:end)==j);
    % ѡ��������ο�������ĸ���
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

