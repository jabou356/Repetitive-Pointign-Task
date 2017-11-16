function [ param, nonparam ] = TwoWayAnova_1rm_0D( Megadatabase, signal, statistic, variable)
%TwoWayAnova_1rm_0D Summary of this function goes here
%   Detailed explanation goes here

Y=[Megadatabase(strcmp(signal,[Megadatabase.Signal]) & ...
    strcmp(statistic,[Megadatabase.Stat]) & ...
    ~isnan([Megadatabase.(variable)])).(variable)];

Sex=[Megadatabase(strcmp(signal,[Megadatabase.Signal]) & ...
    strcmp(statistic,[Megadatabase.Stat]) & ...
    ~isnan([Megadatabase.(variable)])).Sex];

Time=[Megadatabase(strcmp(signal,[Megadatabase.Signal]) & ...
    strcmp(statistic,[Megadatabase.Stat]) & ...
    ~isnan([Megadatabase.(variable)])).Time];

SUBJ=[Megadatabase(strcmp(signal,[Megadatabase.Signal]) & ...
    strcmp(statistic,[Megadatabase.Stat]) & ...
    ~isnan([Megadatabase.(variable)])).SubjectID];

%% Validate number of Men and Women
Men=unique(SUBJ(Sex==1));
Women=unique(SUBJ(Sex==2)); 

if length(Men) ~= length(Women)
    
npergroup=min([length(Men), length(Women)]);

Y=Y(ismember(SUBJ, Men(1:npergroup)) | ismember(SUBJ, Women(1:npergroup)));
Sex=Sex(ismember(SUBJ, Men(1:npergroup)) | ismember(SUBJ, Women(1:npergroup)));
Time=Time(ismember(SUBJ, Men(1:npergroup)) | ismember(SUBJ, Women(1:npergroup)));
SUBJ=SUBJ(ismember(SUBJ, Men(1:npergroup)) | ismember(SUBJ, Women(1:npergroup)));

end

%(1) Conduct non-parametric test:
rng(0)     %set the random number generator seed
alpha      = 0.05;
iterations = 10000;
FFn        = spm1d.stats.nonparam.anova2onerm(Y, Sex, Time, SUBJ);
nonparam       = FFn.inference(alpha, 'iterations', iterations);
disp_summ(nonparam)

%% Conduct parametric test
FFp        = spm1d.stats.anova2onerm(Y, Sex, Time, SUBJ);
param       = FFp.inference(alpha);
disp_summ(param)

end

