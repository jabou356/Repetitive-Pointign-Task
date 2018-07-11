% this code has been created by Jason Bouffard to partition Relevant markers
% hand degrees of freedom computed with OpenSim into forward and backward
% movements. PartData needs to be computed before using on of OBEL
% function.

doreleventMKR=1;
doDOF=1;
%% Determine names of relevent markers. 

RelevantMKR(1).names = {'CLAV'};
RelevantMKR(2).names = {'RSHO'};
RelevantMKR(3).names = {'RELB'};
RelevantMKR(4).names = {'RWRA'};
RelevantMKR(5).names = {'RIDX', 'RINXF','RDIX'}; % Have different names for different projects

%% Find channel numbers related to those markers

VideoLength = length(fieldnames(data.VideoFilt));
for ichan = VideoLength : -1 : 1
    
    isCLAV(ichan) = strcmp(data.VideoFilt.(['channel' num2str(ichan)]).label,RelevantMKR(1).names);
    isRSHO(ichan) = strcmp(data.VideoFilt.(['channel' num2str(ichan)]).label,RelevantMKR(2).names);
    isRELB(ichan) = strcmp(data.VideoFilt.(['channel' num2str(ichan)]).label,RelevantMKR(3).names);
    isRWRA(ichan) = strcmp(data.VideoFilt.(['channel' num2str(ichan)]).label,RelevantMKR(4).names);
    isRIDX(ichan) = strcmp(data.VideoFilt.(['channel' num2str(ichan)]).label,RelevantMKR(5).names{1}) | ...
        strcmp(data.VideoFilt.(['channel' num2str(ichan)]).label,RelevantMKR(5).names{2}) |...
        strcmp(data.VideoFilt.(['channel' num2str(ichan)]).label,RelevantMKR(5).names{3});

end

RelevantMKR(1).channum = find(isCLAV);
RelevantMKR(2).channum = find(isRSHO);
RelevantMKR(3).channum = find(isRELB);
RelevantMKR(4).channum = find(isRWRA);
RelevantMKR(5).channum = find(isRIDX);

%% Filter joint angles 15Hz lowpass

[b, a]=butter(2, 15/data.Header.VideoHZ*2, 'low');
for ichan = 1:length(fieldnames(data.OSIMDoF))
    
    fdata.OSIMDoF.(['channel' num2str(ichan)]).data...
        = filtfilt(b,a,data.OSIMDoF.(['channel' num2str(ichan)]).data);
    
end

%% Place relevant data in the structure: data.(Forward \ Backward).channame.data 

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
    
    % Variables for interpolation
    x = 1:(finish-start);  
    
    % If it is a forward movement, place data at the end of data.Forward.channame.data
    if isfwd
       
        kfwd = kfwd+1;
        
        if doDOF == 1
            
        %For each OpenSim DoF, place interpolated data
        for ichan = 1:length(fieldnames(data.OSIMDoF)) 
            
            y = fdata.OSIMDoF.(['channel' num2str(ichan)]).data(start:finish-1);
            channame = data.OSIMDoF.(['channel' num2str(ichan)]).label{1};
            data.Forward.(channame)(:,kfwd) = interp1(x,y,1:(length(x)-1)/99:length(x));
            
        end % for ichan
        
        end
        
        if doreleventMKR == 1
        %For each Relevant Marker, place interpolated xdata, ydata & zdata
        for ichan = 1:length(RelevantMKR) 
            
            channum = RelevantMKR(ichan).channum;           
            channame = RelevantMKR(ichan).names{1};

            y = data.VideoFilt.(['channel' num2str(channum)]).xdata(start:finish-1);
            data.Forward.(channame).xdata(:,kfwd) = interp1(x,y,1:(length(x)-1)/99:length(x));
           
            y = data.VideoFilt.(['channel' num2str(channum)]).ydata(start:finish-1);
            data.Forward.(channame).ydata(:,kfwd) = interp1(x,y,1:(length(x)-1)/99:length(x));

            y = data.VideoFilt.(['channel' num2str(channum)]).zdata(start:finish-1);
            data.Forward.(channame).zdata(:,kfwd) = interp1(x,y,1:(length(x)-1)/99:length(x));

        end % for ichan
        
        end
        
   % If it is a backward movement, place data at the end of data.Backward.channame.data
    else % if isfwd
        
        kbwd = kbwd+1;
        
        if doDOF == 1
        %For each OpenSim DoF, place interpolated data
        for ichan = 1:length(fieldnames(data.OSIMDoF))
            
            y = fdata.OSIMDoF.(['channel' num2str(ichan)]).data(start:finish-1);
            channame = data.OSIMDoF.(['channel' num2str(ichan)]).label{1};
            data.Backward.(channame)(:,kbwd) = interp1(x,y,1:(length(x)-1)/99:length(x));
        
        end % for ichan
        end
        
        if doreleventMKR == 1
        %For each Relevant Marker, place interpolated xdata, ydata & zdata
        for ichan = 1:length(RelevantMKR)
            
            channum = RelevantMKR(ichan).channum;
            channame = RelevantMKR(ichan).names{1};

            y = data.VideoFilt.(['channel' num2str(channum)]).xdata(start:finish-1);
            data.Backward.(channame).xdata(:,kbwd) = interp1(x,y,1:(length(x)-1)/99:length(x));
           
            y = data.VideoFilt.(['channel' num2str(channum)]).ydata(start:finish-1);
            data.Backward.(channame).ydata(:,kbwd) = interp1(x,y,1:(length(x)-1)/99:length(x));

            y = data.VideoFilt.(['channel' num2str(channum)]).zdata(start:finish-1);
            data.Backward.(channame).zdata(:,kbwd) = interp1(x,y,1:(length(x)-1)/99:length(x));

        end % for ichan
        end 
        
    end % if isfwd; else
    
    
end % for imvt

