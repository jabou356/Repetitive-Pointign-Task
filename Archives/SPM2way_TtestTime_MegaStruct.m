%Determine what signal we compare

signal={'ShoulderPlane'};
statistic={'SD'};
project={'Hiram'};

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

Y=data(strcmp(signalxl,signal)&strcmp(statisticxl,statistic)&strcmp(projectxl,project),:);
A=sexxl(strcmp(signalxl,signal)&strcmp(statisticxl,statistic)&strcmp(projectxl,project));
B=timexl(strcmp(signalxl,signal)&strcmp(statisticxl,statistic)&strcmp(projectxl,project));
SUBJ=subjectxl(strcmp(signalxl,signal)&strcmp(statisticxl,statistic)&strcmp(projectxl,project));

% Y=data(strcmp(signalxl,signal)&strcmp(statisticxl,statistic),:);
% A=sexxl(strcmp(signalxl,signal)&strcmp(statisticxl,statistic));
% B=timexl(strcmp(signalxl,signal)&strcmp(statisticxl,statistic));
% SUBJ=subjectxl(strcmp(signalxl,signal)&strcmp(statisticxl,statistic));

valid=find(~isnan(Y(:,1)));
Y=Y(valid,1:100);
A=A(valid);
B=B(valid);
SUBJ=SUBJ(valid);

Y1=Y(B==1,:);
Y2=Y(B==2,:);



%(1) Conduct normality test:
alpha     = 0.05;
spm       = spm1d.stats.normality.ttest_paired(Y1, Y2);
spmi      = spm.inference(0.05);
disp(spmi)


%(2) Plot Normality test:
close all
figure('position', [0 0  1200 300])
subplot(131);  plot(Y1', 'k');  hold on;  plot(Y2', 'r');  title('Data')
subplot(132);  plot(spm.residuals', 'k');  title('Residuals')
subplot(133);  spmi.plot();  title('Normality test')


%(1) Conduct non-parametric test:
rng(0)
alpha      = 0.05;
two_tailed = true;
iterations = 10000;
snpm       = spm1d.stats.nonparam.ttest_paired(Y1, Y2);
snpmi      = snpm.inference(alpha, 'two_tailed', two_tailed, 'iterations', iterations);
disp('Non-Parametric results')
disp( snpmi )


%(2) Compare to parametric inference:
spm        = spm1d.stats.ttest_paired(Y1, Y2);
spmi       = spm.inference(alpha, 'two_tailed',two_tailed);
disp('Parametric results')
disp( spmi )
% plot:

figure('position', [0 0 1000 300])
subplot(121);  spmi.plot();  spmi.plot_threshold_label();  spmi.plot_p_values();
subplot(122);  snpmi.plot(); snpmi.plot_threshold_label(); snpmi.plot_p_values();