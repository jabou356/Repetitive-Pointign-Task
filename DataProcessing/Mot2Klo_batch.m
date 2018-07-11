clear; clc;

useold=0;

DoF={'ground_thorax_xRotation' 'ground_thorax_yRotation' 'ground_thorax_zRotation'...
    'ground_thorax_xTranslation' 'ground_thorax_yTranslation' 'ground_thorax_zTranslation'...
    'elv_angle' 'shoulder_elv' 'shoulder_rot'...
    'elbow_flexion' 'pro_sup' 'deviation' 'flexion'};

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



for isubject=[3, 15]
    disp(['Processing subject #' num2str(subjectID(isubject)) ' (' num2str(isubject) ' out of ' num2str(length(subjectID)) ')'])
    
    SubjectPathRPT;
    
    if useold==1
       
    Klofiles=dir([Path.exportPath '*.klo']);
        
    else
        
    Klofiles=dir([Path.RotateKLOPath '*.klo']);
    
    end
    
    for itrial=1:length(Klofiles)
        
        %Import .klo file
        KloName=Klofiles(itrial).name;
        
        if useold == 1
          
        load([Path.exportPath KloName], '-mat');

        else
            
        load([Path.RotateKLOPath KloName], '-mat');
        
        end
        
        %import .mot file
        MotName=[KloName(1:end-4) '_ik.mot'];
        motdata=importdata([Path.IKresultpath MotName]);
        
        for iDoF = 1:length(DoF)
            chan=find(strcmp(motdata.colheaders,DoF{iDoF}));
            
            s=['data.OSIMDoF.channel' num2str(iDoF) '.label=DoF{iDoF};'];eval(s);
            s=['data.OSIMDoF.channel' num2str(iDoF) '.data=motdata.data(:,chan);'];eval(s);
        end
        
        save([Path.exportPath KloName], 'data')
        
        clear data
    end
    
end;