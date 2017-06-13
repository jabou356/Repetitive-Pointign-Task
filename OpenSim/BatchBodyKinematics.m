
clear ; close all; clc

%% Load generic paths

GenericPathRPT

%% Load subject

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

%% Nom des sujets

for isubject = 1%:length(subjectID)
    
disp(['Processing subject #' num2str(subjectID(isubject)) ' (' num2str(isubject) ' out of ' num2str(length(subjectID)) ')'])
%     %% Chemin des fichiers
SubjectPathRPT   
   
    setupAndRunBodyKinematics(Path)
   
end