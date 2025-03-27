clear all;clc;close all;

global P
P=Load_Data();

popsize=500;
pop=[];fitness=[];
for i=1:popsize
    power=randn(P.N,11);
    F=by_cplex(power);
    pop(i,:)=F.x;
    fitness(i,:)=F.fit;

    if mod(i,10)==0
        disp(i)
    end
end


P.pop=pop;
P.fitness=fitness;

save P.mat P

