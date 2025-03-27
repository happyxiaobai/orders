function score=cal_score(fit,ref_fit)

%fit=D(1).fit;

%% HV
score(1)=HV(fit,ref_fit);

%% IGD
score(2)=IGD(fit,ref_fit);