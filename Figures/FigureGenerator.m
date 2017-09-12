close all
variables = {'Elbow flexion', 'Shoulder plane', 'Shouler elevation', 'Trunk axial rotation', 'Trunk flexion'};
statistic = 'SD';
myfig = figure('Name','Mean joint angles', ...
    'Color', 'w', ...
    'NumberTitle', 'off', ...
    'Units', 'centimeters', ...
    'Position', [1.5, 1, 16.5, 22], ...
    'OuterPosition', [0, 0, 18, 24],...
    'ColorMap', colormap(flipud(gray)));

myax(1) = subplot(5,4,1); % for ROM data
myax(2) = subplot(5,4,2); % For mean position data
myax(3) = subplot(5,4,3); % for 1D data
myax(16) = subplot(5,4,4); % for 1D statistics

myax(4) = subplot(5,4,5); % for ROM data
myax(5) = subplot(5,4,6); % For mean position data
myax(6) = subplot(5,4,7); % for 1D data
myax(17) = subplot(5,4,8); % for 1D statistics


myax(7) = subplot(5,4,9); % for ROM data
myax(8) = subplot(5,4,10); % For mean position data
myax(9) = subplot(5,4,11); % for 1D data
myax(18) = subplot(5,4,12); %for 1D statistics


myax(10) = subplot(5,4,13); % for ROM data
myax(11) = subplot(5,4,14); % For mean position data
myax(12) = subplot(5,4,15); % for 1D data
myax(19) = subplot(5,4,16); % for 1D statistics


myax(13) = subplot(5,4,17); % for ROM data
myax(14) = subplot(5,4,18); % For mean position data
myax(15) = subplot(5,4,19); % for 1D data
myax(20) = subplot(5,4,20); % for 1D statistics


