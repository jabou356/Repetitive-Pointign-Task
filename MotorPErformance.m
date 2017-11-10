function [data] = MotorPErformance (data)
% This function has been created by Jason Bouffard to normalise Elbow marker and
%Index finger marker in line to the task objectives. 
%
% ELBOW: 
% data.(Forward or Backward).RELB.ynorm: 
% The vertical position of the elbow marker is expressed as the vertical 
% distance from the mesh barrier %(in mm). Position of the mesh barrier is 
% 22 cm below proximal target. 
%
% INDEX: 
% data.(Forward or Backward).RELB.vectdist: 
% The index finger position is expressed as the vectorial distance (in mm) 
% from the center of the distal  (forward) ot proximal target (backward). 
% The center of the targets are aligned with DTRG and PTRG marker X and Z values 
% and  below its Y coordinate (DTRG - 10 cm or PTRG - 12 cm).
%
% data.(Forward or Backward).RELB.ynorm or znorm:
% Distance from PTRG (backward) and DTRG (forward) Y and Z positions
% PartitionOSIM needs to be computed before.
%
% data.(Forward or Backward).RELB.xnorm:
% Distance from PTRG (forward) and DTRG (backward) x position normalised to
% the distance between targets (beginning of the mvt = 0%, end of the mvt =
% 100%
%
%
% PartitionOSIM needs to be computed before.
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%


%% Determine Proximal and distal target positions
DistalTargetName={'DTRG', 'TRGD'}; % Distal target channel has one of those label
ProximalTargetName={'PTRG', 'TRGP'}; % Distal target channel has one of those label


%Find Proximal and Distal Targets channels in VideoFilt
VideoLength=length(fieldnames(data.VideoFilt));

for i=VideoLength:-1:1
    isTRGD(i)=strcmp(data.VideoFilt.(['channel' num2str(i)]).label,DistalTargetName{1}) +...
        strcmp(data.VideoFilt.(['channel' num2str(i)]).label,DistalTargetName{2});
    isTRGP(i)=strcmp(data.VideoFilt.(['channel' num2str(i)]).label,ProximalTargetName{1}) +...
     strcmp(data.VideoFilt.(['channel' num2str(i)]).label,ProximalTargetName{2});
end
TRGDchan=find(isTRGD);
TRGPchan=find(isTRGP);

% Distal target marker XYZ coordinates
TRGD.X = nanmean(data.VideoFilt.(['channel' num2str(TRGDchan)]).xdata);
TRGD.Y = nanmean(data.VideoFilt.(['channel' num2str(TRGDchan)]).ydata);
TRGD.Z = nanmean(data.VideoFilt.(['channel' num2str(TRGDchan)]).zdata);
% Proximal target marker XYZ coordinates
TRGP.X = nanmean(data.VideoFilt.(['channel' num2str(TRGPchan)]).xdata);
TRGP.Y = nanmean(data.VideoFilt.(['channel' num2str(TRGPchan)]).ydata);
TRGP.Z = nanmean(data.VideoFilt.(['channel' num2str(TRGPchan)]).zdata);

%% Normalize elbow vertical and index position
% For each forward movements...
for imvt = size(data.Forward.RELB.ydata,2):-1:1
    
    % Elbow: Distance from the mesh (22 cm below TRGP)
    data.Forward.RELB.ynorm = data.Forward.RELB.ydata - TRGP.Y + 220;
    
    % Index : Vectorial distance from the middle of TRGD (10 cm below TRGD
    % marker
    x = data.Forward.RIDX.xdata - TRGD.X;
    y = data.Forward.RIDX.ydata - TRGD.Y + 100;
    z = data.Forward.RIDX.zdata - TRGD.Z;
   data.Forward.RIDX.vectdist = sqrt(x.^2 + y.^2 + z.^2);
    
    % Normalise trajectory of Index finger (y and z: distance from a
    % straight line). x normalised forward distance, PTRG = 0%, DTRG = 100%
    data.Forward.RIDX.ynorm = y;
    data.Forward.RIDX.znorm = z;
    data.Forward.RIDX.xnorm = (x - TRGP.X) / (TRGD.X - TRGP.X) * 100;
    
    
end % for imvt

% For each backward movements...
for imvt = size(data.Backward.RELB.ydata,2):-1:1
    
    % Elbow: Distance from the mesh (22 cm below TRGP)
    data.Backward.RELB.ynorm = data.Backward.RELB.ydata - TRGP.Y + 220;
    
    % Index : Vectorial distance from the middle of TRGP (12 cm below TRGP
    % marker
    x = data.Backward.RIDX.xdata - TRGP.X;
    y = data.Backward.RIDX.ydata - TRGP.Y + 120;
    z = data.Backward.RIDX.zdata - TRGP.Z;
    data.Backward.RIDX.vectdist = sqrt(x.^2 + y.^2 + z.^2);
    
    % Normalise trajectory of Index finger (y and z: distance from a
    % straight line). x normalised backward distance, DTRG = 0%, PTRG = 100%
    data.Backward.RIDX.ynorm = y;
    data.Backward.RIDX.znorm = z;
    data.Backward.RIDX.xnorm = -(x - TRGD.X) / (TRGD.X - TRGP.X) * 100;
    
    
end % for imvt

