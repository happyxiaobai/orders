function ret=mutate(pop)
%% 多项式变异
global popmin popmax mp iter
%pop=Crosspop;

%mp=MP(iter);

%% 分布指数
etam=2;

ret=pop;

%% 规模
[N,D]=size(pop);

%%
for n=1:N
    
    judge=0;
    while judge==0
        x=pop(n,:);
        
        %%
        delta1=(x-popmin)./(popmax-popmin);
        delta2=(popmax-x)./(popmax-popmin);
        
        %% 选择变异的位置
        pos=(rand(1,D)<mp);
        %% 产生随机数
        mu=rand(1,D);
        
        %% <=0.5的
        index=pos&(mu<=0.5);
        mu1=mu(index);
        delta=(2*mu1+(1-2*mu1).*((1-delta1(index)).^((etam+1)))).^(1/(etam+1))-1;
        x(index)=x(index)+delta*(popmax-popmin);
        
        %% >0.5的
        index=pos&(mu>0.5);
        mu1=mu(index);
        delta=1-(2*(1-mu1)+2*(mu1-0.5).*((1-delta2(index)).^((etam+1)))).^(1/(etam+1));
        x(index)=x(index)+delta*(popmax-popmin);
        %% 修正
        x=modify(x);
        judge=test(x);
    end
    
    ret(n,:)=x;
end