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



for isubject=15 %1:length(subjectID)
    disp(['Processing subject #' num2str(subjectID(isubject)) ' (' num2str(isubject) ' out of ' num2str(length(subjectID)) ')'])
    
    SubjectPathRPT;
    
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
        
    end
    