for i=[1,2,4,5,7,8,10,11,13,14]
    %myax(i).Color = 'none';
    myax(i).Box = 'on';
    myax(i).LineWidth = 1;
    myax(i).FontName = 'Arial';
    myax(i).FontSize = 9;
    
    myax(i).XColor = 'k';
    myax(i).YColor = 'k';
    
    myax(i).XLim = [0 2];
    myax(i).XTick = [0.5 1.5];
    myax(i).XTickLabel = {'Baseline', 'Fatigue'};
    
    switch i
        case 1
            myfig.CurrentAxes = myax(i);
            hold on
            myax(i).YLabel.String = variables{1};
            myax(i).YLabel.FontWeight = 'bold';
            myax(i).Title.String = 'Range of Motion';
            
            myax(i).Units='centimeters';
            myax(i).Position=[2 18 2.8 2.7];
            
            Y=Stats0D.ElbowFlex.(statistic).ROMFwd.nonparam.permuter.Y;
            Sex=Stats0D.ElbowFlex.(statistic).ROMFwd.nonparam.permuter.A;
            Time=Stats0D.ElbowFlex.(statistic).ROMFwd.nonparam.permuter.B;
            n=length(Sex / 4);
            
            plot([0.5, 1.5], [mean(Y(Sex == 1 & Time == 1)) mean(Y(Sex == 1 & Time == 2))], 'bo-','MarkerFaceColor','b')
            
            errorbar([0.5, 1.5], [mean(Y(Sex == 1 & Time == 1)) mean(Y(Sex == 1 & Time == 2))], ...
                [std(Y(Sex == 1 & Time == 1))/sqrt(n), std(Y(Sex == 1 & Time == 1))/sqrt(n)])
            
            plot([0.5, 1.5], [mean(Y(Sex == 2 & Time == 1)) mean(Y(Sex == 2 & Time == 2))], 'ro-','MarkerFaceColor','r')
            
            errorbar([0.5, 1.5], [mean(Y(Sex == 2 & Time == 1)) mean(Y(Sex == 2 & Time == 2))], ...
                [std(Y(Sex == 2 & Time == 1))/sqrt(n), std(Y(Sex == 2 & Time == 1))/sqrt(n)], 'r')
            
            
            
        case 2
            myfig.CurrentAxes = myax(i);
            hold on
            
            myax(i).Units='centimeters';
            myax(i).Position=[5.8 18 2.8 2.7];
            
            myax(i).Title.String = 'Average position';
            Y=Stats0D.ElbowFlex.(statistic).MeanPosFwd.nonparam.permuter.Y;
            Sex=Stats0D.ElbowFlex.(statistic).MeanPosFwd.nonparam.permuter.A;
            Time=Stats0D.ElbowFlex.(statistic).MeanPosFwd.nonparam.permuter.B;
            n=length(Sex / 4);
            
            plot([0.5, 1.5], [mean(Y(Sex == 1 & Time == 1)) mean(Y(Sex == 1 & Time == 2))], 'bo-','MarkerFaceColor','b')
            
            errorbar([0.5, 1.5], [mean(Y(Sex == 1 & Time == 1)) mean(Y(Sex == 1 & Time == 2))], ...
                [std(Y(Sex == 1 & Time == 1))/sqrt(n), std(Y(Sex == 1 & Time == 1))/sqrt(n)])
            
            plot([0.5, 1.5], [mean(Y(Sex == 2 & Time == 1)) mean(Y(Sex == 2 & Time == 2))], 'ro-','MarkerFaceColor','r')
            
            errorbar([0.5, 1.5], [mean(Y(Sex == 2 & Time == 1)) mean(Y(Sex == 2 & Time == 2))], ...
                [std(Y(Sex == 2 & Time == 1))/sqrt(n), std(Y(Sex == 2 & Time == 1))/sqrt(n)], 'r')
            
            
        case 4
            myfig.CurrentAxes = myax(i);
            hold on
            
            myax(i).Units='centimeters';
            myax(i).Position=[2 14 2.8 2.7];
            
            myax(i).YLabel.String = variables{2};
            myax(i).YLabel.FontWeight = 'bold';
            
            Y=Stats0D.Shoulderplane.(statistic).ROMFwd.nonparam.permuter.Y;
            Sex=Stats0D.Shoulderplane.(statistic).ROMFwd.nonparam.permuter.A;
            Time=Stats0D.Shoulderplane.(statistic).ROMFwd.nonparam.permuter.B;
            n=length(Sex / 4);
            
            plot([0.5, 1.5], [mean(Y(Sex == 1 & Time == 1)) mean(Y(Sex == 1 & Time == 2))], 'bo-','MarkerFaceColor','b')
            
            errorbar([0.5, 1.5], [mean(Y(Sex == 1 & Time == 1)) mean(Y(Sex == 1 & Time == 2))], ...
                [std(Y(Sex == 1 & Time == 1))/sqrt(n), std(Y(Sex == 1 & Time == 1))/sqrt(n)])
            
            plot([0.5, 1.5], [mean(Y(Sex == 2 & Time == 1)) mean(Y(Sex == 2 & Time == 2))], 'ro-','MarkerFaceColor','r')
            
            errorbar([0.5, 1.5], [mean(Y(Sex == 2 & Time == 1)) mean(Y(Sex == 2 & Time == 2))], ...
                [std(Y(Sex == 2 & Time == 1))/sqrt(n), std(Y(Sex == 2 & Time == 1))/sqrt(n)], 'r')
            
            
        case 5
            myfig.CurrentAxes = myax(i);
            hold on
            
            myax(i).Units='centimeters';
            myax(i).Position=[5.8 14 2.8 2.7];
            
            Y=Stats0D.Shoulderplane.(statistic).MeanPosFwd.nonparam.permuter.Y;
            Sex=Stats0D.Shoulderplane.(statistic).MeanPosFwd.nonparam.permuter.A;
            Time=Stats0D.Shoulderplane.(statistic).MeanPosFwd.nonparam.permuter.B;
            n=length(Sex / 4);
            
            plot([0.5, 1.5], [mean(Y(Sex == 1 & Time == 1)) mean(Y(Sex == 1 & Time == 2))], 'bo-','MarkerFaceColor','b')
            
            errorbar([0.5, 1.5], [mean(Y(Sex == 1 & Time == 1)) mean(Y(Sex == 1 & Time == 2))], ...
                [std(Y(Sex == 1 & Time == 1))/sqrt(n), std(Y(Sex == 1 & Time == 1))/sqrt(n)])
            
            plot([0.5, 1.5], [mean(Y(Sex == 2 & Time == 1)) mean(Y(Sex == 2 & Time == 2))], 'ro-','MarkerFaceColor','r')
            
            errorbar([0.5, 1.5], [mean(Y(Sex == 2 & Time == 1)) mean(Y(Sex == 2 & Time == 2))], ...
                [std(Y(Sex == 2 & Time == 1))/sqrt(n), std(Y(Sex == 2 & Time == 1))/sqrt(n)], 'r')
            
            
        case 7
            myfig.CurrentAxes = myax(i);
            hold on
            
            myax(i).Units='centimeters';
            myax(i).Position=[2 10 2.8 2.7];
            
            myax(i).YLabel.String = variables{3};
            myax(i).YLabel.FontWeight = 'bold';
            
            Y=Stats0D.ShoulderElev.(statistic).ROMFwd.nonparam.permuter.Y;
            Sex=Stats0D.ShoulderElev.(statistic).ROMFwd.nonparam.permuter.A;
            Time=Stats0D.ShoulderElev.(statistic).ROMFwd.nonparam.permuter.B;
            n=length(Sex / 4);
            
            plot([0.5, 1.5], [mean(Y(Sex == 1 & Time == 1)) mean(Y(Sex == 1 & Time == 2))], 'bo-','MarkerFaceColor','b')
            
            errorbar([0.5, 1.5], [mean(Y(Sex == 1 & Time == 1)) mean(Y(Sex == 1 & Time == 2))], ...
                [std(Y(Sex == 1 & Time == 1))/sqrt(n), std(Y(Sex == 1 & Time == 1))/sqrt(n)])
            
            plot([0.5, 1.5], [mean(Y(Sex == 2 & Time == 1)) mean(Y(Sex == 2 & Time == 2))], 'ro-','MarkerFaceColor','r')
            
            errorbar([0.5, 1.5], [mean(Y(Sex == 2 & Time == 1)) mean(Y(Sex == 2 & Time == 2))], ...
                [std(Y(Sex == 2 & Time == 1))/sqrt(n), std(Y(Sex == 2 & Time == 1))/sqrt(n)], 'r')
            
            
        case 8
            myfig.CurrentAxes = myax(i);
            hold on
            
            myax(i).Units='centimeters';
            myax(i).Position=[5.8 10 2.8 2.7];
            
            Y=Stats0D.ShoulderElev.(statistic).MeanPosFwd.nonparam.permuter.Y;
            Sex=Stats0D.ShoulderElev.(statistic).MeanPosFwd.nonparam.permuter.A;
            Time=Stats0D.ShoulderElev.(statistic).MeanPosFwd.nonparam.permuter.B;
            n=length(Sex / 4);
            
            plot([0.5, 1.5], [mean(Y(Sex == 1 & Time == 1)) mean(Y(Sex == 1 & Time == 2))], 'bo-','MarkerFaceColor','b')
            
            errorbar([0.5, 1.5], [mean(Y(Sex == 1 & Time == 1)) mean(Y(Sex == 1 & Time == 2))], ...
                [std(Y(Sex == 1 & Time == 1))/sqrt(n), std(Y(Sex == 1 & Time == 1))/sqrt(n)])
            
            plot([0.5, 1.5], [mean(Y(Sex == 2 & Time == 1)) mean(Y(Sex == 2 & Time == 2))], 'ro-','MarkerFaceColor','r')
            
            errorbar([0.5, 1.5], [mean(Y(Sex == 2 & Time == 1)) mean(Y(Sex == 2 & Time == 2))], ...
                [std(Y(Sex == 2 & Time == 1))/sqrt(n), std(Y(Sex == 2 & Time == 1))/sqrt(n)], 'r')
            
            
            
        case 10
            myfig.CurrentAxes = myax(i);
            hold on
            
            myax(i).Units='centimeters';
            myax(i).Position=[2 6 2.8 2.7];
            
            myax(i).YLabel.String = variables{4};
            myax(i).YLabel.FontWeight = 'bold';
            
            Y=Stats0D.TrunkRy.(statistic).ROMFwd.nonparam.permuter.Y;
            Sex=Stats0D.TrunkRy.(statistic).ROMFwd.nonparam.permuter.A;
            Time=Stats0D.TrunkRy.(statistic).ROMFwd.nonparam.permuter.B;
            n=length(Sex / 4);
            
            plot([0.5, 1.5], [mean(Y(Sex == 1 & Time == 1)) mean(Y(Sex == 1 & Time == 2))], 'bo-','MarkerFaceColor','b')
            
            errorbar([0.5, 1.5], [mean(Y(Sex == 1 & Time == 1)) mean(Y(Sex == 1 & Time == 2))], ...
                [std(Y(Sex == 1 & Time == 1))/sqrt(n), std(Y(Sex == 1 & Time == 1))/sqrt(n)])
            
            plot([0.5, 1.5], [mean(Y(Sex == 2 & Time == 1)) mean(Y(Sex == 2 & Time == 2))], 'ro-','MarkerFaceColor','r')
            
            errorbar([0.5, 1.5], [mean(Y(Sex == 2 & Time == 1)) mean(Y(Sex == 2 & Time == 2))], ...
                [std(Y(Sex == 2 & Time == 1))/sqrt(n), std(Y(Sex == 2 & Time == 1))/sqrt(n)], 'r')
            
            
        case 11
            myfig.CurrentAxes = myax(i);
            hold on
            
            myax(i).Units='centimeters';
            myax(i).Position=[5.8 6 2.8 2.7];
            
            Y=Stats0D.TrunkRy.(statistic).MeanPosFwd.nonparam.permuter.Y;
            Sex=Stats0D.TrunkRy.(statistic).MeanPosFwd.nonparam.permuter.A;
            Time=Stats0D.TrunkRy.(statistic).MeanPosFwd.nonparam.permuter.B;
            n=length(Sex / 4);
            
            plot([0.5, 1.5], [mean(Y(Sex == 1 & Time == 1)) mean(Y(Sex == 1 & Time == 2))], 'bo-','MarkerFaceColor','b')
            
            errorbar([0.5, 1.5], [mean(Y(Sex == 1 & Time == 1)) mean(Y(Sex == 1 & Time == 2))], ...
                [std(Y(Sex == 1 & Time == 1))/sqrt(n), std(Y(Sex == 1 & Time == 1))/sqrt(n)])
            
            plot([0.5, 1.5], [mean(Y(Sex == 2 & Time == 1)) mean(Y(Sex == 2 & Time == 2))], 'ro-','MarkerFaceColor','r')
            
            errorbar([0.5, 1.5], [mean(Y(Sex == 2 & Time == 1)) mean(Y(Sex == 2 & Time == 2))], ...
                [std(Y(Sex == 2 & Time == 1))/sqrt(n), std(Y(Sex == 2 & Time == 1))/sqrt(n)], 'r')
            
            
            
            
        case 13
            myfig.CurrentAxes = myax(i);
            hold on
            
            myax(i).Units='centimeters';
            myax(i).Position=[2 2 2.8 2.7];
            
            myax(i).YLabel.String = variables{5};
            myax(i).YLabel.FontWeight = 'bold';
            
            Y=Stats0D.TrunkRz.(statistic).ROMFwd.nonparam.permuter.Y;
            Sex=Stats0D.TrunkRz.(statistic).ROMFwd.nonparam.permuter.A;
            Time=Stats0D.TrunkRz.(statistic).ROMFwd.nonparam.permuter.B;
            n=length(Sex / 4);
            
            plot([0.5, 1.5], [mean(Y(Sex == 1 & Time == 1)) mean(Y(Sex == 1 & Time == 2))], 'bo-','MarkerFaceColor','b')
            
            errorbar([0.5, 1.5], [mean(Y(Sex == 1 & Time == 1)) mean(Y(Sex == 1 & Time == 2))], ...
                [std(Y(Sex == 1 & Time == 1))/sqrt(n), std(Y(Sex == 1 & Time == 1))/sqrt(n)])
            
            plot([0.5, 1.5], [mean(Y(Sex == 2 & Time == 1)) mean(Y(Sex == 2 & Time == 2))], 'ro-','MarkerFaceColor','r')
            
            errorbar([0.5, 1.5], [mean(Y(Sex == 2 & Time == 1)) mean(Y(Sex == 2 & Time == 2))], ...
                [std(Y(Sex == 2 & Time == 1))/sqrt(n), std(Y(Sex == 2 & Time == 1))/sqrt(n)], 'r')
            
            
        case 14
            myfig.CurrentAxes = myax(i);
            hold on
            
            myax(i).Units='centimeters';
            myax(i).Position=[5.8 2 2.8 2.7];
            
            Y=Stats0D.TrunkRz.(statistic).MeanPosFwd.nonparam.permuter.Y;
            Sex=Stats0D.TrunkRz.(statistic).MeanPosFwd.nonparam.permuter.A;
            Time=Stats0D.TrunkRz.(statistic).MeanPosFwd.nonparam.permuter.B;
            n=length(Sex / 4);
            
            plot([0.5, 1.5], [mean(Y(Sex == 1 & Time == 1)) mean(Y(Sex == 1 & Time == 2))], 'bo-','MarkerFaceColor','b')
            
            errorbar([0.5, 1.5], [mean(Y(Sex == 1 & Time == 1)) mean(Y(Sex == 1 & Time == 2))], ...
                [std(Y(Sex == 1 & Time == 1))/sqrt(n), std(Y(Sex == 1 & Time == 1))/sqrt(n)])
            
            plot([0.5, 1.5], [mean(Y(Sex == 2 & Time == 1)) mean(Y(Sex == 2 & Time == 2))], 'ro-','MarkerFaceColor','r')
            
            errorbar([0.5, 1.5], [mean(Y(Sex == 2 & Time == 1)) mean(Y(Sex == 2 & Time == 2))], ...
                [std(Y(Sex == 2 & Time == 1))/sqrt(n), std(Y(Sex == 2 & Time == 1))/sqrt(n)], 'r')
            
            
            
    end
