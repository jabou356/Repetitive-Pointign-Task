%Determine what signal we compare
clear;clc;close all;

signal={'ShoulderPlane'};
statistic={'SD'};
project={'Kathryn'};

data=xlsread('C:\Users\Jason\OneDrive - McGill University\RepetitivePointingTask_forJason\GroupData\Analyses\MegaDatabase.xlsx'...
,'RawDatabase1D','K3:HB529');

[~,signalxl,~]=xlsread('C:\Users\Jason\OneDrive - McGill University\RepetitivePointingTask_forJason\GroupData\Analyses\MegaDatabase.xlsx'...
,'RawDatabase1D','I3:I529');

[~,statisticxl,~]=xlsread('C:\Users\Jason\OneDrive - McGill University\RepetitivePointingTask_forJason\GroupData\Analyses\MegaDatabase.xlsx'...
,'RawDatabase1D','J3:J529');

[~,projectxl,~]=xlsread('C:\Users\Jason\OneDrive - McGill University\RepetitivePointingTask_forJason\GroupData\Analyses\MegaDatabase.xlsx'...
,'RawDatabase1D','D3:D529');

subjectxl=xlsread('C:\Users\Jason\OneDrive - McGill University\RepetitivePointingTask_forJason\GroupData\Analyses\MegaDatabase.xlsx'...
,'RawDatabase1D','B3:B529');

timexl=xlsread('C:\Users\Jason\OneDrive - McGill University\RepetitivePointingTask_forJason\GroupData\Analyses\MegaDatabase.xlsx'...
,'RawDatabase1D','C3:C529');

sexxl=xlsread('C:\Users\Jason\OneDrive - McGill University\RepetitivePointingTask_forJason\GroupData\Analyses\MegaDatabase.xlsx'...
,'RawDatabase1D','E3:E529');

% Y=data(strcmp(signalxl,signal)&strcmp(statisticxl,statistic)&strcmp(projectxl,project),:);
% A=sexxl(strcmp(signalxl,signal)&strcmp(statisticxl,statistic)&strcmp(projectxl,project));
% B=timexl(strcmp(signalxl,signal)&strcmp(statisticxl,statistic)&strcmp(projectxl,project));
% SUBJ=subjectxl(strcmp(signalxl,signal)&strcmp(statisticxl,statistic)&strcmp(projectxl,project));

Y=data(strcmp(signalxl,signal)&strcmp(statisticxl,statistic),:);
A=sexxl(strcmp(signalxl,signal)&strcmp(statisticxl,statistic));
B=timexl(strcmp(signalxl,signal)&strcmp(statisticxl,statistic));
SUBJ=subjectxl(strcmp(signalxl,signal)&strcmp(statisticxl,statistic));


valid=find(~isnan(Y(:,1)));
Y=Y(valid,:);
A=A(valid);
B=B(valid);
SUBJ=SUBJ(valid);

H=find(A==1);
F=find(A==2);
nH=length(H);
nF=length(F);
npergroup=min([nH,nF]);

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
xlabel(['nH = ', num2str(nH), ' nF =', num2str(nF), ' Signal: ', signal, 'StatisticL ', statistic]);




