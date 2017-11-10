% In this code I compute within subject comparison (NF vs FT) for each
% variables average value and  standard deviation

% The script scan each subject's folders to find the `result`.klo file.
% Then it perform an independent sample t-test comparing NF vs FT trial
% average values and a Fisher test to compare their standard deviation. The
% outputs for each variable contains: 
%
% t-test: p value, difference in FT and NF average value, number of
% movements NF and number of movement FT
%
%Fisher test: p value, difference in FT and NF standard deviation, number of
% movements NF and number of movement FT
%
% Also contains subject'S sex and age


%% Define variables and coonditions of interest
clear; clc;
cond={'NF','FT'};
ChannameOSIMImport(:)={'elv_angle', 'shoulder_elv',  'elbow_flexion', 'ground_thorax_yRotation', 'ground_thorax_zRotation'}; % Name of DoF in the result folder

ChannameOSIM(:)={'Shoulderplane', 'ShoulderElev', 'ElbowFlex','TrunkRy', 'TrunkRz'}; % Name of DoF in the MegaDatabase
ChannameMKR(:)={'CLAV','RSHO','RELB' ,'RWRA','RIDX'}; % Name of relevant markers in the MegaDatabase (and Result folder)

% Get generic Paths
GenericPathRPT

GroupFile=[Path.JBAnalyse, 'GroupWithinSubject.mat'];


% If their is no existing MegaDatabase0D, initialize one with headers.
if ~exist(GroupFile,'file')
    
    nsubject = 0; 
    
else % Else, find the index of the last subject
    
    load(GroupFile);
    nsubject = length(WithinSubject); 
    
end



