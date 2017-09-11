%Determine what signal we compare
clear;clc;close all;

signal={'Shoulderplane'};
statistic={'Mean'};
%project={'Kathryn'};

GenericPathRPT

load([Path.JBAnalyse, 'GroupData0D.mat']);

Y=[Megadatabase(strcmp(signal{1},[Megadatabase.Signal]) & ...
    strcmp(statistic{1},[Megadatabase.Stat]) & ...
    ~isnan([Megadatabase.ROMFwd])).ROMFwd];

A=[Megadatabase(strcmp(signal{1},[Megadatabase.Signal]) & ...
    strcmp(statistic{1},[Megadatabase.Stat]) & ...
    ~isnan([Megadatabase.ROMFwd])).Sex];

B=[Megadatabase(strcmp(signal{1},[Megadatabase.Signal]) & ...
    strcmp(statistic{1},[Megadatabase.Stat]) & ...
    ~isnan([Megadatabase.ROMFwd])).Time];

SUBJ=[Megadatabase(strcmp(signal{1},[Megadatabase.Signal]) & ...
    strcmp(statistic{1},[Megadatabase.Stat]) & ...
    ~isnan([Megadatabase.ROMFwd])).SubjectID];


%(1) Conduct non-parametric test:
rng(0)     %set the random number generator seed
alpha      = 0.05;
iterations = 500;
FFn        = spm1d.stats.nonparam.anova2onerm(Y, A, B, SUBJ);
FFni       = FFn.inference(alpha, 'iterations', iterations);
disp_summ(FFni)



%(2) Plot:
close all;
FFni.plot('plot_threshold_label',true, 'plot_p_values',true, 'autoset_ylim',true);
FFi        = spm1d.stats.anova2onerm(Y, A, B, SUBJ).inference(alpha);
%%% compare to parametric results by plotting the parametric thresholds:
for i = 1:FFi.nEffects
    Fi = FFi(i);
    subplot(2,2,i);
    hold on
    plot([0 numel(Fi.z)], Fi.zstar*[1 1], 'color','c', 'linestyle','--')
    hold off
    text(5, Fi.zstar, 'Parametric', 'color','k', 'backgroundcolor','c')
end

subplot(2,2,1)
xlabel(['npergroup = ', num2str(npergroup), 'Signal: ', signal, 'StatisticL ', statistic]);




