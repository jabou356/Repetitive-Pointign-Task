function [timingfwd, timeerrfwd, timingbwd, timeerrbwd] =   TimingError(data)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


RIDXnames = {'RIDX', 'RINXF','RDIX'}; % Have different names for different projects

%% Find channel numbers related to those index to identify forward movements

VideoLength = length(fieldnames(data.VideoFilt));
for ichan = VideoLength : -1 : 1

    isRIDX(ichan) = strcmp(data.VideoFilt.(['channel' num2str(ichan)]).label,RIDXnames{1}) | ...
        strcmp(data.VideoFilt.(['channel' num2str(ichan)]).label,RIDXnames{2}) |...
        strcmp(data.VideoFilt.(['channel' num2str(ichan)]).label,RIDXnames{3});

end

% Initialize number of forward (kfwd) and backward (kbwd) movements
kfwd = 0;
kbwd = 0;

% For each movement...
for imvt = 1:length(data.PartData.Xvideo)-1
    
    % Find the already defined start and end of the movement
    start = data.PartData.Xvideo(imvt);
    finish = data.PartData.Xvideo(imvt+1);
    
    % If endpoint xdata increase with time, it is a forward movment
    isfwd = data.VideoFilt.(['channel' num2str(find(isRIDX))]).xdata(finish) - ...
        data.VideoFilt.(['channel' num2str(find(isRIDX))]).xdata(start) > 0; 
    
   
    
    % If it is a forward movement, place data at the end of data.Forward.channame.data
    if isfwd
       
        kfwd = kfwd+1;
        
       mvttimingfwd(kfwd) = data.PartData.Xtime(imvt+1)-data.PartData.Xtime(imvt);
       mvterrorfwd(kfwd) = abs(mvttimingfwd(kfwd) - 1);
        
   % If it is a backward movement, place data at the end of data.Backward.channame.data
    else % if isfwd
        
        kbwd = kbwd+1;
        
        mvttimingbwd(kbwd) = data.PartData.Xtime(imvt+1)-data.PartData.Xtime(imvt);
       mvterrorbwd(kbwd) = abs(mvttimingbwd(kbwd) - 1);
        
        
    end % if isfwd; else
    
    
end % for imvt

timingfwd = mean(mvttimingfwd);
timeerrfwd = mean(mvterrorfwd);
timingbwd = mean(mvttimingbwd);
timeerrbwd = mean(mvterrorbwd);

end

