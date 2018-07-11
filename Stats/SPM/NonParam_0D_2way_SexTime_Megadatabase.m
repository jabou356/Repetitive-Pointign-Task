%Determine what signal we compare
clear;clc;close all;
do0D=1;
do1D=0;

if do0D
signal = {'Shoulderplane', 'ShoulderElev', 'ElbowFlex','TrunkRy', 'TrunkRz','TrunkRx', 'ShoulderRot','RIDXNormAP','RIDXNormML','RIDXNormSI','RELBNormSI','RIDXVectDist'};
statistic={'Mean', 'SD', 'CV'}; %Mean, SD, CV,
variable={'ROMFwd', 'MeanPosFwd', 'ROMBwd', 'MeanPosBwd'}; % ROMFwd, MeanPosFwd, ROMBwd, MeanPosBwd
end

if do1D
    signal={'Shoulderplane', 'ShoulderElev', 'ElbowFlex','TrunkRy', 'TrunkRz','TrunkRx', 'ShoulderRot','RIDXNormAP','RIDXNormML','RIDXNormSI','RELBNormSI','RIDXVectDist'};
statistic={'Mean', 'SD', }; %Mean, SD, CV,
variable={'Forward', 'Backward'}; % ROMFwd, MeanPosFwd, ROMBwd, MeanPosBwd
end
%project={'Kathryn'};

GenericPathRPT

if do0D==1
load([Path.JBAnalyse, 'GroupData0D.mat']);
end

if do1D == 1
    load([Path.JBAnalyse, 'GroupData1D.mat']);
end

for isignal = 1 : length(signal)
    
    for istat= 1 : length(statistic)
        
        for ivariable= 1 : length(variable)
            
            disp([signal{isignal}, ', ', statistic{istat}, ', ', variable{ivariable}]) 
            
            if do0D==1
            [Stats0D.(signal{isignal}).(statistic{istat}).(variable{ivariable}).param,...
                Stats0D.(signal{isignal}).(statistic{istat}).(variable{ivariable}).nonparam]...
                =TwoWayAnova_1rm_0D(Megadatabase, signal{isignal}, statistic{istat}, variable{ivariable});
            end
            
            if do1D==1
            [Stats1D.(signal{isignal}).(statistic{istat}).(variable{ivariable}).param,...
                Stats1D.(signal{isignal}).(statistic{istat}).(variable{ivariable}).nonparam]...
                =TwoWayAnova_1rm_1D(Megadatabase, signal{isignal}, statistic{istat}, variable{ivariable});
            end
        end
        
    end
    
end

%% Generate Summary Tables
% 
% 
% clf
% subplot(2,1,1)
% plot([1, 2], [mean(Y(Sex==1 & Time==1));mean(Y(Sex==1 & Time==2))],'bo-')
% hold on
% plot([1, 2], [mean(Y(Sex==2 & Time==1));mean(Y(Sex==2 & Time==2))],'mo-')
% 
% % plot([1, 2], [Y(Sex==1 & Time==1);Y(Sex==1 & Time==2)],'bo-')
% %  hold on
% %  plot([1, 2], [Y(Sex==2 & Time==1);Y(Sex==2 & Time==2)],'mo-')
% 
% subplot(2,1,2)
% plot([FFni.SPMs{1,1}.z,FFni.SPMs{1,2}.z,FFni.SPMs{1,3}.z],'ko') 
% hold on
% plot([FFni.SPMs{1,1}.zstar,FFni.SPMs{1,2}.zstar,FFni.SPMs{1,3}.zstar],'r') 
% plot([FFpi.SPMs{1,1}.zstar,FFpi.SPMs{1,2}.zstar,FFpi.SPMs{1,3}.zstar],'g') 
%  
% 
