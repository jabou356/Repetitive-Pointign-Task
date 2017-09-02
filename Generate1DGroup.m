clear; clc;
cond={'NF','FT'};
ChannameOSIM(:)={'Shoulderplane', 'ShoulderElev', 'ElbowFlex','TrunkRy', 'TrunkRz'}; % Name of DoF in the MegaDatabase
ChannameMKR(:)={'CLAV','RSHO','RELB' ,'RWRA','RIDX'}; % Name of relevant markers in the MegaDatabase (and Result folder)

ChannameOSIMImport(:)={'elv_angle', 'shoulder_elv',  'elbow_flexion', 'ground_thorax_yRotation', 'ground_thorax_zRotation'}; % Name of DoF in the result folder

% Get generic Paths
GenericPathRPT

%% Get any existing MegaDatabase1D in Path.GroupDataPath
GroupFile=[Path.GroupDataPath, 'MegaDatabase1D.txt'];

% If their is no existing MegaDatabase1D, initialize one with headers.
if ~exist(GroupFile,'file')
    
    fid=fopen(GroupFile,'w');
    
    headers={'Subject', 'SID', 'Time', 'Project', 'Endurance time', 'Sex'...
        , 'Age', 'Height', 'Weight', 'Signal', 'Stat'};
    
    for i=100:-1:1
        
        headersfwd{i}=['Forward', num2str(i)];
        headersbwd{i}=['Bacward', num2str(i)];
        
    end
    
    fprintf(fid, '%s\t',headers{:});
    fprintf(fid, '%s\t',headersfwd{:});
    fprintf(fid, '%s\t',headersbwd{:});
    fprintf(fid, '\r\n');
    
    fclose(fid);
    
end

% Open the MegaDatabase1D to add data
fid=fopen(GroupFile,'a');

%% For the selected Project (in GenericPathRPT.m): Identify the number of subjects and attribute SID
d=dir(Path.DataPath);
j=0;
for i=1:length(d)
    if length(d(i).name)>6
        if strcmp(d(i).name(1:7),'Subject')==1
            j=j+1;
            subjectID(j)=str2num(d(i).name(8:end));
        end
    end
end

