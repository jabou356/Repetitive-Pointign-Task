clear; clc;

%% Select analyses you want to do (flag = 1 if you want to do it)
FlagRotate = 0;
FlagTRC = 0;
FlagScaling = 0;
FlagIK = 0;
FlagIKResidual = 0;
FlagMot2KLO = 0;
FlagCleanData = 0;

%% Configure Mot2Klo
useold=0; % Do you want to use an old Result Klo file

DoF={'ground_thorax_xRotation' 'ground_thorax_yRotation' 'ground_thorax_zRotation'...
    'ground_thorax_xTranslation' 'ground_thorax_yTranslation' 'ground_thorax_zTranslation'...
    'elv_angle' 'shoulder_elv' 'shoulder_rot'...
    'elbow_flexion' 'pro_sup' 'deviation' 'flexion'}; % Which DoF you want to import from OpenSim


%% Configure CleanData
% Flags to indicate if we want to clean Markers and/OR joint angles (DoF)
dorelevantMKR=0;
doDOF=1;

%Channames we may want to clean
ChannameImport(:)={'RIDX','RWRA','RELB','RSHO','CLAV','elv_angle', 'shoulder_elv', 'elbow_flexion','ground_thorax_yRotation', 'ground_thorax_zRotation', 'ground_thorax_xRotation', 'shoulder_rot'};

%% Load generic paths, include selecting the project you are working on (e.g. Asha)
GenericPathRPT

%% Identify subjects folders in the selected project folder
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

