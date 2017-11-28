close all
clear 
figure('Units', 'centimeters','Position', [1.5, 1, 16.5, 22]);

load('GroupData1D.mat')
Signals={'Shoulderplane';'ShoulderElev';'ElbowFlex';'TrunkRy';'TrunkRz';'TrunkRx'};
Statistic={'SD'};

for i=length(Megadatabase):-1:1
    
    Mega1D.Sex(i)=Megadatabase(i).Sex;
    Mega1D.Stat(i)=Megadatabase(i).Stat;
    Mega1D.Signal(i)=Megadatabase(i).Signal;
    Mega1D.Forward(:,i)=Megadatabase(i).Forward';
    Mega1D.Time(i)=Megadatabase(i).Time';
    
end 

Mega1D.Sex=Mega1D.Sex(~isnan(Mega1D.Forward(1,:)))';
Mega1D.Stat=Mega1D.Stat(~isnan(Mega1D.Forward(1,:)))';
Mega1D.Signal=Mega1D.Signal(~isnan(Mega1D.Forward(1,:)))';
Mega1D.Time=Mega1D.Time(~isnan(Mega1D.Forward(1,:)))';
Mega1D.Forward=Mega1D.Forward(:,~isnan(Mega1D.Forward(1,:)))';

clear Megadatabase
   
% Generate figure for SRM with Confidence interval
% X value: DoF, Y value SRM +- IC, Women Red, Men Blue
g(1,1)=gramm('x',repmat([1:100]',1,length(Mega1D.Sex))','y',Mega1D.Forward, 'color',Mega1D.Sex,'linestyle',Mega1D.Time,'subset', strcmp(Mega1D.Stat, Statistic) & ismember(Mega1D.Signal, Signals));
g(1,1).set_color_options('map',[0 0 1; 1 0 0])

g(1,1).facet_grid(Mega1D.Signal,[],'scale', 'free_y', 'column_labels', true, ...
    'row_labels',true);

%g.geom_point('alpha',0.5)
%g(1,1).geom_line()
g(1,1).stat_summary('type','sem','geom','area','setylim','true')
g(1,1).set_title('Time histories','FontSize',11)
g(1,1).set_names('y','Degrees', 'x', '% of movement duration', 'row','')
g(1,1).set_text_options('font','Arial')

g(1,1).set_limit_extra([0 0],[0.05 0.05])


load('GroupData0D.mat')

for i=length(Megadatabase):-1:1
    
    Mega0D.Sex([i,i+length(Megadatabase)])=repmat(Megadatabase(i).Sex,2,1);
    Mega0D.Stat([i,i+length(Megadatabase)])=repmat(Megadatabase(i).Stat,2,1);
    Mega0D.Signal([i,i+length(Megadatabase)])=repmat(Megadatabase(i).Signal,2,1);
    Mega0D.data(i)=Megadatabase(i).MeanPosFwd;
    Mega0D.data(i+length(Megadatabase))=Megadatabase(i).ROMFwd;
    Mega0D.Time([i,i+length(Megadatabase)])=Megadatabase(i).Time;
    Mega0D.Variable(i)={'Average Position'};
    Mega0D.Variable(i+length(Megadatabase))={'Range of Motion'};
    
end 

Mega0D.Sex=Mega0D.Sex(~isnan(Mega0D.data(:)))';
Mega0D.Stat=Mega0D.Stat(~isnan(Mega0D.data(:)))';
Mega0D.Signal=Mega0D.Signal(~isnan(Mega0D.data(:)))';
Mega0D.Time=Mega0D.Time(~isnan(Mega0D.data(:)))';
Mega0D.data=Mega0D.data(:,~isnan(Mega0D.data(:)))';
Mega0D.Variable=Mega0D.Variable(~isnan(Mega0D.data(:)))';

g(1,2)=gramm('x',Mega0D.Time,'y',Mega0D.data, 'color',Mega0D.Sex,'subset', strcmp(Mega0D.Stat, Statistic) & ismember(Mega0D.Signal, Signals));
g(1,2).set_color_options('map',[0 0 1; 1 0 0])

g(1,2).facet_grid(Mega0D.Signal,Mega0D.Variable,'scale', 'independent', 'row_labels',false)

g(1,2).stat_summary('type','sem','geom','errorbar','setylim','true')
g(1,2).no_legend()

g(1,2).set_names('y','', 'x', '', 'row','', 'column', '')

g.draw

g(1,2).update('x',Mega0D.Time,'y',Mega0D.data, 'color',Mega0D.Sex,'subset', strcmp(Mega0D.Stat,Statistic) & ismember(Mega0D.Signal, Signals));
g(1,2).set_color_options('map',[0 0 1; 1 0 0])
g(1,2).stat_summary('type','sem','geom','point','setylim','true')
g(1,2).set_point_options('base_size',8)
g(1,2).no_legend()

%g(1,2).set_names('y','', 'x', '', 'row','', 'column', '')

g.draw(false)

g(1,2).update('x',Mega0D.Time,'y',Mega0D.data, 'color',Mega0D.Sex,'subset', strcmp(Mega0D.Stat,Statistic) & ismember(Mega0D.Signal, Signals));
g(1,2).set_color_options('map',[0 0 1; 1 0 0])
g(1,2).stat_summary('type','sem','geom','line','setylim','true')


g(1,2).set_limit_extra([0.5 0.5],[0.05 0.05])
g(1,2).no_legend()

%g(1,2).set_names('y','', 'x', '', 'row','', 'column', '')


g.draw(false)
