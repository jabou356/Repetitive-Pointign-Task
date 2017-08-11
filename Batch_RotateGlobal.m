clear; clc;

GenericPathRPT

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


for isubject=9:length(subjectID)
disp(['Processing subject #' num2str(subjectID(isubject)) ' (' num2str(isubject) ' out of ' num2str(length(subjectID)) ')'])

    SubjectPathRPT;
    
    rawfilt_OBLJB('filesnames', [Path.KLOimportPath, 'static.klo'], 'do_emg',0,'do_kin',1,'kin_fc',[15],'kin_chan',[-1],'kin_visu',[0]); % Filter kinematics data (15Hz lowpass)

    [Origin, Ry]=SetUpRotateGlobal([Path.KLOimportPath 'static.klo']); % Find Origin (translation) and Ry (Rotation matrix)

    
    
    Klofiles=dir([Path.KLOimportPath '*.klo']);
    
    if strcmp(projet, 'Asha') % IF it is Asha, take the target position from one trial because they were not OK during static
        for itrial=1:length(Klofiles)
            KloName=Klofiles(itrial).name;
            if strncmp(KloName, 'Trial', 5)
                break
            end
        end         
    [~, Ry]=SetUpRotateGlobal([Path.KLOimportPath, KloName]);
    end
    
    for itrial=1:length(Klofiles)        
    KloName=Klofiles(itrial).name;
    
    rawfilt_OBLJB('filesnames', [Path.KLOimportPath, KloName], 'do_emg',0,'do_kin',1,'kin_fc',[15],'kin_chan',[-1],'kin_visu',[0]); % Filter kinematics data (15Hz lowpass)
    data=RotateGlobal([Path.KLOimportPath KloName],Origin, Ry); % Apply Translation (Origin) and Rotation (Ry)
    save([Path.RotateKLOPath KloName], 'data');
    clear data
    end
    
end;