end


for i=[3, 6, 9, 12, 15]
    %myax(i).Color = 'none';
    myax(i).Box = 'on';
    myax(i).LineWidth = 1;
    myax(i).FontName = 'Arial';
    myax(i).FontSize = 9;
    
    myax(i).XColor = 'k';
    myax(i).YColor = 'k';
    
    myax(i).XLim = [0 100];
    
    
    switch i
        case 3
            myfig.CurrentAxes = myax(i);
            hold on
            myax(i).Title.String = 'Forward movements';
            
            myax(i).Units='centimeters';
            myax(i).Position=[10.1 18.7 7 2];
            
            myax(i).XTick = [0 20 40 60 80 100];
            myax(i).XTickLabel = [];
    
            Y=Stats1D.ElbowFlex.(statistic).Forward.nonparam.permuter.Y;
            Sex=Stats1D.ElbowFlex.(statistic).Forward.nonparam.permuter.A;
            Time=Stats1D.ElbowFlex.(statistic).Forward.nonparam.permuter.B;
            n=length(Sex / 4);
            
            plot(mean(Y(Sex == 1 & Time == 1,:)), 'b:','Linewidth',2)
            plot(mean(Y(Sex == 1 & Time == 2,:)), 'b','Linewidth',2)
            plot(mean(Y(Sex == 2 & Time == 1,:)), 'r:','Linewidth',2)
            plot(mean(Y(Sex == 2 & Time == 2,:)), 'r','Linewidth',2)
            
           
