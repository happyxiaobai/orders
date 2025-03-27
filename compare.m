clear all;clc;close all;

%%
global P
P=Load_Data();
load D.mat

P.f_name={'F1','F2','F3','F4'};


%% 解集
pareto_solutions = -D.Best_Fit;  % 替换为实际优化结果


% %% 绘制平行坐标图
% figure;
% parallelcoords(pareto_solutions, ...
%     'Labels', P.f_name, ...
%     'Quantile', 0.25, ...       % 显示25%分位数线
%     'Group', rand(length(pareto_solutions),1), ...
%     'Color', [0.2 0.4 0.8], ...% 线条颜色
%     'LineWidth', 1.5);
% title('四目标Pareto解平行坐标图');
% grid on;



%% 使用前三目标作为坐标，第四目标作为颜色
figure;
scatter3(pareto_solutions(:,1), pareto_solutions(:,2), pareto_solutions(:,3), ...
    100, pareto_solutions(:,4), 'filled');  % 40为点大小

% 设置颜色条
colorbar;
colormap(jet);  % 使用jet色图
xlabel(P.f_name{1});
ylabel(P.f_name{2});
zlabel(P.f_name{3});
%title('三维投影（颜色：目标4）');


%% 绘制交互式散点图矩阵
figure;
h=plotmatrix(pareto_solutions);
% axis off;  % 直接关闭坐标轴显示
% set(gca, 'XTick', [], 'YTick', []);  % 移除横纵坐标刻度线
% set(gca, 'XTickLabel', [], 'YTickLabel', []);  % 移除刻度标签（若存在
title('目标函数两两散点图矩阵');
% % 添加标签
% ax = gcf;
% for i = 1:4
%     ax.Children(4*i).YLabel.String = ['目标' num2str(i)];
%     ax.Children(4*i).XLabel.String = ['目标' num2str(i)];
% end
%
power=[1 0 0 0; 0 1 0 0;0 0 1 0; 0 0 0 1;0.3 0.3 0.2 0.2];

%
for k=1:5
    fit=D.Best_Fit;
    fit=(fit-min(fit))./(max(fit)-min(fit))*power(k,:)';
    [~,ind]=min(fit);
    i=ind;
    info=D.Best_pop(i).info;
    [a,~,txt]=xlsread('网格单元.xlsx');
    for i=2:size(info,1)
        txt{i,8}=P.k_name{info(i-1,4)};
    end
    %
    xlswrite(['./结果/',num2str(k),'.xlsx'],txt);
end


