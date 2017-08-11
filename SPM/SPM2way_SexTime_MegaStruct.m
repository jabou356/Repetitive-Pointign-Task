%Determine what signal we compare
clear;clc;close all;

signal={'ShoulderPlane'};
statistic={'Mean'};
project={'Kathryn'};

% data=xlsread('C:\Users\Jason\OneDrive - McGill University\RepetitivePointingTask_forJason\GroupData\Analyses\MegaDatabase.xlsx'...
% ,'RawDatabase1D','K3:HB529');
% 
% [~,signalxl,~]=xlsread('C:\Users\Jason\OneDrive - McGill University\RepetitivePointingTask_forJason\GroupData\Analyses\MegaDatabase.xlsx'...
% ,'RawDatabase1D','I3:I529');
% 
% [~,statisticxl,~]=xlsread('C:\Users\Jason\OneDrive - McGill University\RepetitivePointingTask_forJason\GroupData\Analyses\MegaDatabase.xlsx'...
% ,'RawDatabase1D','J3:J529');
% 
% [~,projectxl,~]=xlsread('C:\Users\Jason\OneDrive - McGill University\RepetitivePointingTask_forJason\GroupData\Analyses\MegaDatabase.xlsx'...
% ,'RawDatabase1D','D3:D529');
% 
% subjectxl=xlsread('C:\Users\Jason\OneDrive - McGill University\RepetitivePointingTask_forJason\GroupData\Analyses\MegaDatabase.xlsx'...
% ,'RawDatabase1D','B3:B529');
% 
% timexl=xlsread('C:\Users\Jason\OneDrive - McGill University\RepetitivePointingTask_forJason\GroupData\Analyses\MegaDatabase.xlsx'...
% ,'RawDatabase1D','C3:C529');
% 
% sexxl=xlsread('C:\Users\Jason\OneDrive - McGill University\RepetitivePointingTask_forJason\GroupData\Analyses\MegaDatabase.xlsx'...
% ,'RawDatabase1D','E3:E529');



% Y=data(strcmp(signalxl,signal)&strcmp(statisticxl,statistic)&strcmp(projectxl,project),:);
% A=sexxl(strcmp(signalxl,signal)&strcmp(statisticxl,statistic)&strcmp(projectxl,project));
% B=timexl(strcmp(signalxl,signal)&strcmp(statisticxl,statistic)&strcmp(projectxl,project));
% SUBJ=subjectxl(strcmp(signalxl,signal)&strcmp(statisticxl,statistic)&strcmp(projectxl,project));

Y=data(strcmp(signalxl,signal)&strcmp(statisticxl,statistic),:);
A=sexxl(strcmp(signalxl,signal)&strcmp(statisticxl,statistic));
B=timexl(strcmp(signalxl,signal)&strcmp(statisticxl,statistic));
SUBJ=subjectxl(strcmp(signalxl,signal)&strcmp(statisticxl,statistic));


valid=find(~isnan(Y(:,1)));
Y=Y(valid,1:100);
A=A(valid);
B=B(valid);
SUBJ=SUBJ(valid);


males=unique(SUBJ(A==1));
females=unique(SUBJ(A==2));
    
npergroup=min([length(males),length(females)]);


A=[A(ismember(SUBJ,males(1:npergroup)));A(ismember(SUBJ,females(1:npergroup)))];
B=[B(ismember(SUBJ,males(1:npergroup)));B(ismember(SUBJ,females(1:npergroup)))];
Y=[Y(ismember(SUBJ,males(1:npergroup)),:);Y(ismember(SUBJ,females(1:npergroup)),:)];
SUBJ=[SUBJ(ismember(SUBJ,males(1:npergroup)));SUBJ(ismember(SUBJ,females(1:npergroup)))];




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