%             errorbar([0.5, 1.5], [mean(Y(Sex == 1 & Time == 1,:)) mean(Y(Sex == 1 & Time == 2,:))], ...
%                 [std(Y(Sex == 1 & Time == 1,:))/sqrt(n), std(Y(Sex == 1 & Time == 1,:))/sqrt(n)])
%             
%             
%             errorbar([0.5, 1.5], [mean(Y(Sex == 2 & Time == 1)) mean(Y(Sex == 2 & Time == 2))], ...
%                 [std(Y(Sex == 2 & Time == 1))/sqrt(n), std(Y(Sex == 2 & Time == 1))/sqrt(n)], 'r')
            
            
                 
        case 6
            myfig.CurrentAxes = myax(i);
            hold on
            
            myax(i).Units='centimeters';
            myax(i).Position=[10.1 14.7 7 2];
            
            myax(i).XTick = [0 20 40 60 80 100];
            myax(i).XTickLabel = [];
            
            Y=Stats1D.Shoulderplane.(statistic).Forward.nonparam.permuter.Y;
            Sex=Stats1D.Shoulderplane.(statistic).Forward.nonparam.permuter.A;
            Time=Stats1D.Shoulderplane.(statistic).Forward.nonparam.permuter.B;
            n=length(Sex / 4);
            
            plot(mean(Y(Sex == 1 & Time == 1,:)), 'b:','Linewidth',2)
            plot(mean(Y(Sex == 1 & Time == 2,:)), 'b','Linewidth',2)
            plot(mean(Y(Sex == 2 & Time == 1,:)), 'r:','Linewidth',2)
            plot(mean(Y(Sex == 2 & Time == 2,:)), 'r','Linewidth',2)
            
            
