clear; clc;
cond={'NF','FT'};
ChannameOSIM(:)={'Shoulderplane', 'ShoulderElev', 'ElbowFlex','TrunkRy', 'TrunkRz','TrunkRx', 'ShoulderRot'}; % Name of DoF in the MegaDatabase
ChannameMKR(:)={'CLAV','RSHO','RELB' ,'RWRA','RIDX'}; % Name of relevant markers in the MegaDatabase (and Result folder)

ChannameOSIMImport(:)={'elv_angle', 'shoulder_elv',  'elbow_flexion', 'ground_thorax_yRotation', 'ground_thorax_zRotation','ground_thorax_xRotation', 'shoulder_rot'}; % Name of DoF in the result folder

% Get generic Paths
GenericPathRPT

%% Get any existing MegaDatabase0D in Path.GroupDataPath
GroupFile=[Path.GroupDataPath, 'MegaDatabase0D.txt'];

% If their is no existing MegaDatabase0D, initialize one with headers.
if ~exist(GroupFile,'file')
    
    fid=fopen(GroupFile,'w');
    
    headers={'Subject', 'SID', 'Time', 'Project', 'Endurance time', 'Sex'...
        , 'Age', 'Height', 'Weight', 'Signal', 'Mean timingFWD', 'abs timing errorFWD', 'Mean timingBWD', 'abs timing errorBWD', 'Stat', 'MeanPositionFwd', 'ROMFwd', 'MeanPositionBwd', 'ROMBwd'};
    
    fprintf(fid, '%s\t',headers{:});
    fprintf(fid, '\r\n');
    
    fclose(fid);
    
end

% Open the MegaDatabase0D to add data
fid=fopen(GroupFile,'a');

