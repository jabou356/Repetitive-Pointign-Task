close all

% Generate figure for SRM with Confidence interval
% X value: DoF, Y value SRM +- IC, Women Red, Men Blue
g=gramm('x',data.Signal,'y',data.SRM, 'ymin',data.SRMlow, 'ymax', data.SRMup,'color',data.Sex)%, 'label', round(data.proportion))
g.set_color_options('map',[0 0 1; 1 0 0])

% Set X Tick Label at 45 deg (names of DoF) and SRM limits between -2 and 2
g.axe_property('XTickLabelRotation',45,'YLim',[-2 2]) 

% Create 2x2 figure, colume are Statistics (Mean or SD) and Rows are
% Variables (Average position or Range of Motion)
g.facet_grid(data.Variable,data.stats)

%Plot data as points surrounded by errorbars
g.geom_point('alpha',0.5)
%g.geom_label('VerticalAlignment','middle','HorizontalAlignment','right')
g.set_point_options('base_size',8)
g.geom_interval('geom','errorbar')

% Set text properties
g.set_names('column','','row','','x','','y','SRM','color','')
g.set_text_options('Font','Arial','label_scaling',1.2)


figure('Position',[100 100 800 600])
g.draw()

% g.update('x',data.Signal,'y',(data.proportion-50)/100*4,'color',data.Sex)
% g.set_color_options('map',[0 0 1; 1 0 0])
% 
% g.geom_point('alpha',0.5)
% g.set_point_options('markers',{'>'})
% % g.axe_property('XTickLabelRotation',45,'YLim',[-2 2])
%  g.draw