%             errorbar([0.5, 1.5], [mean(Y(Sex == 1 & Time == 1)) mean(Y(Sex == 1 & Time == 2))], ...
%                 [std(Y(Sex == 1 & Time == 1))/sqrt(n), std(Y(Sex == 1 & Time == 1))/sqrt(n)])
%             
%             
%             errorbar([0.5, 1.5], [mean(Y(Sex == 2 & Time == 1)) mean(Y(Sex == 2 & Time == 2))], ...
%                 [std(Y(Sex == 2 & Time == 1))/sqrt(n), std(Y(Sex == 2 & Time == 1))/sqrt(n)], 'r')
%             
       
            
        case 9
            myfig.CurrentAxes = myax(i);
            hold on
            
            myax(i).Units='centimeters';
            myax(i).Position=[10.1 10.7 7 2];
            
            myax(i).XTick = [0 20 40 60 80 100];
            myax(i).XTickLabel = [];
            
            Y=Stats1D.ShoulderElev.(statistic).Forward.nonparam.permuter.Y;
            Sex=Stats1D.ShoulderElev.(statistic).Forward.nonparam.permuter.A;
            Time=Stats1D.ShoulderElev.(statistic).Forward.nonparam.permuter.B;
            n=length(Sex / 4);
            
            plot(mean(Y(Sex == 1 & Time == 1,:)), 'b:','Linewidth',2)
            plot(mean(Y(Sex == 1 & Time == 2,:)), 'b','Linewidth',2)
            plot(mean(Y(Sex == 2 & Time == 1,:)), 'r:','Linewidth',2)
            plot(mean(Y(Sex == 2 & Time == 2,:)), 'r','Linewidth',2)
            
            
%             errorbar([0.5, 1.5], [mean(Y(Sex == 1 & Time == 1)) mean(Y(Sex == 1 & Time == 2))], ...
%                 [std(Y(Sex == 1 & Time == 1))/sqrt(n), std(Y(Sex == 1 & Time == 1))/sqrt(n)])
%             
%             
%             errorbar([0.5, 1.5], [mean(Y(Sex == 2 & Time == 1)) mean(Y(Sex == 2 & Time == 2))], ...
%                 [std(Y(Sex == 2 & Time == 1))/sqrt(n), std(Y(Sex == 2 & Time == 1))/sqrt(n)], 'r')
            
            
                
        case 12
            myfig.CurrentAxes = myax(i);
            hold on
            
            myax(i).Units='centimeters';
            myax(i).Position=[10.1 6.7 7 2];
            
            myax(i).XTick = [0 20 40 60 80 100];
            myax(i).XTickLabel = [];
            
            Y=Stats1D.TrunkRy.(statistic).Forward.nonparam.permuter.Y;
            Sex=Stats1D.TrunkRy.(statistic).Forward.nonparam.permuter.A;
            Time=Stats1D.TrunkRy.(statistic).Forward.nonparam.permuter.B;
            n=length(Sex / 4);
            
            plot(mean(Y(Sex == 1 & Time == 1,:)), 'b:','Linewidth',2)
            plot(mean(Y(Sex == 1 & Time == 2,:)), 'b','Linewidth',2)
            plot(mean(Y(Sex == 2 & Time == 1,:)), 'r:','Linewidth',2)
            plot(mean(Y(Sex == 2 & Time == 2,:)), 'r','Linewidth',2)
            
            
