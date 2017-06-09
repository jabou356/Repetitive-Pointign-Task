function [ Origin, Ry ] = SetUpRotateGlobal( path )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

load(path,'-mat');


VideoLength=length(fieldnames(data.VideoData));
TrialLength=length(data.VideoData.channel1.xdata);
DistalTargetName='TRGD';
ProximalTargetName='TRGP';
OriginName='CLAV';

%% Find relevent Channels
%Find Proximal and Distal Targets channels in VideoData
for i=VideoLength:-1:1
    isTRGD(i)=strcmp(data.VideoData.(['channel' num2str(i)]).label,DistalTargetName);
    isTRGP(i)=strcmp(data.VideoData.(['channel' num2str(i)]).label,ProximalTargetName);
    isOrigin(i)=strcmp(data.VideoData.(['channel' num2str(i)]).label,OriginName);
end

TRGDchan=find(isTRGD);
TRGPchan=find(isTRGP);
Originchan=find(isOrigin);

Origin(1)=nanmean(data.VideoData.(['channel' num2str(Originchan)]).ydata);
Origin(2)=nanmean(data.VideoData.(['channel' num2str(Originchan)]).zdata);
Origin(3)=nanmean(data.VideoData.(['channel' num2str(Originchan)]).xdata);


%% Defining the wanted X axis (TRGP to TRGD) in the current global coordinates
%[X Y Z] vector joining the two targets. It is our final X axis. Mean of 
%static trial to minimize noise.

X1Vector(1)=nanmean(data.VideoData.(['channel' num2str(TRGDchan)]).ydata-data.VideoData.(['channel' num2str(TRGPchan)]).ydata);
X1Vector(2)=nanmean(data.VideoData.(['channel' num2str(TRGDchan)]).zdata-data.VideoData.(['channel' num2str(TRGPchan)]).zdata);
X1Vector(3)=nanmean(data.VideoData.(['channel' num2str(TRGDchan)]).xdata-data.VideoData.(['channel' num2str(TRGPchan)]).xdata);

X1VectorNorm=norm([X1Vector(1) X1Vector(2) X1Vector(3)]); 
X1UnitVector=[X1Vector(1)/X1VectorNorm X1Vector(2)/X1VectorNorm X1Vector(3)/X1VectorNorm];

%% Calculate the rotation needed to get the targeted coordinates (around Y axis)
%[x y 0]=[c ,0,-s;0,1,0; s,0,c][X1UnitVector(1:3)]... isolate rotAngle
%from 0=-s*X1UnitVector(1)+c*X1UnitVector(3)+0*X1UnitVector(2)

rotAngle=atan2(X1UnitVector(3),X1UnitVector(1)); 
Ry=[cos(rotAngle), -sin(rotAngle); sin(rotAngle), cos(rotAngle)]; %Rotation Matrix to apply to all channels

end

