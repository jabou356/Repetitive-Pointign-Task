ChannameOSIM(:)={'Shoulderplane', 'ShoulderElev', 'ElbowFlex','TrunkRy', 'TrunkRz'}; % Name of DoF in the MegaDatabase
Variables(:)={'AveragePos', 'ROM'};

kH=0;
kF=0;


for isubject = 1:length(WithinSubject)
    
    if strcmp(WithinSubject{isubject}.sex,'M')
        
        kH=kH+1;
        
        
        
        for ichan = 1 : length(ChannameOSIM)
            if isfield(WithinSubject{1,isubject},ChannameOSIM{ichan})
            
            for ivar = 1 : length(Variables)
                
                withinstruct.Men.(ChannameOSIM{ichan}).(Variables{ivar}).TTest.N(kH) = WithinSubject{isubject}.(ChannameOSIM{ichan}).(Variables{ivar}).TTest.nPRE;
                withinstruct.Men.(ChannameOSIM{ichan}).(Variables{ivar}).TTest.P(kH) = WithinSubject{isubject}.(ChannameOSIM{ichan}).(Variables{ivar}).TTest.P;
                withinstruct.Men.(ChannameOSIM{ichan}).(Variables{ivar}).TTest.delta(kH) = WithinSubject{isubject}.(ChannameOSIM{ichan}).(Variables{ivar}).TTest.deltaMean;
                
                withinstruct.Men.(ChannameOSIM{ichan}).(Variables{ivar}).Fisher.N(kH) = WithinSubject{isubject}.(ChannameOSIM{ichan}).(Variables{ivar}).Fisher.nPRE;
                withinstruct.Men.(ChannameOSIM{ichan}).(Variables{ivar}).Fisher.P(kH) = WithinSubject{isubject}.(ChannameOSIM{ichan}).(Variables{ivar}).Fisher.P;
                withinstruct.Men.(ChannameOSIM{ichan}).(Variables{ivar}).Fisher.delta(kH) = WithinSubject{isubject}.(ChannameOSIM{ichan}).(Variables{ivar}).Fisher.deltaSD;
                
            end
            
            else
                
                for ivar = 1 : length(Variables)
                    
                 withinstruct.Men.(ChannameOSIM{ichan}).(Variables{ivar}).TTest.N(kH) =nan;
                 withinstruct.Men.(ChannameOSIM{ichan}).(Variables{ivar}).TTest.P(kH) = nan;
                withinstruct.Men.(ChannameOSIM{ichan}).(Variables{ivar}).TTest.delta(kH) = nan;
                
                withinstruct.Men.(ChannameOSIM{ichan}).(Variables{ivar}).Fisher.N(kH) = nan;
                withinstruct.Men.(ChannameOSIM{ichan}).(Variables{ivar}).Fisher.P(kH) = nan;
                withinstruct.Men.(ChannameOSIM{ichan}).(Variables{ivar}).Fisher.delta(kH) = nan;
                
                end
                
            end
            
        end
        
    elseif strcmp(WithinSubject{isubject}.sex,'F')
        
        kF = kF + 1;
        
        for ichan = 1 : length(ChannameOSIM)
            
            if isfield(WithinSubject{1,isubject},ChannameOSIM{ichan})
            
            for ivar = 1 : length(Variables)
                
                withinstruct.Women.(ChannameOSIM{ichan}).(Variables{ivar}).TTest.N(kF) = WithinSubject{isubject}.(ChannameOSIM{ichan}).(Variables{ivar}).TTest.nPRE;
                withinstruct.Women.(ChannameOSIM{ichan}).(Variables{ivar}).TTest.P(kF) = WithinSubject{isubject}.(ChannameOSIM{ichan}).(Variables{ivar}).TTest.P;
                withinstruct.Women.(ChannameOSIM{ichan}).(Variables{ivar}).TTest.delta(kF) = WithinSubject{isubject}.(ChannameOSIM{ichan}).(Variables{ivar}).TTest.deltaMean;
                
                withinstruct.Women.(ChannameOSIM{ichan}).(Variables{ivar}).Fisher.N(kF) = WithinSubject{isubject}.(ChannameOSIM{ichan}).(Variables{ivar}).Fisher.nPRE;
                withinstruct.Women.(ChannameOSIM{ichan}).(Variables{ivar}).Fisher.P(kF) = WithinSubject{isubject}.(ChannameOSIM{ichan}).(Variables{ivar}).Fisher.P;
                withinstruct.Women.(ChannameOSIM{ichan}).(Variables{ivar}).Fisher.delta(kF) = WithinSubject{isubject}.(ChannameOSIM{ichan}).(Variables{ivar}).Fisher.deltaSD;
                
            end
            
            else
                
                for ivar = 1 : length(Variables)
                    
                 withinstruct.Women.(ChannameOSIM{ichan}).(Variables{ivar}).TTest.N(kF) =nan;
                 withinstruct.Women.(ChannameOSIM{ichan}).(Variables{ivar}).TTest.P(kF) = nan;
                withinstruct.Women.(ChannameOSIM{ichan}).(Variables{ivar}).TTest.delta(kF) = nan;
                
                withinstruct.Women.(ChannameOSIM{ichan}).(Variables{ivar}).Fisher.N(kF) = nan;
                withinstruct.Women.(ChannameOSIM{ichan}).(Variables{ivar}).Fisher.P(kF) = nan;
                withinstruct.Women.(ChannameOSIM{ichan}).(Variables{ivar}).Fisher.delta(kF) = nan;
                
                end
                
            end
            
        end
        
    end
    
end
    