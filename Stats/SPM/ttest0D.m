function [ param, nonparam ] = ttest0D( Megadatabase, signal, statistic, variable)
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
Men=unique(SUBJ(Sex==1)); Men = Men(randperm(length(Men)));
Women=unique(SUBJ(Sex==2)); Women = Women(randperm(length(Women)));
  
npergroup=min([length(Men), length(Women)]);

Ymen=Y(ismember(SUBJ, Men(1:npergroup)) & Time == 1);
Ywomen=Y(ismember(SUBJ, Women(1:npergroup)) & Time == 1);

% conduct non-parametric test
rng(0)
alpha      = 0.05;
two_tailed = true;
iterations = 1000;
snpm       = spm1d.stats.nonparam.ttest2(Ymen, Ywomen);
nonparam      = snpm.inference(alpha, 'two_tailed', two_tailed, 'iterations', iterations);
disp('Non-Parametric results')
disp( nonparam )   



%% Conduct parametric test

spm        = spm1d.stats.ttest_paired(Ymen, Ywomen);
param       = spm.inference(alpha, 'two_tailed',two_tailed);
disp('Parametric results')
disp( param )

end