%             errorbar([0.5, 1.5], [mean(Y(Sex == 1 & Time == 1)) mean(Y(Sex == 1 & Time == 2))], ...
%                 [std(Y(Sex == 1 & Time == 1))/sqrt(n), std(Y(Sex == 1 & Time == 1))/sqrt(n)])
%             
%             
%             errorbar([0.5, 1.5], [mean(Y(Sex == 2 & Time == 1)) mean(Y(Sex == 2 & Time == 2))], ...
%                 [std(Y(Sex == 2 & Time == 1))/sqrt(n), std(Y(Sex == 2 & Time == 1))/sqrt(n)], 'r')
%             
            
            
        case 15
            myfig.CurrentAxes = myax(i);
            hold on
            
            myax(i).Units='centimeters';
            myax(i).Position=[10.1 2.7 7 2];
            
            myax(i).XTick = [0 20 40 60 80 100];
            myax(i).XTickLabel = [];
            
            Y=Stats1D.TrunkRz.(statistic).Forward.nonparam.permuter.Y;
            Sex=Stats1D.TrunkRz.(statistic).Forward.nonparam.permuter.A;
            Time=Stats1D.TrunkRz.(statistic).Forward.nonparam.permuter.B;
            n=length(Sex / 4);
            
            plot(mean(Y(Sex == 1 & Time == 1,:)), 'b:','Linewidth',2)
            plot(mean(Y(Sex == 1 & Time == 2,:)), 'b','Linewidth',2)
            plot(mean(Y(Sex == 2 & Time == 1,:)), 'r:','Linewidth',2)
            plot(mean(Y(Sex == 2 & Time == 2,:)), 'r','Linewidth',2)
            
            
%             errorbar([0.5, 1.5], [mean(Y(Sex == 1 & Time == 1)) mean(Y(Sex == 1 & Time == 2))], ...
%                 [std(Y(Sex == 1 & Time == 1))/sqrt(n), std(Y(Sex == 1 & Time == 1))/sqrt(n)])
%             
%             
%             errorbar([0.5, 1.5], [mean(Y(Sex == 2 & Time == 1)) mean(Y(Sex == 2 & Time == 2))], ...
%                 [std(Y(Sex == 2 & Time == 1))/sqrt(n), std(Y(Sex == 2 & Time == 1))/sqrt(n)], 'r')
%       
            
    end
end

for i=16:20
    %myax(i).Color = 'none';
    myax(i).Box = 'on';
    myax(i).LineWidth = 1;
    myax(i).FontName = 'Arial';
    myax(i).FontSize = 9;
    
    myax(i).XColor = 'k';
    myax(i).YColor = 'k';
    
    myax(i).XLim = [0 100];
    myax(i).YLim = [0 10];
    myax(i).YTick = [2, 5, 8];
    myax(i).YTickLabel = {'S', 'T', 'SxT'};
    myax(i).YDir = 'reverse';
    
    
    switch i
        case 16
            myfig.CurrentAxes = myax(i);
            hold on
            
            myax(i).Units='centimeters';
            myax(i).Position=[10.1 17.5 7 1.2];
            
            myax(i).XTick = [0 20 40 60 80 100];
            myax(i).XTickLabel = [];
            
            
           Sex=Stats1D.ElbowFlex.(statistic).Forward.nonparam.SPMs{1,1};
           Time=Stats1D.ElbowFlex.(statistic).Forward.nonparam.SPMs{1,2};
           SexxTime=Stats1D.ElbowFlex.(statistic).Forward.nonparam.SPMs{1,3};
           
           if Sex.h0reject
               for icluster=1:Sex.nClusters
                   c=Sex.clusters{1,icluster}.metric_value;
                   x=Sex.clusters{1,icluster}.endpoints;
                   image(x(1),2,repmat(c,1,round(x(2)-x(1))))
               end
           end
           
           if Time.h0reject
               for icluster=1:Time.nClusters
                   c=Time.clusters{1,icluster}.metric_value;
                   x=Time.clusters{1,icluster}.endpoints;
                   image(x(1),5,repmat(c,1,round(x(2)-x(1))))
               end
           end
           
           if SexxTime.h0reject
               for icluster=1:SexxTime.nClusters
                   c=SexxTime.clusters{1,icluster}.metric_value;
                   x=SexxTime.clusters{1,icluster}.endpoints;
                   image(x(1),8,repmat(c,1,round(x(2)-x(1))))
               end
           end
           
           

         
           
