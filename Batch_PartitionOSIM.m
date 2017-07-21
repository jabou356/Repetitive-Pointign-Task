clear clc

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



for isubject=4:length(subjectID)
    disp(['Processing subject #' num2str(subjectID(isubject)) ' (' num2str(isubject) ' out of ' num2str(length(subjectID)) ')'])
    
    SubjectPathRPT;
    
    Klofiles=dir([Path.exportPath '*.klo']);

    
    for itrial = 1 : length(Klofiles)
        %Import .klo file
        KloName=Klofiles(itrial).name;
        if ~strcmp(KloName,'static.klo')
        load([Path.exportPath KloName], '-mat', 'data');
        
        PartitionOSIM
        
        save([Path.exportPath KloName],'data')
        
        clear data fdata
        end
        
    end
    
end;