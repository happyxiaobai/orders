function b=Dominates(x,y)
%% �����֧���ϵ
%% b=1 x��֧��y
b=all(x<=y,2) && any(x<y,2);  % ֧���Ķ���

end