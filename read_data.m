%function P=read_data()
%% 导入数据
addpath(genpath(pwd));
warning off

P=[];


%% 读取数据
file='网格单元.xlsx';
[data,~,txt]=xlsread(file);
% 节点坐标
P.cor=data(:,6:7);
% 节点数量
P.N=size(data,1);

%
[~,~,a]=xlsread('参数数据.xlsx','用地类型');
P.k_name=a(2:end)';

% 每种类型可以转换哪些类型
P.k_2_k{1}=[2 3 4 5 6 7];
P.k_2_k{2}=[1 3 4 5 6 7];
P.k_2_k{3}=[1 2 4 5 6 7];
P.k_2_k{4}=[1 2 3 5 6 7];
P.k_2_k{5}=[1 2 3 4 6 7];
P.k_2_k{6}=[1 2 3 4 5 7];
P.k_2_k{7}=[];
P.k_2_k{8}=[1 2 3 4 5 6 7];
P.k_2_k{9}=[1 2 3 4 5 6 7];
P.k_2_k{10}=[];
P.k_2_k{11}=[1 2 3 4 5 6 7];
P.k_2_k{12}=[];


% 将文字转成数字
for i=2:size(txt,1)
    % 级别
    j=2;
    if  contains( txt{i,j},'Ⅰ级')
        txt{i,j}=1;
    elseif contains( txt{i,j},'Ⅱ级')
        txt{i,j}=2;
    elseif contains( txt{i,j},'Ⅲ级')
        txt{i,j}=3;
    elseif contains( txt{i,j},'Ⅳ级')
        txt{i,j}=4;
    elseif contains( txt{i,j},'Ⅴ级')
        txt{i,j}=5;
    end

    % 潜力
    j=3;
    if  contains( txt{i,j},'低潜力')
        txt{i,j}=1;
    elseif contains( txt{i,j},'较低潜力')
        txt{i,j}=2;
    elseif contains( txt{i,j},'中等潜力')
        txt{i,j}=3;
    elseif contains( txt{i,j},'较高潜力')
        txt{i,j}=4;
    elseif contains( txt{i,j},'高潜力')
        txt{i,j}=5;
    end

    % 用地类型
    j=4;
    for k=1:length(P.k_name)
        if contains(P.k_name{k},txt{i,j})
            txt{i,j}=k;
            break;
        end
    end

    % 转换规则
    j=5;
    if  contains( txt{i,j},'允许转换')
        txt{i,j}=1;
    elseif contains( txt{i,j},'禁止转换')
        txt{i,j}=0;
    end
end

% 用地信息
% 1'序号'	2'潜力等级'	3'潜力等级1'	 4'用地类型'	5'转换规则'	6'X'	7'Y'
P.info=cell2mat(txt(2:end,:));

% 提取哪些需要转换
P.need_change=find(P.info(:,5)==1);
%
%class=tabulate(P.info(P.need_change,4))
%
P.N=length(P.need_change);

% 计算邻居，取最近的16个作为自己的邻居
P.neighbor=zeros(size(P.info,1),16);
for i=1:size(P.info,1)
    [~,di]=sort( pdist2(P.cor,P.cor(i,:)) );
    P.neighbor(i,:)=di(2:17);
end



%%
P.nvars=P.N;
P.iterations=100; % 迭代次数
P.popsize=80; % 种群规模
P.popmin=eps();
P.popmax=1;
P.nfuns=3;
P.cp=0.7; % 交叉概率
P.mp=0.01; % 变异概率
P.style=ones(1,P.nfuns);

x=rand(1,P.nvars);


save P.mat P
