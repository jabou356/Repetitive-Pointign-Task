clear; clc;
cond={'NF','FT'};
Channame(:,1)={'Shoulderplane', 'ShoulderElev', 'ElbowFlex','TrunkRy', 'TrunkRz'};% 'ShoulderRot',...
    
%'ElbowFlex', 'ElbowPro', 'TrunkRx', 'TrunkRy', 'TrunkRz'}; %Signal name in Excel
Channame(:,2)={'elv_angle', 'shoulder_elv',  'elbow_flexion', 'ground_thorax_yRotation', 'ground_thorax_zRotation'};% 'shoulder_rot',...
   % 'elbow_flexion', 'pro_sup', 'ground_thorax_xRotation',...
   % 'ground_thorax_yRotation', 'ground_thorax_zRotation'}; %Signal name in OSIM


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

GroupFilemean=[Path.GroupDataPath, 'GroupData_Q.xlsx'];
GroupFilestd=[Path.GroupDataPath, 'GroupData_Q_std.xlsx'];

for isubject=[15:length(subjectID)] %% je suis rendu sujet 15 Kathryn, Hiram's done 21juillet
    disp(['Processing subject #' num2str(subjectID(isubject)) ' (' num2str(isubject) ' out of ' num2str(length(subjectID)) ')'])
    
    column=ExcelCol(isubject);
    
    SubjectPathRPT;
    
    Klofiles=arrayfun(@(x)(x.name),dir([Path.exportPath '*.klo']),'UniformOutput',0);
    
    Klofiles=sort(Klofiles(strncmp(Klofiles,'Trial',5)));
    
    for itrial = 1 : length(cond)
        %Import .klo file
        load([Path.exportPath Klofiles{itrial}], '-mat', 'data');
        
        for isignal = 1:size(Channame,1)
            
            %% Clean Data
            %Forward mvt
            [~, data.Forward.(Channame{isignal,2})]=clean_dataRPT(data.Forward.(Channame{isignal,2}),...
                isignal,['subject', num2str((subjectID(isubject)))]);
            data.Forward.(Channame{isignal,2})=data.Forward.(Channame{isignal,2})(:,...
                ~isnan(data.Forward.(Channame{isignal,2})(1,:)));
            
            %Backward mvt
            [~, data.Backward.(Channame{isignal,2})]=clean_dataRPT(data.Backward.(Channame{isignal,2}),...
                isignal,['subject', num2str((subjectID(isubject)))]);
            data.Backward.(Channame{isignal,2})=data.Backward.(Channame{isignal,2})(:,...
                ~isnan(data.Backward.(Channame{isignal,2})(1,:)));
            
            %% Write group data (mean)
            xlswrite(GroupFilemean, cellstr(['subject', num2str((subjectID(isubject)))]),...
                char([Channame{isignal,1}, '_', cond{itrial}]),...
                char([column, num2str(1)])');
            
            xlswrite(GroupFilemean, mean(data.Forward.(Channame{isignal,2}),2),...
                char([Channame{isignal,1}, '_', cond{itrial}]),...
                char([column, num2str(2)])');
            
             xlswrite(GroupFilemean, mean(data.Backward.(Channame{isignal,2}),2),...
                char([Channame{isignal,1}, '_', cond{itrial}]),...
                char([column, num2str(1),num2str(0), num2str(2)])');  
            
            %% Write group data (std)
            xlswrite(GroupFilestd, cellstr(['subject', num2str((subjectID(isubject)))]),...
                char([Channame{isignal,1}, '_', cond{itrial}]),...
                char([column, num2str(1)])');
            
            xlswrite(GroupFilestd, std(data.Forward.(Channame{isignal,2}),0,2),...
                char([Channame{isignal,1}, '_', cond{itrial}]),...
                char([column, num2str(2)])');
            
             xlswrite(GroupFilestd, std(data.Backward.(Channame{isignal,2}),0,2),...
                char([Channame{isignal,1}, '_', cond{itrial}]),...
                char([column, num2str(1),num2str(0), num2str(2)])');
            
        end
        
        clear data
        
    end
    
end
