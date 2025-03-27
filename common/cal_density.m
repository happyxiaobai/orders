function [density,Web_N,NN]=cal_density(fit)
%% �����ܶ���Ϣ
M=30;

nfuns=size(fit,2);

%fit=Archive.fit;
S=size(fit,1);
%% ��ֵ
Min=min(fit,[],1);
Max=max(fit,[],1);

%% �����ģ
dF=(Max-Min)/M+eps;

%% ÿ�����Ӷ�Ӧ��������
Web_N=fix((fit-Min)./dF)+1;

%% ���
NN=sum(Web_N.*[M+1,ones(1,nfuns-1)],2);

%% �����ܶ�
density=zeros(S,1);
for ss=1:S
   density(ss)=sum(NN==NN(ss)); 
end


