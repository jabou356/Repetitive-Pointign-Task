%Determine what signal we compare
clear;clc;close all;

signal={'Shoulderplane', 'ShoulderElev', 'ElbowFlex','TrunkRy', 'TrunkRz'};%,'CLAVA-P','RSHOA-P','RELBA-P' ,'RWRAA-P','RIDXA-P','CLAVM-L','RSHOM-L','RELBM-L' ,'RWRAM-L','RIDXM-L','CLAVS-I','RSHOS-I','RELBS-I' ,'RWRAS-I','RIDXS-I'};
statistic={'Mean', 'SD', 'CV'}; %Mean, SD, CV,
variable={'ROMFwd', 'MeanPosFwd', 'ROMBwd', 'MeanPosBwd'}; % ROMFwd, MeanPosFwd, ROMBwd, MeanPosBwd
%project={'Kathryn'};

GenericPathRPT

load([Path.JBAnalyse, 'GroupData0D.mat']);

for isignal = 1 : length(signal)
    
    for istat= 1 : length(statistic)
        
        for ivariable= 1 : length(variable)
            
            disp([signal{isignal}, ', ', statistic{istat}]) 
            [Stats0D.(signal{isignal}).(statistic{istat}).(variable{ivariable}).param,...
                Stats0D.(signal{isignal}).(statistic{istat}).(variable{ivariable}).nonparam]...
                =TwoWayAnova_1rm_0D(Megadatabase, signal{isignal}, statistic{istat}, variable{ivariable});
            
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