%             errorbar([0.5, 1.5], [mean(Y(Sex == 1 & Time == 1,:)) mean(Y(Sex == 1 & Time == 2,:))], ...
%                 [std(Y(Sex == 1 & Time == 1,:))/sqrt(n), std(Y(Sex == 1 & Time == 1,:))/sqrt(n)])
%             
%             
%             errorbar([0.5, 1.5], [mean(Y(Sex == 2 & Time == 1)) mean(Y(Sex == 2 & Time == 2))], ...
%                 [std(Y(Sex == 2 & Time == 1))/sqrt(n), std(Y(Sex == 2 & Time == 1))/sqrt(n)], 'r')
            
            
                 
        case 17
            myfig.CurrentAxes = myax(i);
            hold on
            
            myax(i).Units='centimeters';
            myax(i).Position=[10.1 13.5 7 1.2];
            
            myax(i).XTick = [0 20 40 60 80 100];
            myax(i).XTickLabel = [];
            
          
          Sex=Stats1D.Shoulderplane.(statistic).Forward.nonparam.SPMs{1,1};
           Time=Stats1D.Shoulderplane.(statistic).Forward.nonparam.SPMs{1,2};
           SexxTime=Stats1D.Shoulderplane.(statistic).Forward.nonparam.SPMs{1,3};
           
           if Sex.h0reject
               for icluster=1:Sex.nClusters
                   c=Sex.clusters{1,icluster}.metric_value;
                   x=Sex.clusters{1,icluster}.endpoints;
                   image(x(1),2,repmat(c,1,round(x(2)-x(1))))
               end
           end
           
           if Time.h0reject
               for icluster=1:Time.nClusters
                   c=Time.clusters{1,icluster}.metric_value;
                   x=Time.clusters{1,icluster}.endpoints;
                   image(x(1),5,repmat(c,1,round(x(2)-x(1))))
               end
           end
           
           if SexxTime.h0reject
               for icluster=1:SexxTime.nClusters
                   c=SexxTime.clusters{1,icluster}.metric_value;
                   x=SexxTime.clusters{1,icluster}.endpoints;
                   image(x(1),8,repmat(c,1,round(x(2)-x(1))))
               end
           end
            
%             errorbar([0.5, 1.5], [mean(Y(Sex == 1 & Time == 1)) mean(Y(Sex == 1 & Time == 2))], ...
%                 [std(Y(Sex == 1 & Time == 1))/sqrt(n), std(Y(Sex == 1 & Time == 1))/sqrt(n)])
%             
%             
%             errorbar([0.5, 1.5], [mean(Y(Sex == 2 & Time == 1)) mean(Y(Sex == 2 & Time == 2))], ...
%                 [std(Y(Sex == 2 & Time == 1))/sqrt(n), std(Y(Sex == 2 & Time == 1))/sqrt(n)], 'r')
%             
       
            
        case 18
            myfig.CurrentAxes = myax(i);
            hold on
            
            myax(i).Units='centimeters';
            myax(i).Position=[10.1 9.5 7 1.2];
            
            myax(i).XTick = [0 20 40 60 80 100];
            myax(i).XTickLabel = [];
            
          
            Sex=Stats1D.ShoulderElev.(statistic).Forward.nonparam.SPMs{1,1};
           Time=Stats1D.ShoulderElev.(statistic).Forward.nonparam.SPMs{1,2};
           SexxTime=Stats1D.ShoulderElev.(statistic).Forward.nonparam.SPMs{1,3};
           
           if Sex.h0reject
               for icluster=1:Sex.nClusters
                   c=Sex.clusters{1,icluster}.metric_value;
                   x=Sex.clusters{1,icluster}.endpoints;
                   image(x(1),2,repmat(c,1,round(x(2)-x(1))))
               end
           end
           
           if Time.h0reject
               for icluster=1:Time.nClusters
                   c=Time.clusters{1,icluster}.metric_value;
                   x=Time.clusters{1,icluster}.endpoints;
                   image(x(1),5,repmat(c,1,round(x(2)-x(1))))
               end
           end
           
           if SexxTime.h0reject
               for icluster=1:SexxTime.nClusters
                   c=SexxTime.clusters{1,icluster}.metric_value;
                   x=SexxTime.clusters{1,icluster}.endpoints;
                   image(x(1),8,repmat(c,1,round(x(2)-x(1))))
               end
           end
            
