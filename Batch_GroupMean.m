clear clc
cond={'NF','FT'};
Channame(:,1)={'Shoulderplane', 'ShoulderElev', 'ShoulderRot',...
    'ElbowFlex', 'ElbowPro', 'TrunkRx', 'TrunkRy', 'TrunkRz'}; %Signal name in Excel
Channame(:,2)={'elv_angle', 'shoulder_elv', 'shoulder_rot',...
    'elbow_flexion', 'pro_sup', 'ground_thorax_xTranslation',...
    'ground_thorax_yTranslation', 'ground_thorax_zTranslation'}; %Signal name in OSIM


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

GroupFile=[Path.GroupDataPath, 'GroupData_Q.xlsx'];


for isubject=1%[1:3 7 9:length(subjectID) ]
    disp(['Processing subject #' num2str(subjectID(isubject)) ' (' num2str(isubject) ' out of ' num2str(length(subjectID)) ')'])
    
    column=ExcelCol(isubject);
    
    SubjectPathRPT;
    
    Klofiles=arrayfun(@(x)(x.name),dir([Path.exportPath '*.klo']),'UniformOutput',0);
    
    Klofiles=sort(Klofiles(strncmp(Klofiles,'Trial',5)));
    
    for itrial = 1 : length(cond)
        %Import .klo file
        load([Path.exportPath Klofiles{itrial}], '-mat', 'data');
        
        for isignal = 1:size(Channame,1)
            xlswrite(GroupFile, char(['subject', num2str((subjectID(isubject)))]),...
                char([Channame{itrial,1}, '_', cond{itrial}]),...
                char([column, num2str(1)])');
            
            xlswrite(GroupFile, mean(data.Forward.(Channame{itrial,2}),2),...
                char([Channame{itrial,1}, '_', cond{itrial}]),...
                char([column, num2str(2)])');
            
            xlswrite(GroupFile, mean(data.Backward.(Channame{itrial,2}),2),...
                char([Channame{itrial,1}, '_', cond{itrial}]),...
                char([column, num2str(102)])');
            
        end
        
        clear data
        
    end
    
end
