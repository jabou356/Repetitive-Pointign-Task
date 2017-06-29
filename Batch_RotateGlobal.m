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


for isubject=2:length(subjectID)
disp(['Processing subject #' num2str(subjectID(isubject)) ' (' num2str(isubject) ' out of ' num2str(length(subjectID)) ')'])

    SubjectPathRPT;
    
    [Origin, Ry]=SetUpRotateGlobal([Path.KLOimportPath 'static.klo']);

    
    
    Klofiles=dir([Path.KLOimportPath '*.klo']);
    
    
    for itrial=1:length(Klofiles)
    KloName=Klofiles(itrial).name;
    data=RotateGlobal([Path.KLOimportPath KloName],Origin, Ry);
    save([Path.RotateKLOPath KloName], 'data');
    clear data
    end
    
end;