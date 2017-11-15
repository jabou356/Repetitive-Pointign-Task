clear; clc;

dorelevantMKR=0;
doDOF=1;

cond={'NF','FT'};
ChannameImport(:)={'RIDX','RWRA','RELB','RSHO','CLAV','elv_angle', 'shoulder_elv', 'elbow_flexion','ground_thorax_yRotation', 'ground_thorax_zRotation', 'ground_thorax_xRotation', 'shoulder_rot'};
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


for isubject = 1:length(subjectID)
    disp(['Processing subject #' num2str(subjectID(isubject)) ' (' num2str(isubject) ' out of ' num2str(length(subjectID)) ')'])
        
    SubjectPathRPT;
    
    Klofiles=arrayfun(@(x)(x.name),dir([Path.exportPath '*.klo']),'UniformOutput',0);
    
    Klofiles=sort(Klofiles(strncmp(Klofiles,'Trial',5)));
    
    if length(Klofiles)>1 && ~exist([Path.exportPath, 'Lefthanded.txt'], 'file') % To keep just the first and last file
    Klofiles=([Klofiles(1); Klofiles(end)]);
    
    
    for itrial = 1 : length(cond)
        %Import .klo file
        load([Path.exportPath Klofiles{itrial}], '-mat', 'data');
             
        for isignal = 1:length(ChannameImport) 
            
             
                
            % If the signal is a Relevent Marker: clean xdata, ydata and zdata
            if ismember(isignal,[1:5]) && dorelevantMKR == 1
                
            %% Clean Data
            %Forward mvt
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
            
            [~, data.Backward.(ChannameImport{isignal}).xdata]=clean_dataRPT(data.Backward.(ChannameImport{isignal}).xdata,...
                ChannameImport{isignal},['subject', num2str((subjectID(isubject)))]);
            
            [~, data.Forward.(ChannameImport{isignal}).ydata]=clean_dataRPT(data.Forward.(ChannameImport{isignal}).ydata,...
                ChannameImport{isignal},['subject', num2str((subjectID(isubject)))]);
            
            [~, data.Backward.(ChannameImport{isignal}).ydata]=clean_dataRPT(data.Backward.(ChannameImport{isignal}).ydata,...
                ChannameImport{isignal},['subject', num2str((subjectID(isubject)))]);
            
            [~, data.Forward.(ChannameImport{isignal}).zdata]=clean_dataRPT(data.Forward.(ChannameImport{isignal}).zdata,...
                ChannameImport{isignal},['subject', num2str((subjectID(isubject)))]);
            
            [~, data.Backward.(ChannameImport{isignal}).zdata]=clean_dataRPT(data.Backward.(ChannameImport{isignal}).zdata,...
                ChannameImport{isignal},['subject', num2str((subjectID(isubject)))]);
            
            % If the signal is an OpenSim DoF, validate data.Forward.(ChannameImport{isignal})
            elseif ismember(isignal,[6:length(ChannameImport)]) && doDOF == 1 && ~exist([Path.exportPath, 'flagIK.txt'], 'file')
                
            [~, data.Forward.(ChannameImport{isignal})]=clean_dataRPT(data.Forward.(ChannameImport{isignal}),...
                ChannameImport{isignal},['subject', num2str((subjectID(isubject)))]);
            
            [~, data.Backward.(ChannameImport{isignal})]=clean_dataRPT(data.Backward.(ChannameImport{isignal}),...
                ChannameImport{isignal},['subject', num2str((subjectID(isubject)))]);
            
            end
            
            
                
            
        end
        

        save([Path.exportPath Klofiles{itrial}], 'data');
     
         
        
    end
    
    end
    
end
            
           