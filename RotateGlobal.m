
function [data] = RotateGlobal(path,Origin,Ry)
%Function used to rotate the global field of reference so it fit the
%recommendation of the International Society of Biomechanics (J. Bmwhanrcs,
%Vol. 28, No. 10. pp. 1257-1261, 1995). The Y axis should be pointing
%upward, the X axis should be pointing in the direction of movement, the Z
%axis should be orthogonal to XY plane. In the RPT, the X axis should be
%aligned with the axis joining the Proximal and Distal targets


%% Load Targets static trials and defining variables
load(path,'-mat');

VideoLength=length(fieldnames(data.VideoData));
TrialLength=length(data.VideoData.channel1.xdata);

[b a]=butter(2,15/50,'low');

%% Translating data so the origin correspond to the OpenSimOrigin.
% The lab reference frame during data 
%collection: z is pointing upward (so it is y). Then change all axes to
%keep the right order (x,y,z)

for i=VideoLength:-1:1
    %% Apply translations
    tempx=data.VideoData.(['channel' num2str(i)]).xdata-Origin(3);
    tempy=data.VideoData.(['channel' num2str(i)]).ydata-Origin(1);
    tempz=data.VideoData.(['channel' num2str(i)]).zdata-Origin(2);
    
    
    %% Apply the rotations
    data.VideoData.(['channel' num2str(i)]).xdata=Ry(1,1)*tempy+Ry(2,1)*tempx;
    data.VideoData.(['channel' num2str(i)]).ydata=tempz;
    data.VideoData.(['channel' num2str(i)]).zdata=Ry(1,2)*tempy+Ry(2,2)*tempx;
    
    %% if there are NaN, replace by zero
    nanx=isnan(data.VideoData.(['channel' num2str(i)]).xdata);
    nany=isnan(data.VideoData.(['channel' num2str(i)]).ydata);
    nanz=isnan(data.VideoData.(['channel' num2str(i)]).zdata);
    
    data.VideoData.(['channel' num2str(i)]).xdata(nanx)=0;
    data.VideoData.(['channel' num2str(i)]).ydata(nany)=0;   
    data.VideoData.(['channel' num2str(i)]).zdata(nanz)=0;
    
    data.VideoData.(['channel' num2str(i)]).xdata=filtfilt(b,a,data.VideoData.(['channel' num2str(i)]).xdata);
    data.VideoData.(['channel' num2str(i)]).ydata=filtfilt(b,a,data.VideoData.(['channel' num2str(i)]).ydata);   
    data.VideoData.(['channel' num2str(i)]).zdata=filtfilt(b,a,data.VideoData.(['channel' num2str(i)]).zdata);
end



