clear; clc;
GenericPathRPT

temp=importdata([Path.GroupDataPath, 'MegaDatabase0D.txt']);

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
    Megadatabase(iline).TimingFwd = temp.textdata(iline+1,11);
    Megadatabase(iline).TimingErrFwd = temp.textdata(iline+1,12);
    Megadatabase(iline).TimingBwd = temp.textdata(iline+1,13);
    Megadatabase(iline).TimingErrBwd = temp.textdata(iline+1,14);
    Megadatabase(iline).Stat = temp.textdata(iline+1,15);
    
    Megadatabase(iline).MeanPosFwd = temp.data(iline,1);    
    Megadatabase(iline).ROMFwd = temp.data(iline,2);
    Megadatabase(iline).MeanPosBwd = temp.data(iline,3);    
    Megadatabase(iline).ROMBwd = temp.data(iline,4);
    
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

save([Path.JBAnalyse, 'GroupData0D.mat'], 'Megadatabase');