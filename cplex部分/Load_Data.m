function P=Load_Data()
%% ��������
addpath(genpath(pwd));
warning off

load P.mat 


P.Nnor=8;
P.neighbor=P.neighbor(:,1:P.Nnor);
P.allN=size(P.info,1);
P.matrix= repmat([1:11],P.N,1);


%% ������0-1���� 0����ת�� 1��ת��
P.x01=P.info(:,4)*0;
P.x01(P.need_change)=1;
% ���е�����
% P.all_k=zeros(P.allN,11);
% for i=1:P.allN
% P.all_k(i,P.info(i,4))=1;
% end
 P.all_k=zeros(P.allN,1);
for i=1:P.allN
    P.all_k(i)=P.info(i,4);
end

%% 
P.s=2500;
% ����ÿ���ڵ㵽����վ���������
a=xlsread('16�����վ�������.xlsx');
P.cor_site=a;
P.dmin= min(pdist2(P.cor,P.cor_site),[],2);

% ����
P.allN=length(P.dmin);

% 
P.Ik=[1.76 5.33 12.33 3.9 1.41];
P.Ak=[0.58 0.58 0.58 0.58 0.58];
P.Fark=[3.1 1.5 3.5 1.4 1.5];
P.Zk=[4.64 0 3.02 6.6];
% ��������������
P.min=[35 12 12 1 1 15 10]/100;
P.max=[40 15 14 5 2 30 15]/100;
% ���е�����������
info=P.info; info(P.need_change,:)=[];
P.ratio=[];
for k=1:11
    P.ratio(k)= sum(info(:,4)==k)/P.allN;
end


% ÿ�ֵȼ�����ת��,���÷���Ȩ��
P.power=zeros(5,7);
P.power(1,[3 1 2 6 7])=[4 3 2 1 0.1];
P.power(2,[1 3 2 6 7])=[4 3 2 1 0.1];
P.power(3,[3 1 2 6 7 4 5])=[5 4 3 2 1 0.2 0.1];
P.power(4,[6 7 4 5 1 3 2])=[4 3 2 1 0.2 0.1 0.01];
P.power(5,[6 7 4 5])=[2 1 0.2 0.1];
P.power=cumsum( P.power./sum(P.power,2),2);

% ���ÿ���ת����Щ��
P.yes=zeros(5,7);
P.yes(1,[3 1 2 6 7])=1;
P.yes(2,[1 3 2 6 7])=1;
P.yes(3,[3 1 2 6 7 4 5])=1;
P.yes(4,[6 7 4 5 1 3 2])=1;
P.yes(5,[6 7 4 5])=1;

% �����Ƕ����ݽ���һЩԤ�����ӿ�����ٶȣ���Ȼ��ѭ���Ļ��������ܲ�������
% ��ȡÿ�����ص�ת��Ȩ��
P.power_k=[];
P.yes_k=zeros(P.N,11);
for i=1:P.N
    j=P.need_change(i);
    P.power_k(i,:)=P.power(P.info(j,2),:);
    P.yes_k(i,1:7)=P.yes(P.info(j,2),:);
    P.yes_k(i,P.info(j,4))=1;
    % 8�� 11����ת��
    if P.info(j,4)==8 || P.info(j,4)==11
        P.yes_k(i,P.info(j,4))=0;
    end
    
end
P.power_k=[zeros(P.N,1),P.power_k];

% ������
P.min_vlaue=[];
P.max_value=[];
for i=1:P.N
    j=P.need_change(i);
    if P.info(j,4)==8 || P.info(j,4)==11 % ȫ��ת��
        P.min_value(1,i)=eps;
        P.max_value(1,i)=1;
    else % ���Բ�ת��
        P.min_value(1,i)=-0.1;
        P.max_value(1,i)=1;
    end
end

% ����
P.need_change_k=P.info(P.need_change,4)';
% ��Щ����ת��
P.need_must= ( P.need_change_k==8 | P.need_change_k==11 );

%% 
P.nvars=P.N;
P.iterations=100; % ��������
P.popsize=80; % ��Ⱥ��ģ
P.popmin=-0.1;
P.popmax=1;
P.nfuns=4;
P.cp=0.7; % �������
P.mp=0.01; % �������
P.style=ones(1,P.nfuns);

x=rand(1,P.nvars);
