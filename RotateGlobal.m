
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


%% Translating data so the origin correspond to the OpenSimOrigin.
% The lab reference frame during data 
%collection: z is pointing upward (so it is y). Then change all axes to
%keep the right order (x,y,z)

for i=VideoLength:-1:1
  s=['tempx=data.VideoData.channel' num2str(i) '.xdata;'];eval(s);
  s=['tempy=data.VideoData.channel' num2str(i) '.ydata;'];eval(s);
  s=['tempz=data.VideoData.channel' num2str(i) '.zdata;'];eval(s);
    s=['data.VideoData.channel' num2str(i) '.xdata=tempy-Origin(1);'];eval(s);
    s=['data.VideoData.channel' num2str(i) '.ydata=tempz-Origin(2);'];eval(s);
    s=['data.VideoData.channel' num2str(i) '.zdata=tempx-Origin(3);'];eval(s);

    
     s=['data.VideoData.channel' num2str(i) '.xdata=Ry(1,1)*tempy+Ry(2,1)*tempx;'];eval(s);
     s=['data.VideoData.channel' num2str(i) '.zdata=Ry(1,2)*tempy+Ry(2,2)*tempx;'];eval(s);
end





%% Apply the calculated rotation matrix to all data

for i=1:VideoLength
    
    

end