%% For each subject of the project, add data to the MegaDatabase1D
for isubject=1:length(subjectID) % for all subject
    disp(['Processing subject #' num2str(subjectID(isubject)) ' (' num2str(isubject) ' out of ' num2str(length(subjectID)) ')'])
    
    % Get subjects paths
    SubjectPathRPT;
    
    % Load file containing participant's info (age, sex, height, weight,
    % endurance time.
    load([Path.SubjectPath, 'Info.mat'])
    
    % In the exportPath (result folder), find the TrialX.klo files and sort in
    % ascending order to get the first and last trial
    Klofiles=arrayfun(@(x)(x.name),dir([Path.exportPath '*.klo']),'UniformOutput',0);
    
    Klofiles=sort(Klofiles(strncmp(Klofiles,'Trial',5)));
    
    % Identify problematic subjects
    isIKflag=exist([Path.exportPath, 'flagIK.txt'],'file');
    isLEFTflag=exist([Path.exportPath, 'Lefthanded.txt'],'file');
    
    
    if length(Klofiles)>1% To keep just the first and last file
        Klofiles=([Klofiles(1); Klofiles(end)]);
        
        
        for itrial = 1 : length(cond)
            
            %Import .klo file
            load([Path.exportPath Klofiles{itrial}], '-mat', 'data');
            
            for isignal = 1:length(ChannameOSIMImport)
                
                
                % Give format spect and data to print in the GROUPMEAN file
                format1='%s\t %i\t %i\t %s\t %f\t %s\t %f\t %f\t %f\t %s\t %s\t';
                format2=[repmat('%s\t', 1,200), '\r\n'];
                
                % Write data identifier (subject, project, trial, signal,
                % stat, etc.)
                towrite1={char([projet, num2str(subjectID(isubject))]), isubject, itrial, projet,  Info.endurance, ...
                    Info.sex, Info.age, Info.height, Info.weight,...
                    ChannameOSIM{isignal}, 'Mean'};
                
                if isLEFTflag || isIKflag % If it is a problematic subject or IK residual error > limit (see IKresidual script): nan
                    
                    towrite2=nan(200,1);
                    
                else %if ok: mean of valid movements (1:100 = forward, 101:200= backward)
                    
                    towrite2=[mean(data.Forward.(ChannameOSIMImport{isignal})(:,~isnan(data.Forward.(ChannameOSIMImport{isignal})(1,:))),2);...
                        mean(data.Backward.(ChannameOSIMImport{isignal})(:,~isnan(data.Backward.(ChannameOSIMImport{isignal})(1,:))),2)];
                    
                end
                
                fprintf(fid,format1,towrite1{:}); % Print trial info
                fprintf(fid,format2,towrite2');  % PRint trial data
                
                
                % Give  data to print in the GROUP STD file
                
                 % Write data identifier (subject, project, trial, signal,
                % stat, etc.)
                towrite1={char([projet, num2str(subjectID(isubject))]), isubject, itrial, projet,  Info.endurance, ...
                    Info.sex, Info.age, Info.height, Info.weight,...
                    ChannameOSIM{isignal}, 'SD'}; % Only difference is 'SD' instead of 'Mean
                
                if isLEFTflag || isIKflag % If it is a problematic subject or IK residual error > limit (see IKresidual script): nan
                    
                    towrite2=nan(200,1);
                    
                else %if ok: SD of valid movements (1:100 = forward, 101:200= backward)
                    
                    towrite2=[std(data.Forward.(ChannameOSIMImport{isignal})(:,~isnan(data.Forward.(ChannameOSIMImport{isignal})(1,:))),0,2);...
                        std(data.Backward.(ChannameOSIMImport{isignal})(:,~isnan(data.Backward.(ChannameOSIMImport{isignal})(1,:))),0,2)];
                    
                end
                
                fprintf(fid,format1,towrite1{:});
                fprintf(fid,format2,towrite2');
                
            end
            
            for isignal = 1:length(ChannameMKR) %For marker positions (do xdata, ydata and z data)
                
                % Give format spect and data to print in the GROUPMEAN file
                format1='%s\t %i\t %i\t %s\t %f\t %s\t %f\t %f\t %f\t %s\t %s\t';
                format2=[repmat('%s\t', 1,200), '\r\n'];
                
                 % Write data identifier (subject, project, trial, signal,
                % stat, etc.)
                towrite1x={char([projet, num2str(subjectID(isubject))]), isubject, itrial, projet,  Info.endurance, ...
                    Info.sex, Info.age, Info.height, Info.weight,...
                    [ChannameMKR{isignal}, 'A-P'], 'Mean'};
                towrite1y={char([projet, num2str(subjectID(isubject))]), isubject, itrial, projet,  Info.endurance, ...
                    Info.sex, Info.age, Info.height, Info.weight,...
                    [ChannameMKR{isignal}, 'S-I'], 'Mean'};
                towrite1z={char([projet, num2str(subjectID(isubject))]), isubject, itrial, projet,  Info.endurance, ...
                    Info.sex, Info.age, Info.height, Info.weight,...
                    [ChannameMKR{isignal}, 'M-L'], 'Mean'};
                
                if isLEFTflag  % If it is a problematic subject 
                    
                    towrite2x=nan(200,1);
                    towrite2y=nan(200,1);
                    towrite2z=nan(200,1);
                    
                else %if ok: mean of valid movements (1:100 = forward, 101:200= backward)
                    
                    towrite2x=[mean(data.Forward.(ChannameMKR{isignal}).xdata(:,~isnan(data.Forward.(ChannameMKR{isignal}).xdata(1,:))),2);...
                        mean(data.Backward.(ChannameMKR{isignal}).xdata(:,~isnan(data.Backward.(ChannameMKR{isignal}).xdata(1,:))),2)];
                    
                    towrite2y=[mean(data.Forward.(ChannameMKR{isignal}).ydata(:,~isnan(data.Forward.(ChannameMKR{isignal}).ydata(1,:))),2);...
                        mean(data.Backward.(ChannameMKR{isignal}).ydata(:,~isnan(data.Backward.(ChannameMKR{isignal}).ydata(1,:))),2)];
                    
                    towrite2z=[mean(data.Forward.(ChannameMKR{isignal}).zdata(:,~isnan(data.Forward.(ChannameMKR{isignal}).zdata(1,:))),2);...
                        mean(data.Backward.(ChannameMKR{isignal}).zdata(:,~isnan(data.Backward.(ChannameMKR{isignal}).zdata(1,:))),2)];
                    
                end
                
                fprintf(fid,format1,towrite1x{:});
                fprintf(fid,format2,towrite2x');  % PRint the groupmeanFile
                fprintf(fid,format1,towrite1y{:});
                fprintf(fid,format2,towrite2y');  % PRint the groupmeanFile
                fprintf(fid,format1,towrite1z{:});
                fprintf(fid,format2,towrite2z');  % PRint the groupmeanFile
                
                
                % Give  data to print in the GROUP STD file
                
                % Write data identifier (subject, project, trial, signal,
                % stat, etc.)
                towrite1x={char([projet, num2str(subjectID(isubject))]), isubject, itrial, projet,  Info.endurance, ...
                    Info.sex, Info.age, Info.height, Info.weight,...
                    [ChannameMKR{isignal}, 'A-P'], 'SD'};
                towrite1y={char([projet, num2str(subjectID(isubject))]), isubject, itrial, projet,  Info.endurance, ...
                    Info.sex, Info.age, Info.height, Info.weight,...
                    [ChannameMKR{isignal}, 'S-I'], 'SD'};
                towrite1z={char([projet, num2str(subjectID(isubject))]), isubject, itrial, projet,  Info.endurance, ...
                    Info.sex, Info.age, Info.height, Info.weight,...
                    [ChannameMKR{isignal}, 'M-L'], 'SD'};
                
                if isLEFTflag   % If it is a problematic subject
                    
                    towrite2x=nan(200,1);
                    towrite2y=nan(200,1);
                    towrite2z=nan(200,1);
                    
                else %if ok: SD of valid movements (1:100 = forward, 101:200= backward)
                    
                    towrite2x=[std(data.Forward.(ChannameMKR{isignal}).xdata(:,~isnan(data.Forward.(ChannameMKR{isignal}).xdata(1,:))),0,2);...
                        std(data.Backward.(ChannameMKR{isignal}).xdata(:,~isnan(data.Backward.(ChannameMKR{isignal}).xdata(1,:))),0,2)];
                    
                    towrite2y=[std(data.Forward.(ChannameMKR{isignal}).ydata(:,~isnan(data.Forward.(ChannameMKR{isignal}).ydata(1,:))),0,2);...
                        std(data.Backward.(ChannameMKR{isignal}).ydata(:,~isnan(data.Backward.(ChannameMKR{isignal}).ydata(1,:))),0,2)];
                    
                    towrite2z=[std(data.Forward.(ChannameMKR{isignal}).zdata(:,~isnan(data.Forward.(ChannameMKR{isignal}).zdata(1,:))),0,2);...
                        std(data.Backward.(ChannameMKR{isignal}).zdata(:,~isnan(data.Backward.(ChannameMKR{isignal}).zdata(1,:))),0,2)];
                    
                end
                
                fprintf(fid,format1,towrite1x{:});
                fprintf(fid,format2,towrite2x');  % PRint the groupSDFile
                fprintf(fid,format1,towrite1y{:});
                fprintf(fid,format2,towrite2y');  % PRint the groupSDFile
                fprintf(fid,format1,towrite1z{:});
                fprintf(fid,format2,towrite2z');  % PRint the groupSDFile
                
            end
                
                
            
            
        end
        
    end
    
end
fclose(fid);




