clear; clc;
GenericPathRPT

temp=importdata([Path.GroupDataPath, 'MegaDatabase1D.txt']);

k=1;
for iline=size(temp.data,1):-1:1
    
    Megadatabase(iline).Subject = temp.textdata(iline+1,1);
    Megadatabase(iline).SID = str2double(temp.textdata(iline+1,2));
    Megadatabase(iline).Time = str2double(temp.textdata(iline+1,3));
    Megadatabase(iline).Project = temp.textdata(iline+1,4);
    Megadatabase(iline).Endurance = str2double(temp.textdata(iline+1,5));
    Megadatabase(iline).Sex = temp.textdata(iline+1,6);
    Megadatabase(iline).Age = str2double(temp.textdata(iline+1,7));
    Megadatabase(iline).Height = str2double(temp.textdata(iline+1,8));
    Megadatabase(iline).Weight = str2double(temp.textdata(iline+1,9));
    Megadatabase(iline).Signal = temp.textdata(iline+1,10);
    Megadatabase(iline).Stat = temp.textdata(iline+1,11);
    
    Megadatabase(iline).Forward = temp.data(iline,1:100);    
    Megadatabase(iline).Backward = temp.data(iline,101:200);
    
    
end

subjects=unique(arrayfun(@(x)(x.Subject),Megadatabase));

for iline=size(temp.data,1):-1:1

    Megadatabase(iline).SubjectID = find(strcmp(subjects,Megadatabase(iline).Subject));
    
    if strcmp(Megadatabase(iline).Sex,'M')
        
        Megadatabase(iline).Sex=1;
        
    elseif strcmp(Megadatabase(iline).Sex,'F')
        
        Megadatabase(iline).Sex=2;
        
    end
    
end

save([Path.JBAnalyse, 'GroupData1D.mat'], 'Megadatabase');