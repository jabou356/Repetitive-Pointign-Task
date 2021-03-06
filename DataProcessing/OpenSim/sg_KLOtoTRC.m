%% KLO to TRC
% Written by Shaheen Ghayourmanesh on 2017-02-15
% This script converts KLO files to TRC (Track Row Column) file format.
% This is useful for loading the data in OpenSim.
% Look here for .trc file format spec: http://simtk-confluence.stanford.edu:8080/display/OpenSim/Marker+%28.trc%29+Files

function sg_KLOtoTRC()
%% Reading File Names
FileType='*.klo';
MultiSelect = 'on';
TextMsg = 'Select all the .klo files of interest:';
ErrorMsg = 'No klo file is selected!';
[fName,pathStr] = uigetfile(FileType, 'multiselect', MultiSelect ,TextMsg);
if isequal(fName,0)
    errordlg(ErrorMsg,'ERROR','modal');
    return;
end
if ~iscell(fName)
    fName = {fName};
end
fName = cellfun(@(x)[pathStr x],fName,'uni',false);

%% Creating output file names
outFileName = cellfun(@(x) [x(1:end-3),'trc'],fName,'uni',false);

%% Read files one by one and then export them
for ci = 1:numel(fName)
    load(fName{ci},'-mat');
    
    % TRC File Header
    PathFileType       = 4;
    datatype           = '(X/Y/Z)';
    [~,tempName,~]     = fileparts(outFileName{ci});
    tempName           = [tempName,'.trc'];
    DataRate           = data.Header.VideoHZ;
    CameraRate         = DataRate;
    NumFrames          = data.Header.EndVideoFrame - data.Header.FirstVideoFrame + 1;
    NumMarkers         = data.Header.NumMarkers;
    Units              = 'mm';
    OrigDataRate       = DataRate;
    OrigDataStartFrame = data.Header.FirstVideoFrame;
    OrigNumFrames      = NumFrames;
    
    if NumMarkers < 1
        uiwait(warndlg(['There is NO MARKER in: ' fName{ci}],'!! Warning !!'));
        continue;
    end
    
    % Opening the TRC file for writing
    fid = fopen(outFileName{ci}, 'w');
    if fid < 0
        ErrorMsg = [outFileName{ci} ' could not be opened for writing!'];
        errordlg(ErrorMsg,'ERROR','modal');
        return;
    end
    
    % Writing the TRC File Header
    fprintf(fid, 'PathFileType\t%d\t%s\t%s\t\n', PathFileType, datatype, tempName);
    fprintf(fid, 'DataRate\tCameraRate\tNumFrames\tNumMarkers\tUnits\tOrigDataRate\tOrigDataStartFrame\tOrigNumFrames\n');
    fprintf(fid, '%d\t%d\t%d\t%d\t%s\t%d\t%d\t%d\n', ...
        DataRate, CameraRate, NumFrames, NumMarkers, Units, OrigDataRate, OrigDataStartFrame, OrigNumFrames);
    
    % Writing the TRC Column Labels
    channels = fieldnames(data.VideoData);
    if ~iscell(channels)
        errordlg(['There is no marker in the dataset: ',fName{ci}],'Error in reading the structure');
    end
    tempString1 = sprintf('Frame#\tTime\t');
    tempString2 = sprintf('\n\t\t');
    for cj=1:numel(channels)
        tempString1 = sprintf('%s%s\t\t\t',tempString1,data.VideoData.(channels{cj}).label);
        tempString2 = sprintf('%sX%d\tY%d\tZ%d\t',tempString2,cj,cj,cj);
    end
    fprintf(fid, '%s%s\n\n',tempString1,tempString2);
    clear tempString1 tempString2;
    
    % Writing the TRC Rows of Data
    dataPoints = zeros(NumFrames,3*numel(channels));
    for cj=1:numel(channels)
        colIndex = 1+(cj-1)*3: 3+(cj-1)*3;
        dataPoints(:,colIndex) = [ data.VideoData.(channels{cj}).xdata data.VideoData.(channels{cj}).ydata data.VideoData.(channels{cj}).zdata];
    end
    time  = (0:NumFrames-1)'/DataRate;
    
    for cj=1:NumFrames
        fprintf(fid, '%d\t',cj);
        fprintf(fid, '%.5f\t',[time(cj) dataPoints(cj,:)]);
        fprintf(fid, '\n');
    end
    
    % Closing the TRC file
    fclose(fid);
end
fclose('all');
end

