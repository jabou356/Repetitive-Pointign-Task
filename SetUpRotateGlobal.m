function [ Origin, Ry ] = SetUpRotateGlobal( path )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

load(path,'-mat');


VideoLength=length(fieldnames(data.VideoFilt));
TrialLength=length(data.VideoFilt.channel1.xdata);
DistalTargetName='TRGD';
ProximalTargetName='TRGP';
OriginName='CLAV';

%% Find relevent Channels
%Find Proximal and Distal Targets channels in VideoFilt
for i=VideoLength:-1:1
    s=['isTRGD(' num2str(i) ')=strcmp(data.VideoFilt.channel' num2str(i) '.label,DistalTargetName);'];eval(s);
    s=['isTRGP(' num2str(i) ')=strcmp(data.VideoFilt.channel' num2str(i) '.label,ProximalTargetName);'];eval(s);
    s=['isOrigin(' num2str(i) ')=strcmp(data.VideoFilt.channel' num2str(i) '.label,OriginName);'];eval(s);
end

TRGDchan=find(isTRGD);
TRGPchan=find(isTRGP);
Originchan=find(isOrigin);

s=['Origin(1)=mean(data.VideoFilt.channel' num2str(Originchan) '.ydata);'];eval(s);
s=['Origin(2)=mean(data.VideoFilt.channel' num2str(Originchan) '.zdata);'];eval(s);
s=['Origin(3)=mean(data.VideoFilt.channel' num2str(Originchan) '.xdata);'];eval(s);


%% Defining the wanted X axis (TRGP to TRGD) in the current global coordinates
%[X Y Z] vector joining the two targets. It is our final X axis. Mean of 
%static trial to minimize noise.

s=['X1Vector(1)=mean(data.VideoFilt.channel' num2str(TRGDchan) '.ydata-data.VideoFilt.channel' num2str(TRGPchan) '.ydata);'];eval(s);
s=['X1Vector(2)=mean(data.VideoFilt.channel' num2str(TRGDchan) '.zdata-data.VideoFilt.channel' num2str(TRGPchan) '.zdata);'];eval(s);
s=['X1Vector(3)=mean(data.VideoFilt.channel' num2str(TRGDchan) '.xdata-data.VideoFilt.channel' num2str(TRGPchan) '.xdata);'];eval(s);

X1VectorNorm=norm([X1Vector(1) X1Vector(2) X1Vector(3)]); 
X1UnitVector=[X1Vector(1)/X1VectorNorm X1Vector(2)/X1VectorNorm X1Vector(3)/X1VectorNorm];

%% Calculate the rotation needed to get the targeted coordinates (around Y axis)
%[x y 0]=[c ,0,-s;0,1,0; s,0,c][X1UnitVector(1:3)]... isolate rotAngle
%from 0=-s*X1UnitVector(1)+c*X1UnitVector(3)+0*X1UnitVector(2)

rotAngle=atan2(X1UnitVector(3),X1UnitVector(1)); 
Ry=[cos(rotAngle), -sin(rotAngle); sin(rotAngle), cos(rotAngle)]; %Rotation Matrix to apply to all channels

end

