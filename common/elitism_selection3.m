function [pop,fitness]=elitism_selection(pop1,fit)
%% ¾«Ó¢±£Áô²ßÂÔ
global popsize

[~,index]=sort(fit);
pop=pop1(index(1:popsize),:);
fitness=fit(index(1:popsize),1);
    