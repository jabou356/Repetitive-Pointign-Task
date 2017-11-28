
Sex(:)={'Men','Women'};
ChannameOSIM(:)={'ShoulderElev', 'Shoulderplane', 'ElbowFlex', 'TrunkRx' ,'TrunkRy', 'TrunkRz'}; % Name of DoF in the MegaDatabase
Variables(:)={'AveragePos', 'ROM'};
Stats(:)={'TTest','Fisher'};

ThresholdsN = 3;

for isex = 1:length(Sex)
    
for ichan = 1 : length(ChannameOSIM)
    
    for ivar = 1:length(Variables)
        
        for istat = 1:length(Stats)
    
    
        
        Total = find(~isnan(withinstruct.(Sex{isex}).(ChannameOSIM{ichan}).(Variables{ivar}).(Stats{istat}).P) & ...
            withinstruct.(Sex{isex}).(ChannameOSIM{ichan}).(Variables{ivar}).(Stats{istat}).N > ThresholdsN);
        
        Sign = sign(mean(withinstruct.(Sex{isex}).(ChannameOSIM{ichan}).(Variables{ivar}).(Stats{istat}).delta(Total)));
        
              
        Change = find(sign(withinstruct.(Sex{isex}).(ChannameOSIM{ichan}).(Variables{ivar}).(Stats{istat}).delta(Total))==Sign);
        
        data.proportion=[data.proportion; length(Change)/length(Total) * 100];
        
        end
        
    end
    
end
        
    
end
