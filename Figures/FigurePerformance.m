close all
clear 
figure('Units', 'centimeters','Position', [1.5, 1, 16.5, 11]);
badS={'Karen9', 'Karen12'}; % Outliers for IDX Marker

load('GroupData0D.mat')

for i=length(Megadatabase):-1:1
    
    Mega0D.Sex(i)=Megadatabase(i).Sex;
    Mega0D.Stat(i)=Megadatabase(i).Stat;
    Mega0D.Signal(i)=Megadatabase(i).Signal;
    Mega0D.Time(i)=Megadatabase(i).Time;
    Mega0D.Endurance(i)=Megadatabase(i).Endurance;
    Mega0D.TimingError(i)=str2num(cell2mat(Megadatabase(i).TimingErrFwd));
    Mega0D.Timing(i)=str2num(cell2mat(Megadatabase(i).TimingFwd));
    Mega0D.Subject(i)=Megadatabase(i).Subject;

    Mega0D.data(i)=Megadatabase(i).MeanPosFwd;    
end 

Mega0D.Sex=Mega0D.Sex(~isnan(Mega0D.data(:)))';
Mega0D.Subject=Mega0D.Subject(~isnan(Mega0D.data(:)))';
Mega0D.Stat=Mega0D.Stat(~isnan(Mega0D.data(:)))';
Mega0D.Signal=Mega0D.Signal(~isnan(Mega0D.data(:)))';
Mega0D.Time=Mega0D.Time(~isnan(Mega0D.data(:)))';
Mega0D.data=Mega0D.data(:,~isnan(Mega0D.data(:)))';
Mega0D.Endurance=Mega0D.Endurance(~isnan(Mega0D.data(:)))';
Mega0D.Timing=Mega0D.Timing(~isnan(Mega0D.data(:)))';
Mega0D.TimingError=Mega0D.TimingError(:,~isnan(Mega0D.data(:)))';

%% Draw central tendencies (lines)
% Endurance time
g(1,1)=gramm('x',Mega0D.Sex,'y',Mega0D.Endurance, 'color',Mega0D.Sex,'subset', strcmp(Mega0D.Stat, 'Mean') & strcmp(Mega0D.Signal, 'ElbowFlex') & Mega0D.Time ==1 );
g(1,1).set_color_options('map',[0 0 1; 1 0 0])

g(1,1).stat_summary('geom','bar')
g(1,1).no_legend()

% Elbow elevation
g(2,1)=gramm('x',Mega0D.Time,'y',Mega0D.data, 'color',Mega0D.Sex,'subset', strcmp(Mega0D.Stat, 'Mean') & strcmp(Mega0D.Signal, 'RELBNormSI'));
g(2,1).set_color_options('map',[0 0 1; 1 0 0])

g(2,1).stat_summary('geom','line')
g(2,1).no_legend()


% RIDX vectorial distance Bias

g(1,2)=gramm('x',Mega0D.Time,'y',Mega0D.data, 'color',Mega0D.Sex,'subset', strcmp(Mega0D.Stat, 'Mean') & strcmp(Mega0D.Signal, 'RIDXVectDist') &~ismember(Mega0D.Subject,badS));
g(1,2).set_color_options('map',[0 0 1; 1 0 0])

g(1,2).stat_summary('geom','line')
g(1,2).no_legend()

% RIDX vectorial distance Bias

g(2,2)=gramm('x',Mega0D.Time,'y',Mega0D.data, 'color',Mega0D.Sex,'subset', strcmp(Mega0D.Stat, 'SD') & strcmp(Mega0D.Signal, 'RIDXVectDist')&~ismember(Mega0D.Subject,badS));
g(2,2).set_color_options('map',[0 0 1; 1 0 0])

g(2,2).stat_summary('geom','line')
g(2,2).no_legend()

% Timing bias 
g(1,3)=gramm('x',Mega0D.Time,'y',Mega0D.Timing, 'color',Mega0D.Sex,'subset', strcmp(Mega0D.Stat, 'Mean') & strcmp(Mega0D.Signal, 'ElbowFlex'));
g(1,3).set_color_options('map',[0 0 1; 1 0 0])

g(1,3).stat_summary('geom','line')
g(1,3).no_legend()

% Timing error
g(2,3)=gramm('x',Mega0D.Time,'y',Mega0D.TimingError, 'color',Mega0D.Sex,'subset', strcmp(Mega0D.Stat, 'Mean') & strcmp(Mega0D.Signal, 'ElbowFlex'));
g(2,3).set_color_options('map',[0 0 1; 1 0 0])

g(2,3).stat_summary('geom','line')
g(2,3).no_legend()


g.draw

%% Draw central tendency (points)
% Elbow elevation
g(2,1).update('x',Mega0D.Time,'y',Mega0D.data, 'color',Mega0D.Sex,'subset', strcmp(Mega0D.Stat, 'Mean') & strcmp(Mega0D.Signal, 'RELBNormSI'));
g(2,1).set_color_options('map',[0 0 1; 1 0 0])

g(2,1).stat_summary('geom','point')
g(2,1).no_legend()


% RIDX vectorial distance Bias
g(1,2).update('x',Mega0D.Time,'y',Mega0D.data, 'color',Mega0D.Sex,'subset', strcmp(Mega0D.Stat, 'Mean') & strcmp(Mega0D.Signal, 'RIDXVectDist') &~ismember(Mega0D.Subject,badS));
g(1,2).set_color_options('map',[0 0 1; 1 0 0])

g(1,2).stat_summary('geom','point')
g(1,2).no_legend()