%             errorbar([0.5, 1.5], [mean(Y(Sex == 1 & Time == 1)) mean(Y(Sex == 1 & Time == 2))], ...
%                 [std(Y(Sex == 1 & Time == 1))/sqrt(n), std(Y(Sex == 1 & Time == 1))/sqrt(n)])
%             
%             
%             errorbar([0.5, 1.5], [mean(Y(Sex == 2 & Time == 1)) mean(Y(Sex == 2 & Time == 2))], ...
%                 [std(Y(Sex == 2 & Time == 1))/sqrt(n), std(Y(Sex == 2 & Time == 1))/sqrt(n)], 'r')
            
            
                
        case 19
            myfig.CurrentAxes = myax(i);
            hold on
            
            myax(i).Units='centimeters';
            myax(i).Position=[10.1 5.5 7 1.2];
            
            myax(i).XTick = [0 20 40 60 80 100];
            myax(i).XTickLabel = [];
            
       
           Sex=Stats1D.TrunkRy.(statistic).Forward.nonparam.SPMs{1,1};
           Time=Stats1D.TrunkRy.(statistic).Forward.nonparam.SPMs{1,2};
           SexxTime=Stats1D.TrunkRy.(statistic).Forward.nonparam.SPMs{1,3};
           
           if Sex.h0reject
               for icluster=1:Sex.nClusters
                   c=Sex.clusters{1,icluster}.metric_value;
                   x=Sex.clusters{1,icluster}.endpoints;
                   image(x(1),2,repmat(c,1,round(x(2)-x(1))))
               end
           end
           
           if Time.h0reject
               for icluster=1:Time.nClusters
                   c=Time.clusters{1,icluster}.metric_value;
                   x=Time.clusters{1,icluster}.endpoints;
                   image(x(1),5,repmat(c,1,round(x(2)-x(1))))
               end
           end
           
           if SexxTime.h0reject
               for icluster=1:SexxTime.nClusters
                   c=SexxTime.clusters{1,icluster}.metric_value;
                   x=SexxTime.clusters{1,icluster}.endpoints;
                   image(x(1),8,repmat(c,1,round(x(2)-x(1))))
               end
           end
            
%             errorbar([0.5, 1.5], [mean(Y(Sex == 1 & Time == 1)) mean(Y(Sex == 1 & Time == 2))], ...
%                 [std(Y(Sex == 1 & Time == 1))/sqrt(n), std(Y(Sex == 1 & Time == 1))/sqrt(n)])
%             
%             
%             errorbar([0.5, 1.5], [mean(Y(Sex == 2 & Time == 1)) mean(Y(Sex == 2 & Time == 2))], ...
%                 [std(Y(Sex == 2 & Time == 1))/sqrt(n), std(Y(Sex == 2 & Time == 1))/sqrt(n)], 'r')
%             
            
            
        case 20
            myfig.CurrentAxes = myax(i);
            hold on
            
            myax(i).Units='centimeters';
            myax(i).Position=[10.1 1.5 7 1.2];
            
            myax(i).XTick = [0 20 40 60 80 100];
            myax(i).XTickLabel = [0 20 40 60 80 100];
            
            
                    
           Sex=Stats1D.TrunkRz.(statistic).Forward.nonparam.SPMs{1,1};
           Time=Stats1D.TrunkRz.(statistic).Forward.nonparam.SPMs{1,2};
           SexxTime=Stats1D.TrunkRz.(statistic).Forward.nonparam.SPMs{1,3};
           
           if Sex.h0reject
               for icluster=1:Sex.nClusters
                   c=Sex.clusters{1,icluster}.metric_value;
                   x=Sex.clusters{1,icluster}.endpoints;
                   image(x(1),2,repmat(c,1,round(x(2)-x(1))))
               end
           end
           
           if Time.h0reject
               for icluster=1:Time.nClusters
                   c=Time.clusters{1,icluster}.metric_value;
                   x=Time.clusters{1,icluster}.endpoints;
                   image(x(1),5,repmat(c,1,round(x(2)-x(1))))
               end
           end
           
           if SexxTime.h0reject
               for icluster=1:SexxTime.nClusters
                   c=SexxTime.clusters{1,icluster}.metric_value;
                   x=SexxTime.clusters{1,icluster}.endpoints;
                   image(x(1),8,repmat(c,1,round(x(2)-x(1))))
               end
           end
            
%             errorbar([0.5, 1.5], [mean(Y(Sex == 1 & Time == 1)) mean(Y(Sex == 1 & Time == 2))], ...
%                 [std(Y(Sex == 1 & Time == 1))/sqrt(n), std(Y(Sex == 1 & Time == 1))/sqrt(n)])
%             
%             
%             errorbar([0.5, 1.5], [mean(Y(Sex == 2 & Time == 1)) mean(Y(Sex == 2 & Time == 2))], ...
%                 [std(Y(Sex == 2 & Time == 1))/sqrt(n), std(Y(Sex == 2 & Time == 1))/sqrt(n)], 'r')
%       
            
    end
end