% Give format spect and data to print in the GROUPMEAN file
                format1='%s\t %i\t %i\t %s\t %f\t %s\t %f\t %f\t %f\t %s\t %f\t %f\t %f\t %f\t %s\t';
                format2='%f\t%f\t%f\t%f\r\n';

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
                
                
                  
                if isLEFTflag || isIKflag  % If it is a problematic subject or IK residual error > limit (see IKresidual script): nan
                    
                    towrite2=nan(4,1);
                    
                    timingfwd = nan; 
                    timeerrfwd = nan; 
                    timingbwd = nan;
                    timeerrbwd = nan;
                    
                else %if ok: mean of valid movements mean position and ROM
                    
                    %compute timing variables
                    [timingfwd, timeerrfwd, timingbwd, timeerrbwd]=TimingError(data);
                    
                    
                    meanposfwd=mean(data.Forward.(ChannameOSIMImport{isignal}),1); % mean position forward movement
                    meanposbwd=mean(data.Backward.(ChannameOSIMImport{isignal}),1); % mean position backward movement
                    romfwd=max(data.Forward.(ChannameOSIMImport{isignal}),[],1)-min(data.Forward.(ChannameOSIMImport{isignal}),[],1);  % range of motion forward movement
                    rombwd=max(data.Backward.(ChannameOSIMImport{isignal}),[],1)-min(data.Backward.(ChannameOSIMImport{isignal}),[],1); % range of motion backward movement
                    
                    towrite2=[mean(meanposfwd(~isnan(meanposfwd))); mean(romfwd(~isnan(romfwd))); ...
                        mean(meanposbwd(~isnan(meanposbwd))); mean(rombwd(~isnan(rombwd)))]; % [average of meanposfwd, average of romfwd, average of meanposbwd, average of rombwd]
                    
                end
                
                % Write data identifier (subject, project, trial, signal,
                % stat, etc.)
                towrite1={char([projet, num2str(subjectID(isubject))]), isubject, itrial, projet,  Info.endurance, ...
                    Info.sex, Info.age, Info.height, Info.weight,...
                    ChannameOSIM{isignal}, timingfwd, timeerrfwd, timingbwd, timeerrbwd, 'Mean'};
                
                fprintf(fid,format1,towrite1{:}); % Print trial info
                fprintf(fid,format2,towrite2');  % PRint trial data
                
                
                % Give  data to print in the GROUP STD file
                
                % Write data identifier (subject, project, trial, signal,
                % stat, etc.)
                towrite1={char([projet, num2str(subjectID(isubject))]), isubject, itrial, projet,  Info.endurance, ...
                    Info.sex, Info.age, Info.height, Info.weight,...
                    ChannameOSIM{isignal}, timingfwd, timeerrfwd, timingbwd, timeerrbwd, 'SD'};
                
                if isLEFTflag || isIKflag % If it is a problematic subject or IK residual error > limit (see IKresidual script): nan
                    
                    towrite2=nan(4,1);
                    
                else %if ok: sd of valid movements mean position and ROM
                    
                    towrite2=[std(meanposfwd(~isnan(meanposfwd))); std(romfwd(~isnan(romfwd))); ...
                        std(meanposbwd(~isnan(meanposbwd))); std(rombwd(~isnan(rombwd)))]; % [sd of meanposfwd, sd of romfwd, sd of meanposbwd, sd of rombwd]
                    
                    
                end
                
                fprintf(fid,format1,towrite1{:}); % Print trial info
                fprintf(fid,format2,towrite2'); % Print trial data
                
                
                
                
                % Give  data to print in the GROUP CV file (CV is always SD
                % variable (meanpos or rom) divided by Average ROM variable)
                
                % Write data identifier (subject, project, trial, signal,
                % stat, etc.)
                towrite1={char([projet, num2str(subjectID(isubject))]), isubject, itrial, projet,  Info.endurance, ...
                    Info.sex, Info.age, Info.height, Info.weight,...
                    ChannameOSIM{isignal}, timingfwd, timeerrfwd, timingbwd, timeerrbwd, 'CV'};
                
                if isLEFTflag || isIKflag % If it is a problematic subject or IK residual error > limit (see IKresidual script): nan
                    
                    towrite2=nan(4,1);
                    
                else %if ok: cv of valid movements mean position and ROM
                    
                    towrite2=[std(meanposfwd(~isnan(meanposfwd)))/mean(romfwd(~isnan(romfwd))); std(romfwd(~isnan(romfwd)))/mean(romfwd(~isnan(romfwd))); ...
                        std(meanposbwd(~isnan(meanposbwd)))/mean(rombwd(~isnan(rombwd))); std(rombwd(~isnan(rombwd)))/mean(rombwd(~isnan(rombwd)))]; % [cv of meanposfwd, cv of romfwd, cv of meanposbwd, cv of rombwd]
                    
                    
                end
                
                fprintf(fid,format1,towrite1{:}); %print trial info
                fprintf(fid,format2,towrite2'); %print trial data
                
                clear meanposfwd meanposbwd romfwd rombwd
                
            end
            %
            for isignal = 1:length(ChannameMKR) %For marker positions (do xdata, ydata and z data)
                
                            
                              
                % Write data identifier (subject, project, trial, signal,
                % stat, etc.)
                towrite1x={char([projet, num2str(subjectID(isubject))]), isubject, itrial, projet,  Info.endurance, ...
                    Info.sex, Info.age, Info.height, Info.weight,...
                    [ChannameMKR{isignal}, 'AP'], timingfwd, timeerrfwd, timingbwd, timeerrbwd, 'Mean'};
                towrite1y={char([projet, num2str(subjectID(isubject))]), isubject, itrial, projet,  Info.endurance, ...
                    Info.sex, Info.age, Info.height, Info.weight,...
                    [ChannameMKR{isignal}, 'SI'], timingfwd, timeerrfwd, timingbwd, timeerrbwd, 'Mean'};
                towrite1z={char([projet, num2str(subjectID(isubject))]), isubject, itrial, projet,  Info.endurance, ...
                    Info.sex, Info.age, Info.height, Info.weight,...
                    [ChannameMKR{isignal}, 'ML'], timingfwd, timeerrfwd, timingbwd, timeerrbwd, 'Mean'};
                
                if isLEFTflag  % If it is a problematic subject
                    
                    towrite2x=nan(4,1);
                    towrite2y=nan(4,1);
                    towrite2z=nan(4,1);
                    
                else %if ok: mean of valid movements mean position and ROM
                    
                    meanposfwd.x=mean(data.Forward.(ChannameMKR{isignal}).xdata,1);  % mean position forward movement (x)
                    meanposbwd.x=mean(data.Backward.(ChannameMKR{isignal}).xdata,1);  % mean position backward movement (x)
                    romfwd.x=max(data.Forward.(ChannameMKR{isignal}).xdata,[],1)-min(data.Forward.(ChannameMKR{isignal}).xdata,[],1);  % range of motion forward movement (x)
                    rombwd.x=max(data.Backward.(ChannameMKR{isignal}).xdata,[],1)-min(data.Backward.(ChannameMKR{isignal}).xdata,[],1);  % range of motion backward movement (x)
                    
                    meanposfwd.y=mean(data.Forward.(ChannameMKR{isignal}).ydata,1);  % mean position forward movement (y)
                    meanposbwd.y=mean(data.Backward.(ChannameMKR{isignal}).ydata,1);  % mean position backward movement (y)
                    romfwd.y=max(data.Forward.(ChannameMKR{isignal}).ydata,[],1)-min(data.Forward.(ChannameMKR{isignal}).ydata,[],1); % range of motion forward movement (y)
                    rombwd.y=max(data.Backward.(ChannameMKR{isignal}).ydata,[],1)-min(data.Backward.(ChannameMKR{isignal}).ydata,[],1);% range of motion backward movement (y)
                    
                    meanposfwd.z=mean(data.Forward.(ChannameMKR{isignal}).zdata,1);  % mean position forward movement (z)
                    meanposbwd.z=mean(data.Backward.(ChannameMKR{isignal}).zdata,1); % mean position backward movement (z)
                    romfwd.z=max(data.Forward.(ChannameMKR{isignal}).zdata,[],1)-min(data.Forward.(ChannameMKR{isignal}).zdata,[],1); % range of motion forward movement (z)
                    rombwd.z=max(data.Backward.(ChannameMKR{isignal}).zdata,[],1)-min(data.Backward.(ChannameMKR{isignal}).zdata,[],1);% range of motion backward movement (z)
                    
                    towrite2x=[mean(meanposfwd.x(~isnan(meanposfwd.x))); mean(romfwd.x(~isnan(romfwd.x))); ...
                        mean(meanposbwd.x(~isnan(meanposbwd.x))); mean(rombwd.x(~isnan(rombwd.x)))]; % [average of meanposfwd.x, average of romfwd.x, average of meanposbwd.x, average of rombwd.x]
                    
                    towrite2y=[mean(meanposfwd.y(~isnan(meanposfwd.y))); mean(romfwd.y(~isnan(romfwd.y))); ...
                        mean(meanposbwd.y(~isnan(meanposbwd.y))); mean(rombwd.y(~isnan(rombwd.y)))]; % [average of meanposfwd.y, average of romfwd.y, average of meanposbwd.y, average of rombwd.y]
                    
                    towrite2z=[mean(meanposfwd.z(~isnan(meanposfwd.z))); mean(romfwd.z(~isnan(romfwd.z))); ...
                        mean(meanposbwd.z(~isnan(meanposbwd.z))); mean(rombwd.z(~isnan(rombwd.z)))]; % averagecv of meanposfwd.z, average of romfwd.z, average of meanposbwd.z, average of rombwd.z]
                    
                end
                
                fprintf(fid,format1,towrite1x{:}); %Print trial info x
                fprintf(fid,format2,towrite2x');  % PRint trial x data
                fprintf(fid,format1,towrite1y{:}); %Print trial info y
                fprintf(fid,format2,towrite2y');  % PRint trial y data
                fprintf(fid,format1,towrite1z{:}); %Print trial info z
                fprintf(fid,format2,towrite2z');  % PRint trial z datae
                
                
                % Give  data to print in the GROUP STD file
                
                % Write data identifier (subject, project, trial, signal,
                % stat, etc.)
                towrite1x={char([projet, num2str(subjectID(isubject))]), isubject, itrial, projet,  Info.endurance, ...
                    Info.sex, Info.age, Info.height, Info.weight,...
                    [ChannameMKR{isignal}, 'AP'], timingfwd, timeerrfwd, timingbwd, timeerrbwd, 'SD'};
                towrite1y={char([projet, num2str(subjectID(isubject))]), isubject, itrial, projet,  Info.endurance, ...
                    Info.sex, Info.age, Info.height, Info.weight,...
                    [ChannameMKR{isignal}, 'SI'], timingfwd, timeerrfwd, timingbwd, timeerrbwd, 'SD'};
                towrite1z={char([projet, num2str(subjectID(isubject))]), isubject, itrial, projet,  Info.endurance, ...
                    Info.sex, Info.age, Info.height, Info.weight,...
                    [ChannameMKR{isignal}, 'ML'], timingfwd, timeerrfwd, timingbwd, timeerrbwd, 'SD'};
                
                if isLEFTflag  % If it is a problematic subject
                    
                    towrite2x=nan(4,1);
                    towrite2y=nan(4,1);
                    towrite2z=nan(4,1);
                    
                else %if ok: sd of valid movements mean position and ROM
                    
                    towrite2x=[std(meanposfwd.x(~isnan(meanposfwd.x))); std(romfwd.x(~isnan(romfwd.x))); ...
                        std(meanposbwd.x(~isnan(meanposbwd.x))); std(rombwd.x(~isnan(rombwd.x)))]; % [sd of meanposfwd.x, sd of romfwd.x, sd of meanposbwd.x, sd of rombwd.x]
                    
                    towrite2y=[std(meanposfwd.y(~isnan(meanposfwd.y))); std(romfwd.y(~isnan(romfwd.y))); ...
                        std(meanposbwd.y(~isnan(meanposbwd.y))); std(rombwd.y(~isnan(rombwd.y)))]; % [sd of meanposfwd.y, sd of romfwd.y, sd of meanposbwd.y, sd of rombwd.y]
                    
                    towrite2z=[std(meanposfwd.z(~isnan(meanposfwd.z))); std(romfwd.z(~isnan(romfwd.z))); ...
                        std(meanposbwd.z(~isnan(meanposbwd.z))); std(rombwd.z(~isnan(rombwd.z)))]; % [sd of meanposfwd.z, sd of romfwd.z, sd of meanposbwd.z, sd of rombwd.z]
                    
                end
                
                fprintf(fid,format1,towrite1x{:}); % Print trial info x
                fprintf(fid,format2,towrite2x');  % PRint trial x data
                fprintf(fid,format1,towrite1y{:}); % Pring trial info y
                fprintf(fid,format2,towrite2y');  % PRint trial y data
                fprintf(fid,format1,towrite1z{:}); % Print trial info z
                fprintf(fid,format2,towrite2z');  % PRint trial z data
                
                % Give  data to print in the GROUP CV file (CV is always SD
                % variable (meanpos or rom) divided by Average ROM variable)
                
                % Write data identifier (subject, project, trial, signal,
                % stat, etc.)
                towrite1x={char([projet, num2str(subjectID(isubject))]), isubject, itrial, projet,  Info.endurance, ...
                    Info.sex, Info.age, Info.height, Info.weight,...
                    [ChannameMKR{isignal}, 'AP'], timingfwd, timeerrfwd, timingbwd, timeerrbwd, 'CV'};
                towrite1y={char([projet, num2str(subjectID(isubject))]), isubject, itrial, projet,  Info.endurance, ...
                    Info.sex, Info.age, Info.height, Info.weight,...
                    [ChannameMKR{isignal}, 'SI'], timingfwd, timeerrfwd, timingbwd, timeerrbwd, 'CV'};
                towrite1z={char([projet, num2str(subjectID(isubject))]), isubject, itrial, projet,  Info.endurance, ...
                    Info.sex, Info.age, Info.height, Info.weight,...
                    [ChannameMKR{isignal}, 'ML'], timingfwd, timeerrfwd, timingbwd, timeerrbwd, 'CV'};
                
                if isLEFTflag % If it is a problematic subject
                    
                    towrite2x=nan(4,1);
                    towrite2y=nan(4,1);
                    towrite2z=nan(4,1);
                    
                else %if ok: CV of valid movements mean position and ROM
                    
                    towrite2x=[std(meanposfwd.x(~isnan(meanposfwd.x)))/mean(romfwd.x(~isnan(romfwd.x))); std(romfwd.x(~isnan(romfwd.x)))/mean(romfwd.x(~isnan(romfwd.x))); ...
                        std(meanposbwd.x(~isnan(meanposbwd.x)))/mean(rombwd.x(~isnan(rombwd.x))); std(rombwd.x(~isnan(rombwd.x)))/mean(rombwd.x(~isnan(rombwd.x)))]; % [cv of meanposfwd.x, cv of romfwd.x, cv of meanposbwd.x, cv of rombwd.x]
                    
                    towrite2y=[std(meanposfwd.y(~isnan(meanposfwd.y)))/mean(romfwd.y(~isnan(romfwd.y))); std(romfwd.y(~isnan(romfwd.y)))/mean(romfwd.y(~isnan(romfwd.y))); ...
                        std(meanposbwd.y(~isnan(meanposbwd.y)))/mean(rombwd.y(~isnan(rombwd.y))); std(rombwd.y(~isnan(rombwd.y)))/mean(rombwd.y(~isnan(rombwd.y)))];  % [cv of meanposfwd.y, cv of romfwd.y, cv of meanposbwd.y, cv of rombwd.y]
                    
                    towrite2z=[std(meanposfwd.z(~isnan(meanposfwd.z)))/mean(romfwd.z(~isnan(romfwd.z))); std(romfwd.z(~isnan(romfwd.z)))/mean(romfwd.z(~isnan(romfwd.z))); ...
                        std(meanposbwd.z(~isnan(meanposbwd.z)))/mean(rombwd.z(~isnan(rombwd.z))); std(rombwd.z(~isnan(rombwd.z)))/mean(rombwd.z(~isnan(rombwd.z)))]; % [cv of meanposfwd.z, cv of romfwd.z, cv of meanposbwd.z, cv of rombwd.z]
                    
                end
                
                fprintf(fid,format1,towrite1x{:}); % Print trial info X
                fprintf(fid,format2,towrite2x');  % PRint rial X data
                fprintf(fid,format1,towrite1y{:}); % Print trial info Y
                fprintf(fid,format2,towrite2y');  % PRint trial Y data
                fprintf(fid,format1,towrite1z{:}); % Print trial info Z
                fprintf(fid,format2,towrite2z');  % PRint trial Z data
                
                clear meanposfwd meanposbwd romfwd rombwd
                
                
                if isignal == 3 % If we are working with the elbow marker, add normalised data
                    
                    towrite1normyMEAN={char([projet, num2str(subjectID(isubject))]), isubject, itrial, projet,  Info.endurance, ...
                        Info.sex, Info.age, Info.height, Info.weight,...
                        [ChannameMKR{isignal}, 'NormSI'], timingfwd, timeerrfwd, timingbwd, timeerrbwd, 'Mean'};
                    
                    towrite1normySD={char([projet, num2str(subjectID(isubject))]), isubject, itrial, projet,  Info.endurance, ...
                        Info.sex, Info.age, Info.height, Info.weight,...
                        [ChannameMKR{isignal}, 'NormSI'], timingfwd, timeerrfwd, timingbwd, timeerrbwd, 'SD'};
                    
                    towrite1normyCV={char([projet, num2str(subjectID(isubject))]), isubject, itrial, projet,  Info.endurance, ...
                        Info.sex, Info.age, Info.height, Info.weight,...
                        [ChannameMKR{isignal}, 'NormSI'], timingfwd, timeerrfwd, timingbwd, timeerrbwd, 'CV'};
                    
                    if isLEFTflag  % If it is a problematic subject
                        
                        towrite2normyMEAN=nan(4,1);
                        towrite2normySD=nan(4,1);
                        towrite2normyCV=nan(4,1);
                        
                    else %if OK
                        
                        meanposfwd.normY=mean(data.Forward.(ChannameMKR{isignal}).ynorm,1);  % mean position forward movement (x)
                        meanposbwd.normY=mean(data.Backward.(ChannameMKR{isignal}).ynorm,1);  % mean position backward movement (x)
                        romfwd.normY=max(data.Forward.(ChannameMKR{isignal}).ynorm,[],1)-min(data.Forward.(ChannameMKR{isignal}).ynorm,[],1);  % range of motion forward movement (x)
                        rombwd.normY=max(data.Backward.(ChannameMKR{isignal}).ynorm,[],1)-min(data.Backward.(ChannameMKR{isignal}).ynorm,[],1);  % range of motion backward movement (x)
                        
                        %if ok: MEAN of valid movements mean position and ROM
                        towrite2normyMEAN=[mean(meanposfwd.normY(~isnan(meanposfwd.normY))); mean(romfwd.normY(~isnan(romfwd.normY))); ...
                            mean(meanposbwd.normY(~isnan(meanposbwd.normY))); mean(rombwd.normY(~isnan(rombwd.normY)))]; % [average of meanposfwd.x, average of romfwd.x, average of meanposbwd.x, average of rombwd.x]
                        
                        %if ok: SD of valid movements mean position and ROM
                        towrite2normySD=[std(meanposfwd.normY(~isnan(meanposfwd.normY))); std(romfwd.normY(~isnan(romfwd.normY))); ...
                            std(meanposbwd.normY(~isnan(meanposbwd.normY))); std(rombwd.normY(~isnan(rombwd.normY)))]; % [sd of meanposfwd.x, sd of romfwd.x, sd of meanposbwd.x, sd of rombwd.x]
                        
                        %if ok: CV of valid movements mean position and ROM
                        towrite2normyCV=[std(meanposfwd.normY(~isnan(meanposfwd.normY)))/mean(romfwd.normY(~isnan(romfwd.normY))); std(romfwd.normY(~isnan(romfwd.normY)))/mean(romfwd.normY(~isnan(romfwd.normY))); ...
                            std(meanposbwd.normY(~isnan(meanposbwd.normY)))/mean(rombwd.normY(~isnan(rombwd.normY))); std(rombwd.normY(~isnan(rombwd.normY)))/mean(rombwd.normY(~isnan(rombwd.normY)))]; % [cv of meanposfwd.x, cv of romfwd.x, cv of meanposbwd.x, cv of rombwd.x]
                        
                    end
                    
                    fprintf(fid,format1,towrite1normyMEAN{:}); % Print trial info MEAN normY
                    fprintf(fid,format2,towrite2normyMEAN');  % PRint trial MEAN normy data
                    fprintf(fid,format1,towrite1normySD{:}); % Print trial info SD normY
                    fprintf(fid,format2,towrite2normySD');  % PRint trial SD normy data
                    fprintf(fid,format1,towrite1normyCV{:}); % Print trial info CV normY
                    fprintf(fid,format2,towrite2normyCV');  % PRint trial CV normy data
                    
                end
                
                if isignal == 5 % If we are working with the Index finger marker, add normalised data
                    
                    % Info for mean, SD, CV normX
                    towrite1normxMEAN={char([projet, num2str(subjectID(isubject))]), isubject, itrial, projet,  Info.endurance, ...
                        Info.sex, Info.age, Info.height, Info.weight,...
                        [ChannameMKR{isignal}, 'NormAP'], timingfwd, timeerrfwd, timingbwd, timeerrbwd, 'Mean'};
                    
                    towrite1normxSD={char([projet, num2str(subjectID(isubject))]), isubject, itrial, projet,  Info.endurance, ...
                        Info.sex, Info.age, Info.height, Info.weight,...
                        [ChannameMKR{isignal}, 'NormAP'], timingfwd, timeerrfwd, timingbwd, timeerrbwd, 'SD'};
                    
                    towrite1normxCV={char([projet, num2str(subjectID(isubject))]), isubject, itrial, projet,  Info.endurance, ...
                        Info.sex, Info.age, Info.height, Info.weight,...
                        [ChannameMKR{isignal}, 'NormAP'], timingfwd, timeerrfwd, timingbwd, timeerrbwd, 'CV'};
                    
                    % Info for mean, SD, CV normY
                    towrite1normyMEAN={char([projet, num2str(subjectID(isubject))]), isubject, itrial, projet,  Info.endurance, ...
                        Info.sex, Info.age, Info.height, Info.weight,...
                        [ChannameMKR{isignal}, 'NormSI'], timingfwd, timeerrfwd, timingbwd, timeerrbwd, 'Mean'};
                    
                    towrite1normySD={char([projet, num2str(subjectID(isubject))]), isubject, itrial, projet,  Info.endurance, ...
                        Info.sex, Info.age, Info.height, Info.weight,...
                        [ChannameMKR{isignal}, 'NormSI'], timingfwd, timeerrfwd, timingbwd, timeerrbwd, 'SD'};
                    
                    towrite1normyCV={char([projet, num2str(subjectID(isubject))]), isubject, itrial, projet,  Info.endurance, ...
                        Info.sex, Info.age, Info.height, Info.weight,...
                        [ChannameMKR{isignal}, 'NormSI'], timingfwd, timeerrfwd, timingbwd, timeerrbwd, 'CV'};
                    
                    % Info for mean, SD, CV normZ
                    towrite1normzMEAN={char([projet, num2str(subjectID(isubject))]), isubject, itrial, projet,  Info.endurance, ...
                        Info.sex, Info.age, Info.height, Info.weight,...
                        [ChannameMKR{isignal}, 'NormML'], timingfwd, timeerrfwd, timingbwd, timeerrbwd, 'Mean'};
                    
                    towrite1normzSD={char([projet, num2str(subjectID(isubject))]), isubject, itrial, projet,  Info.endurance, ...
                        Info.sex, Info.age, Info.height, Info.weight,...
                        [ChannameMKR{isignal}, 'NormML'], timingfwd, timeerrfwd, timingbwd, timeerrbwd, 'SD'};
                    
                    towrite1normzCV={char([projet, num2str(subjectID(isubject))]), isubject, itrial, projet,  Info.endurance, ...
                        Info.sex, Info.age, Info.height, Info.weight,...
                        [ChannameMKR{isignal}, 'NormML'], timingfwd, timeerrfwd, timingbwd, timeerrbwd, 'CV'};
                    
                    % Info for mean, SD, CV VectDistance (Distance from target)
                    towrite1dMEAN={char([projet, num2str(subjectID(isubject))]), isubject, itrial, projet,  Info.endurance, ...
                        Info.sex, Info.age, Info.height, Info.weight,...
                        [ChannameMKR{isignal}, 'VectDist'], timingfwd, timeerrfwd, timingbwd, timeerrbwd, 'Mean'};
                    
                    towrite1dSD={char([projet, num2str(subjectID(isubject))]), isubject, itrial, projet,  Info.endurance, ...
                        Info.sex, Info.age, Info.height, Info.weight,...
                        [ChannameMKR{isignal}, 'VectDist'], timingfwd, timeerrfwd, timingbwd, timeerrbwd, 'SD'};
                    
                    towrite1dCV={char([projet, num2str(subjectID(isubject))]), isubject, itrial, projet,  Info.endurance, ...
                        Info.sex, Info.age, Info.height, Info.weight,...
                        [ChannameMKR{isignal}, 'VectDist'], timingfwd, timeerrfwd, timingbwd, timeerrbwd, 'CV'};
                    
                    if isLEFTflag  % If it is a problematic subject
                        
                        towrite2normxMEAN=nan(4,1);
                        towrite2normxSD=nan(4,1);
                        towrite2normxCV=nan(4,1);
                        
                        towrite2normyMEAN=nan(4,1);
                        towrite2normySD=nan(4,1);
                        towrite2normyCV=nan(4,1);
                        
                        towrite2normzMEAN=nan(4,1);
                        towrite2normzSD=nan(4,1);
                        towrite2normzCV=nan(4,1);
                        
                        towrite2dMEAN=nan(4,1);
                        towrite2dSD=nan(4,1);
                        towrite2dCV=nan(4,1);
                        
                    else %if OK
                        
                        meanposfwd.normX=mean(data.Forward.(ChannameMKR{isignal}).xnorm,1);  % mean position forward movement (x)
                        meanposbwd.normX=mean(data.Backward.(ChannameMKR{isignal}).xnorm,1);  % mean position backward movement (x)
                        romfwd.normX=max(data.Forward.(ChannameMKR{isignal}).xnorm,[],1)-min(data.Forward.(ChannameMKR{isignal}).xnorm,[],1);  % range of motion forward movement (x)
                        rombwd.normX=max(data.Backward.(ChannameMKR{isignal}).xnorm,[],1)-min(data.Backward.(ChannameMKR{isignal}).xnorm,[],1);  % range of motion backward movement (x)
                        
                        meanposfwd.normY=mean(data.Forward.(ChannameMKR{isignal}).ynorm,1);  % mean position forward movement (x)
                        meanposbwd.normY=mean(data.Backward.(ChannameMKR{isignal}).ynorm,1);  % mean position backward movement (x)
                        romfwd.normY=max(data.Forward.(ChannameMKR{isignal}).ynorm,[],1)-min(data.Forward.(ChannameMKR{isignal}).ynorm,[],1);  % range of motion forward movement (x)
                        rombwd.normY=max(data.Backward.(ChannameMKR{isignal}).ynorm,[],1)-min(data.Backward.(ChannameMKR{isignal}).ynorm,[],1);  % range of motion backward movement (x)
                        
                        meanposfwd.normZ=mean(data.Forward.(ChannameMKR{isignal}).znorm,1);  % mean position forward movement (x)
                        meanposbwd.normZ=mean(data.Backward.(ChannameMKR{isignal}).znorm,1);  % mean position backward movement (x)
                        romfwd.normZ=max(data.Forward.(ChannameMKR{isignal}).znorm,[],1)-min(data.Forward.(ChannameMKR{isignal}).znorm,[],1);  % range of motion forward movement (x)
                        rombwd.normZ=max(data.Backward.(ChannameMKR{isignal}).znorm,[],1)-min(data.Backward.(ChannameMKR{isignal}).znorm,[],1);  % range of motion backward movement (x)
                        
                        meanposfwd.d=data.Forward.(ChannameMKR{isignal}).vectdist(end,:);  % Vectorial distance between the index marker and the target (end of the forward movement)
                        meanposbwd.d=data.Backward.(ChannameMKR{isignal}).vectdist(end,:);  % % Vectorial distance between the index marker and the target (end of the backward movement)
                        
                        
                        %if ok: MEAN of valid movements mean position and ROM
                        towrite2normxMEAN=[mean(meanposfwd.normX(~isnan(meanposfwd.normX))); mean(romfwd.normX(~isnan(romfwd.normX))); ...
                            mean(meanposbwd.normX(~isnan(meanposbwd.normX))); mean(rombwd.normX(~isnan(rombwd.normX)))]; % [average of meanposfwd.x, average of romfwd.x, average of meanposbwd.x, average of rombwd.x]
                        
                        towrite2normyMEAN=[mean(meanposfwd.normY(~isnan(meanposfwd.normY))); mean(romfwd.normY(~isnan(romfwd.normY))); ...
                            mean(meanposbwd.normY(~isnan(meanposbwd.normY))); mean(rombwd.normY(~isnan(rombwd.normY)))]; % [average of meanposfwd.x, average of romfwd.x, average of meanposbwd.x, average of rombwd.x]
                        
                        towrite2normzMEAN=[mean(meanposfwd.normZ(~isnan(meanposfwd.normZ))); mean(romfwd.normZ(~isnan(romfwd.normZ))); ...
                            mean(meanposbwd.normZ(~isnan(meanposbwd.normZ))); mean(rombwd.normZ(~isnan(rombwd.normZ)))]; % [average of meanposfwd.x, average of romfwd.x, average of meanposbwd.x, average of rombwd.x]
                        
                        towrite2dMEAN=[mean(meanposfwd.d(~isnan(meanposfwd.d))); nan; ...
                            mean(meanposbwd.d(~isnan(meanposbwd.d)));nan]; % [average of meanposfwd.x, average of romfwd.x, average of meanposbwd.x, average of rombwd.x]
                        
                        %if ok: SD of valid movements mean position and ROM
                        towrite2normxSD=[std(meanposfwd.normX(~isnan(meanposfwd.normX))); std(romfwd.normX(~isnan(romfwd.normX))); ...
                            std(meanposbwd.normX(~isnan(meanposbwd.normX))); std(rombwd.normX(~isnan(rombwd.normX)))]; % [sd of meanposfwd.x, sd of romfwd.x, sd of meanposbwd.x, sd of rombwd.x]
                        
                        towrite2normySD=[std(meanposfwd.normY(~isnan(meanposfwd.normY))); std(romfwd.normY(~isnan(romfwd.normY))); ...
                            std(meanposbwd.normY(~isnan(meanposbwd.normY))); std(rombwd.normY(~isnan(rombwd.normY)))]; % [sd of meanposfwd.x, sd of romfwd.x, sd of meanposbwd.x, sd of rombwd.x]
                        
                        towrite2normzSD=[std(meanposfwd.normZ(~isnan(meanposfwd.normZ))); std(romfwd.normZ(~isnan(romfwd.normZ))); ...
                            std(meanposbwd.normZ(~isnan(meanposbwd.normZ))); std(rombwd.normZ(~isnan(rombwd.normZ)))]; % [sd of meanposfwd.x, sd of romfwd.x, sd of meanposbwd.x, sd of rombwd.x]
                        
                        towrite2dSD=[std(meanposfwd.d(~isnan(meanposfwd.d))); nan; ...
                            std(meanposbwd.d(~isnan(meanposbwd.d))); nan]; % [sd of meanposfwd.x, sd of romfwd.x, sd of meanposbwd.x, sd of rombwd.x]
                        
                        %if ok: CV of valid movements mean position and ROM
                        towrite2normxCV=[std(meanposfwd.normX(~isnan(meanposfwd.normX)))/mean(romfwd.normX(~isnan(romfwd.normX))); std(romfwd.normX(~isnan(romfwd.normX)))/mean(romfwd.normX(~isnan(romfwd.normX))); ...
                            std(meanposbwd.normY(~isnan(meanposbwd.normY)))/mean(rombwd.normY(~isnan(rombwd.normY))); std(rombwd.normY(~isnan(rombwd.normY)))/mean(rombwd.normY(~isnan(rombwd.normY)))]; % [cv of meanposfwd.x, cv of romfwd.x, cv of meanposbwd.x, cv of rombwd.x]
                        
                        towrite2normyCV=[std(meanposfwd.normY(~isnan(meanposfwd.normY)))/mean(romfwd.normY(~isnan(romfwd.normY))); std(romfwd.normY(~isnan(romfwd.normY)))/mean(romfwd.normY(~isnan(romfwd.normY))); ...
                            std(meanposbwd.normY(~isnan(meanposbwd.normY)))/mean(rombwd.normY(~isnan(rombwd.normY))); std(rombwd.normY(~isnan(rombwd.normY)))/mean(rombwd.normY(~isnan(rombwd.normY)))]; % [cv of meanposfwd.x, cv of romfwd.x, cv of meanposbwd.x, cv of rombwd.x]
                        
                        towrite2normzCV=[std(meanposfwd.normZ(~isnan(meanposfwd.normZ)))/mean(romfwd.normZ(~isnan(romfwd.normZ))); std(romfwd.normZ(~isnan(romfwd.normZ)))/mean(romfwd.normZ(~isnan(romfwd.normZ))); ...
                            std(meanposbwd.normZ(~isnan(meanposbwd.normZ)))/mean(rombwd.normZ(~isnan(rombwd.normZ))); std(rombwd.normZ(~isnan(rombwd.normZ)))/mean(rombwd.normZ(~isnan(rombwd.normZ)))]; % [cv of meanposfwd.x, cv of romfwd.x, cv of meanposbwd.x, cv of rombwd.x]
                        
                        towrite2dCV=[std(meanposfwd.d(~isnan(meanposfwd.d)))/mean(meanposfwd.d(~isnan(meanposfwd.d))); nan; ...
                            std(meanposbwd.d(~isnan(meanposbwd.d)))/mean(meanposbwd.d(~isnan(meanposbwd.d))); nan]; % [cv of meanposfwd.x, cv of romfwd.x, cv of meanposbwd.x, cv of rombwd.x]
                        
                    end
                    
                    fprintf(fid,format1,towrite1normxMEAN{:}); % Print trial info MEAN normY
                    fprintf(fid,format2,towrite2normxMEAN');  % PRint trial MEAN normy data
                    fprintf(fid,format1,towrite1normxSD{:}); % Print trial info SD normY
                    fprintf(fid,format2,towrite2normxSD');  % PRint trial SD normy data
                    fprintf(fid,format1,towrite1normxCV{:}); % Print trial info CV normY
                    fprintf(fid,format2,towrite2normxCV');  % PRint trial CV normy data
                    
                    fprintf(fid,format1,towrite1normyMEAN{:}); % Print trial info MEAN normY
                    fprintf(fid,format2,towrite2normyMEAN');  % PRint trial MEAN normy data
                    fprintf(fid,format1,towrite1normySD{:}); % Print trial info SD normY
                    fprintf(fid,format2,towrite2normySD');  % PRint trial SD normy data
                    fprintf(fid,format1,towrite1normyCV{:}); % Print trial info CV normY
                    fprintf(fid,format2,towrite2normyCV');  % PRint trial CV normy data
                    
                    fprintf(fid,format1,towrite1normzMEAN{:}); % Print trial info MEAN normY
                    fprintf(fid,format2,towrite2normzMEAN');  % PRint trial MEAN normy data
                    fprintf(fid,format1,towrite1normzSD{:}); % Print trial info SD normY
                    fprintf(fid,format2,towrite2normzSD');  % PRint trial SD normy data
                    fprintf(fid,format1,towrite1normzCV{:}); % Print trial info CV normY
                    fprintf(fid,format2,towrite2normzCV');  % PRint trial CV normy data
                    
                    fprintf(fid,format1,towrite1dMEAN{:}); % Print trial info MEAN normY
                    fprintf(fid,format2,towrite2dMEAN');  % PRint trial MEAN normy data
                    fprintf(fid,format1,towrite1dSD{:}); % Print trial info SD normY
                    fprintf(fid,format2,towrite2dSD');  % PRint trial SD normy data
                    fprintf(fid,format1,towrite1dCV{:}); % Print trial info CV normY
                    fprintf(fid,format2,towrite2dCV');  % PRint trial CV normy data
                    
                    
                    
                end
                
            end
            
            
            
            
        end
        
    end
end


fclose(fid);