% RIDX vectorial distance SD
g(2,2).update('x',Mega0D.Time,'y',Mega0D.data, 'color',Mega0D.Sex,'subset', strcmp(Mega0D.Stat, 'SD') & strcmp(Mega0D.Signal, 'RIDXVectDist') &~ismember(Mega0D.Subject,badS));
g(2,2).set_color_options('map',[0 0 1; 1 0 0])

g(2,2).stat_summary('geom','point')
g(2,2).no_legend()


% Timing bias 
g(1,3).update('x',Mega0D.Time,'y',Mega0D.Timing, 'color',Mega0D.Sex,'subset', strcmp(Mega0D.Stat, 'Mean') & strcmp(Mega0D.Signal, 'ElbowFlex'));
g(1,3).set_color_options('map',[0 0 1; 1 0 0])

g(1,3).stat_summary('geom','point')

g(1,3).no_legend()

% Timing error
g(2,3).update('x',Mega0D.Time,'y',Mega0D.TimingError, 'color',Mega0D.Sex,'subset', strcmp(Mega0D.Stat, 'Mean') & strcmp(Mega0D.Signal, 'ElbowFlex'));
g(2,3).set_color_options('map',[0 0 1; 1 0 0])

g(2,3).stat_summary('geom','point')
g(2,3).no_legend()

g.draw(false)

%% Draw errorbars
% Endurance time
g(1,1).update('x',Mega0D.Sex,'y',Mega0D.Endurance, 'color',Mega0D.Sex,'subset', strcmp(Mega0D.Stat, 'Mean') & strcmp(Mega0D.Signal, 'ElbowFlex') & Mega0D.Time ==1 );
g(1,1).set_color_options('map',[0 0 1; 1 0 0])

g(1,1).stat_summary('type','sem','geom','errorbar')
g(1,1).no_legend()

g(1,1).set_names('y','Endurance Time (min)', 'x', '')

g(1,1).axe_property('XLim',[0.5 2.5],'YLim',[0 10],'XTick', [1 2], 'XTickLabel', {'Men', 'Women'}) 

% Elbow elevation
g(2,1).update('x',Mega0D.Time,'y',Mega0D.data, 'color',Mega0D.Sex,'subset', strcmp(Mega0D.Stat, 'Mean') & strcmp(Mega0D.Signal, 'RELBNormSI'));
g(2,1).set_color_options('map',[0 0 1; 1 0 0])

g(2,1).stat_summary('type','sem','geom','errorbar')
g(2,1).no_legend()

g(2,1).set_names('y','Elbow Height (mm)', 'x', '')


g(2,1).axe_property('XLim',[0.5 2.5],'YLim',[0 150],'XTick', [1 2], 'XTickLabel', {'Baseline', 'Fatigue'}) 



% RIDX vectorial distance Bias
g(1,2).update('x',Mega0D.Time,'y',Mega0D.data, 'color',Mega0D.Sex,'subset', strcmp(Mega0D.Stat, 'Mean') & strcmp(Mega0D.Signal, 'RIDXVectDist') &~ismember(Mega0D.Subject,badS));
g(1,2).set_color_options('map',[0 0 1; 1 0 0])

g(1,2).stat_summary('type','sem','geom','errorbar')
g(1,2).no_legend()

g(1,2).axe_property('XLim',[0.5 2.5],'YLim',[0 50],'XTick', [1 2], 'XTickLabel', {'Baseline', 'Fatigue'}) 

g(1,2).set_names('y',{'Mean distance'; 'from target center (mm)'}, 'x', '')


% RIDX vectorial distance SD
g(2,2).update('x',Mega0D.Time,'y',Mega0D.data, 'color',Mega0D.Sex,'subset', strcmp(Mega0D.Stat, 'SD') & strcmp(Mega0D.Signal, 'RIDXVectDist')&~ismember(Mega0D.Subject,badS));
g(2,2).set_color_options('map',[0 0 1; 1 0 0])

g(2,2).stat_summary('type','sem','geom','errorbar')
g(2,2).no_legend()

g(2,2).axe_property('XLim',[0.5 2.5],'YLim',[0 10],'XTick', [1 2], 'XTickLabel', {'Baseline', 'Fatigue'}) 

g(2,2).set_names('y',{'SD distance'; 'from target center (mm)'}, 'x', '')


% Timing bias 
g(1,3).update('x',Mega0D.Time,'y',Mega0D.Timing, 'color',Mega0D.Sex,'subset', strcmp(Mega0D.Stat, 'Mean') & strcmp(Mega0D.Signal, 'ElbowFlex'));
g(1,3).set_color_options('map',[0 0 1; 1 0 0])

g(1,3).stat_summary('type','sem','geom','errorbar')
g(1,3).no_legend()

g(1,3).axe_property('XLim',[0.5 2.5],'YLim',[0.975 1.025],'XTick', [1 2], 'XTickLabel', {'Baseline', 'Fatigue'}) 

g(1,3).set_names('y',{'Mean movement'; 'duration (s)'}, 'x', '')




% Timing error
g(2,3).update('x',Mega0D.Time,'y',Mega0D.TimingError, 'color',Mega0D.Sex,'subset', strcmp(Mega0D.Stat, 'Mean') & strcmp(Mega0D.Signal, 'ElbowFlex'));
g(2,3).set_color_options('map',[0 0 1; 1 0 0])

g(2,3).stat_summary('type','sem','geom','errorbar')
g(2,3).no_legend()

g(2,3).axe_property('XLim',[0.5 2.5],'YLim',[0 0.1],'XTick', [1 2], 'XTickLabel', {'Baseline', 'Fatigue'}) 
g(2,3).set_names('y',{'Mean timing'; 'error (s)'}, 'x', '')


g.draw(false)