%Script developed by Jason Bouffard in order to generate .trc files as an
%input to OpenSim from .klo files generated during the RPT in the OBEL lab
%at McGill. Use function sg_KLOtoTRC developped by Shaheen Ghayourmanesh and functions
%GenericPathRPT and subjectPathRPT developed by Jason Bouffard

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


for isubject=1:length(subjectID) 
disp(['Processing subject #' num2str(subjectID(isubject)) ' (' num2str(isubject) ' out of ' num2str(length(subjectID)) ')'])

    SubjectPathRPT;
    
    Klofiles=dir([Path.RotateKLOPath '*.klo']);
    
    
    for itrial=1:length(Klofiles)
    KloName=Klofiles(itrial).name;
    sg_KLOtoTRC_forbatch(KloName,Path.RotateKLOPath,Path.TRCpath);
    end
    
end;