%% For each subject, perform selected analyses
for isubject=1:length(subjectID)
    
    disp(['Processing subject #' num2str(subjectID(isubject)) ' (' num2str(isubject) ' out of ' num2str(length(subjectID)) ')'])
    
    
    SubjectPathRPT; % Load subject specific Paths
    
    %% Rotate and translate global reference frame: 0 = CLAV Marker, X = Forward, Y = Up, Z = Right
    if FlagRotate
        
        rawfilt_OBLJB('filesnames', [Path.KLOimportPath, 'static.klo'], 'do_emg',0,'do_kin',1,'kin_fc',[7],'kin_chan',[-1],'kin_visu',[0]); % Filter kinematics data (7Hz lowpass)
        
        [Origin, Ry]=SetUpRotateGlobal([Path.KLOimportPath 'static.klo']); % Find Origin (translation) and Ry (Rotation matrix)
        
        Klofiles=dir([Path.KLOimportPath '*.klo']); %Find Klo files in the import folder
        
        if strcmp(projet, 'Asha') || strcmp(projet, 'Jason') % IF it is Asha or Jason, take the target position, used to calculate Ry, from one trial because they were not OK during static
            for itrial=1:length(Klofiles)
                KloName=Klofiles(itrial).name;
                if strncmp(KloName, 'Trial', 5) % get the first "Trial" you find
                    break
                end
            end
            
            rawfilt_OBLJB('filesnames', [Path.KLOimportPath, KloName], 'do_emg',0,'do_kin',1,'kin_fc',[7],'kin_chan',[-1],'kin_visu',[0]); % Filter kinematics data (15Hz lowpass)
            
            [~, Ry]=SetUpRotateGlobal([Path.KLOimportPath, KloName]); % Keep Translation based on static, but Ry from the Trial
        end
        
        for itrial=1:length(Klofiles) % for each Trial, apply rototranslation Matrix
            KloName=Klofiles(itrial).name;
            
            rawfilt_OBLJB('filesnames', [Path.KLOimportPath, KloName], 'do_emg',0,'do_kin',1,'kin_fc',[7],'kin_chan',[-1],'kin_visu',[0]); % Filter kinematics data (15Hz lowpass)
            data=RotateGlobal([Path.KLOimportPath KloName],Origin, Ry); % Apply Translation (Origin) and Rotation (Ry)
            save([Path.RotateKLOPath KloName], 'data');
            clear data
        end
        
    end % If FlagRotate
    
    %% Generate TRC files (input for OpenSim)
    if FlagTRC
        
        Klofiles=dir([Path.RotateKLOPath '*.klo']); % Get the klo files in the RotateKLO folder
        
        for itrial=1:length(Klofiles)
            
            KloName=Klofiles(itrial).name;
            sg_KLOtoTRC_forbatch(KloName,Path.RotateKLOPath,Path.TRCpath); % Generate TRC
            
        end
    end % if FlagTRC
    
    %% Scale Generic model (OpenSim)
    if FlagScaling
        
        setupAndRunScaleRPT
        
    end
    
    %% Inverse Kinematic: From TRC (marker position) to MOT (Joint angles)
    
    if FlagIK
        
        setupAndRunIKRPTtrunk % Inverse kinematic, only for the trunk (input trunk markers)
        setupAndRunIKRPTtrunkmot % IK for the limb (input trunk angles + limb markers)
        
    end
    
    %% Analyse IK residual error. Flag bad trials (rms error > 2cm, maxerror > 3cm)
    if FlagIKResidual
        Logfiles=dir([Path.IKsetuppath '*.log']);
        
        
        for itrial = 1: length(Logfiles)
            %Import .klo file
            LogName=Logfiles(itrial).name;
            
            IKresidual=Scan_IKresidual([Path.IKsetuppath LogName]);
            
            save([Path.IKsetuppath LogName(1:end-4) '.err'],'IKresidual')
            
            if median(IKresidual.rmsvalue)>0.02 || median(IKresidual.maxvalue)>0.03
                fid=fopen([Path.exportPath, 'flagIK.txt'], 'w');
                fclose(fid)
            end
            
            clear IKresidual
        end
        
    end %if FlagIKResidual
    
    %% Input IK results into klo structure
    if FlagMot2KLO
        
        if useold==1 % if you want to use an old file, import klo from Result folder !!! not sure those lines are useful
            
            Klofiles=dir([Path.exportPath '*.klo']);
            
        else % Otherwise, import klo from RotateKLO folder
            
            Klofiles=dir([Path.RotateKLOPath '*.klo']);
            
        end
        
        for itrial=1:length(Klofiles)
            
            %Import .klo file
            KloName=Klofiles(itrial).name;
            
            if useold == 1 % if you want to use an old file, import klo from Result folder
                
                load([Path.exportPath KloName], '-mat');
                
            else % Otherwise, import klo from RotateKLO folder
                
                load([Path.RotateKLOPath KloName], '-mat');
                
            end
            
            %import .mot file
            MotName=[KloName(1:end-4) '_ik.mot'];
            motdata=importdata([Path.IKresultpath MotName]);
            
            for iDoF = 1:length(DoF) % Get each DoF specified on line 13
                chan=find(strcmp(motdata.colheaders,DoF{iDoF})); % Get the good chan from .mot file
                
                data.OSIMDoF.(['channel', num2str(iDoF)]).label = DoF(iDoF);
                data.OSIMDoF.(['channel', num2str(iDoF)].data = motdata.data(:,chan);
                
            end
            
            save([Path.exportPath KloName], 'data')
            
            clear data
        end
    end %if FlagMot2KLO
    
    
    %% Remove bad trials from each subject using a GUI (should be simplified)
    if FlagCleanData
        % Find KloFiles that begins with 'Trial', and sort them
        Klofiles=arrayfun(@(x)(x.name),dir([Path.exportPath '*.klo']),'UniformOutput',0);
        
        Klofiles=sort(Klofiles(strncmp(Klofiles,'Trial',5)));
        
        % If there are at least two Trials and no flag indicating it is a
        % wrong subject, process
        if length(Klofiles)>1 && ~exist([Path.exportPath, 'Lefthanded.txt'], 'file')
            
            
            Klofiles=([Klofiles(1); Klofiles(end)]); % To keep just the first and last file
            
            
            for itrial = 1 : length(cond)
                %Import .klo file
                load([Path.exportPath Klofiles{itrial}], '-mat', 'data');
                
                
                %For each signal
                for isignal = 1:length(ChannameImport)
                    
                    
                    
                    % If the signal is a Relevent Marker and the flag for markers is on
                    %: clean xdata, ydata and zdata
                    if ismember(isignal,1:5) && dorelevantMKR == 1
                        
                        %% Clean Data
                        %Clean Forward Xdata
                        [~, data.Forward.(ChannameImport{isignal}).xdata]=clean_dataRPT(data.Forward.(ChannameImport{isignal}).xdata,...
                            ChannameImport{isignal},['subject', num2str((subjectID(isubject)))]);
                        
                        % If all RIDX x position are not valid, we are probably looking
                        % at a lefthanded. Put a flag and break the for loop
                        if isignal == 1
                            
                            if sum(~isnan(data.Forward.(ChannameImport{isignal}).xdata)) == 0
                                
                                fid=fopen([Path.exportPath 'Lefthanded.txt'], 'w');
                                fclose(fid);
                                break
                                
                            end
                            
                        end
                        
                        % Clean Backward Xdata
                        [~, data.Backward.(ChannameImport{isignal}).xdata]=clean_dataRPT(data.Backward.(ChannameImport{isignal}).xdata,...
                            ChannameImport{isignal},['subject', num2str((subjectID(isubject)))]);
                        
                        % Clean Forward Ydata
                        [~, data.Forward.(ChannameImport{isignal}).ydata]=clean_dataRPT(data.Forward.(ChannameImport{isignal}).ydata,...
                            ChannameImport{isignal},['subject', num2str((subjectID(isubject)))]);
                        
                        % Clean Backward Ydata
                        [~, data.Backward.(ChannameImport{isignal}).ydata]=clean_dataRPT(data.Backward.(ChannameImport{isignal}).ydata,...
                            ChannameImport{isignal},['subject', num2str((subjectID(isubject)))]);
                        
                        % Clean Forward Zdata
                        [~, data.Forward.(ChannameImport{isignal}).zdata]=clean_dataRPT(data.Forward.(ChannameImport{isignal}).zdata,...
                            ChannameImport{isignal},['subject', num2str((subjectID(isubject)))]);
                        
                        % Clean Backward Zdata
                        [~, data.Backward.(ChannameImport{isignal}).zdata]=clean_dataRPT(data.Backward.(ChannameImport{isignal}).zdata,...
                            ChannameImport{isignal},['subject', num2str((subjectID(isubject)))]);
                        
                        % If the signal is an OpenSim DoF, the flag for DoF is on and there is no flag indicating IK is bad
                        %Clean data
                    elseif ismember(isignal,6:length(ChannameImport)) && doDOF == 1 && ~exist([Path.exportPath, 'flagIK.txt'], 'file')
                        
                        % Clean Forward Data
                        [~, data.Forward.(ChannameImport{isignal})]=clean_dataRPT(data.Forward.(ChannameImport{isignal}),...
                            ChannameImport{isignal},['subject', num2str((subjectID(isubject)))]);
                        
                        % Clean Backward Data
                        [~, data.Backward.(ChannameImport{isignal})]=clean_dataRPT(data.Backward.(ChannameImport{isignal}),...
                            ChannameImport{isignal},['subject', num2str((subjectID(isubject)))]);
                        
                    end
                    
                    
                    
                    
                end
                
                %Save data in the Result folder
                save([Path.exportPath Klofiles{itrial}], 'data');
                
                
                
            end
            
        end
    end %Flag CleanData
end