%% Write the new file
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
    nsubject=nsubject+1;
    
    disp(['Processing subject #' num2str(subjectID(isubject)) ' (' num2str(isubject) ' out of ' num2str(length(subjectID)) ')'])
    
    % Get subjects paths
    SubjectPathRPT;
    
    
    % Load file containing participant's info (age, sex, height, weight,
    % endurance time.
    load([Path.SubjectPath, 'Info.mat'])
    
    WithinSubject{nsubject}.sex=Info.sex;
    WithinSubject{nsubject}.age=Info.age;
    WithinSubject{nsubject}.height=Info.height;
    WithinSubject{nsubject}.weight=Info.weight;
    
    % In the exportPath (result folder), find the TrialX.klo files and sort in
    % ascending order to get the first and last trial
    Klofiles=arrayfun(@(x)(x.name),dir([Path.exportPath '*.klo']),'UniformOutput',0);
    
    Klofiles=sort(Klofiles(strncmp(Klofiles,'Trial',5)));
    
    % Identify problematic subjects
    isIKflag=exist([Path.exportPath, 'flagIK.txt'],'file');
    isLEFTflag=exist([Path.exportPath, 'Lefthanded.txt'],'file'); 
    
    if length(Klofiles)>1 && isIKflag==0 && isLEFTflag==0% To keep just the first and last file
        
        Klofiles=([Klofiles(1); Klofiles(end)]);
    
        
        for itrial = 1 : length(cond)
            
            %Import .klo file
            load([Path.exportPath Klofiles{itrial}], '-mat', 'data');
            
            TRIAL{itrial} = data.Forward;
            
            clear data
            
        end
        
            for isignal = 1:length(ChannameOSIMImport)        
                
                meanposfwdPRE=mean(TRIAL{1}.(ChannameOSIMImport{isignal}),1); meanposfwdPRE=meanposfwdPRE(~isnan(meanposfwdPRE));
                meanposfwdPOST=mean(TRIAL{2}.(ChannameOSIMImport{isignal}),1);meanposfwdPOST=meanposfwdPOST(~isnan(meanposfwdPOST));
                nmvt=min(length(meanposfwdPRE),length(meanposfwdPOST));
                meanposfwdPRE=meanposfwdPRE(1:nmvt); meanposfwdPOST=meanposfwdPOST(1:nmvt);
                
                romfwdPRE=max(TRIAL{1}.(ChannameOSIMImport{isignal}),[],1)-min(TRIAL{1}.(ChannameOSIMImport{isignal}),[],1); romfwdPRE=romfwdPRE(~isnan(romfwdPRE));  % range of motion forward movement
                romfwdPOST=max(TRIAL{2}.(ChannameOSIMImport{isignal}),[],1)-min(TRIAL{2}.(ChannameOSIMImport{isignal}),[],1); romfwdPOST=romfwdPOST(~isnan(romfwdPOST)); % range of motion forward movement
                romfwdPRE=romfwdPRE(1:nmvt); romfwdPOST=romfwdPOST(1:nmvt);
                
                                
                % Write result for Mean Average position
                WithinSubject{nsubject}.(ChannameOSIM{isignal}).AveragePos.TTest.deltaMean=mean(meanposfwdPOST)-mean(meanposfwdPRE);
                WithinSubject{nsubject}.(ChannameOSIM{isignal}).AveragePos.TTest.nPRE=length(find(~isnan(meanposfwdPRE)));             
                WithinSubject{nsubject}.(ChannameOSIM{isignal}).AveragePos.TTest.nPOST=length(find(~isnan(meanposfwdPOST)));
                
                spm        = spm1d.stats.ttest_paired(meanposfwdPRE, meanposfwdPOST);
                param       = spm.inference(0.05, 'two_tailed',true);
                               
                WithinSubject{nsubject}.(ChannameOSIM{isignal}).AveragePos.TTest.P=param.p;
                clear spm param
                
                % Write result for Mean ROM
                WithinSubject{nsubject}.(ChannameOSIM{isignal}).ROM.TTest.deltaMean=mean(romfwdPOST)-mean(romfwdPRE);
                WithinSubject{nsubject}.(ChannameOSIM{isignal}).ROM.TTest.nPRE=length(find(~isnan(romfwdPRE)));             
                WithinSubject{nsubject}.(ChannameOSIM{isignal}).ROM.TTest.nPOST=length(find(~isnan(romfwdPOST)));
                
                spm        = spm1d.stats.ttest_paired(romfwdPRE, romfwdPOST);
                param       = spm.inference(0.05, 'two_tailed',true);
                                              
                WithinSubject{nsubject}.(ChannameOSIM{isignal}).ROM.TTest.P=param.p;
                clear spm param
                
                % Write result for SD Average position
                WithinSubject{nsubject}.(ChannameOSIM{isignal}).AveragePos.Fisher.deltaSD=std(meanposfwdPOST)-std(meanposfwdPRE);
                WithinSubject{nsubject}.(ChannameOSIM{isignal}).AveragePos.Fisher.nPRE=length(find(~isnan(meanposfwdPRE)));             
                WithinSubject{nsubject}.(ChannameOSIM{isignal}).AveragePos.Fisher.nPOST=length(find(~isnan(meanposfwdPOST)));
                
                
                [~,WithinSubject{nsubject}.(ChannameOSIM{isignal}).AveragePos.Fisher.P] = vartest2(meanposfwdPOST,meanposfwdPRE);
                
                % Write result for SD Average position
                WithinSubject{nsubject}.(ChannameOSIM{isignal}).ROM.Fisher.deltaSD=std(romfwdPOST)-std(romfwdPRE);
                WithinSubject{nsubject}.(ChannameOSIM{isignal}).ROM.Fisher.nPRE=length(find(~isnan(romfwdPRE)));             
                WithinSubject{nsubject}.(ChannameOSIM{isignal}).ROM.Fisher.nPOST=length(find(~isnan(romfwdPOST)));
                
                
                [~,WithinSubject{nsubject}.(ChannameOSIM{isignal}).ROM.Fisher.P] = vartest2(romfwdPOST,romfwdPRE);
                    
            end
    end
            
            clear TRIAL
            
            
            
end

 save(GroupFile, 'WithinSubject');
    