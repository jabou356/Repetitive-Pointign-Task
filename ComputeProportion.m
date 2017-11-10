ChannameOSIM(:)={'Shoulderplane', 'ShoulderElev', 'ElbowFlex','TrunkRy', 'TrunkRz'}; % Name of DoF in the MegaDatabase
Variables(:)={'AveragePos', 'ROM'};

kH=0;
kF=0;

ThresholdsN = 3;
ThresholdsP = 0:0.01:1;

for ichan = 1 : length(ChannameOSIM)
    
    
    
    for ivar = 1 : length(Variables)
        
        totalTTestM = find(~isnan(withinstruct.Men.(ChannameOSIM{ichan}).(Variables{ivar}).TTest.P) & ...
            withinstruct.Men.(ChannameOSIM{ichan}).(Variables{ivar}).TTest.N > ThresholdsN);
        
        signTTestM = sign(mean(withinstruct.Men.(ChannameOSIM{ichan}).(Variables{ivar}).TTest.delta(totalTTestM)));
        
        totalFisherM = find(~isnan(withinstruct.Men.(ChannameOSIM{ichan}).(Variables{ivar}).Fisher.P) & ...
            withinstruct.Men.(ChannameOSIM{ichan}).(Variables{ivar}).Fisher.N > ThresholdsN);
        
        signFisherM = sign(mean(withinstruct.Men.(ChannameOSIM{ichan}).(Variables{ivar}).Fisher.delta(totalFisherM)));
        
        
        totalTTestW = find(~isnan(withinstruct.Women.(ChannameOSIM{ichan}).(Variables{ivar}).TTest.P) & ...
            withinstruct.Women.(ChannameOSIM{ichan}).(Variables{ivar}).TTest.N > ThresholdsN);
        
        signTTestW = sign(mean(withinstruct.Women.(ChannameOSIM{ichan}).(Variables{ivar}).TTest.delta(totalTTestW)));
        
        
        totalFisherW = find(~isnan(withinstruct.Women.(ChannameOSIM{ichan}).(Variables{ivar}).Fisher.P) & ...
            withinstruct.Women.(ChannameOSIM{ichan}).(Variables{ivar}).Fisher.N > ThresholdsN);
        
        signFisherW = sign(mean(withinstruct.Women.(ChannameOSIM{ichan}).(Variables{ivar}).Fisher.delta(totalFisherW)));
        
        
        for ith = 1:length(ThresholdsP)
            
            sigChangeTTestM = find(withinstruct.Men.(ChannameOSIM{ichan}).(Variables{ivar}).TTest.P(totalTTestM)<ThresholdsP(ith) & ...
                sign(withinstruct.Men.(ChannameOSIM{ichan}).(Variables{ivar}).TTest.delta(totalTTestM))==signTTestM);
            
            Proportion.Men.(ChannameOSIM{ichan}).(Variables{ivar}).TTest(ith) = length(sigChangeTTestM)/length(totalTTestM) * 100;
            
            
            sigChangeFisherM = find(withinstruct.Men.(ChannameOSIM{ichan}).(Variables{ivar}).Fisher.P(totalFisherM)<ThresholdsP(ith) & ...
               sign(withinstruct.Men.(ChannameOSIM{ichan}).(Variables{ivar}).Fisher.delta(totalFisherM))==signFisherM) ;
            
            Proportion.Men.(ChannameOSIM{ichan}).(Variables{ivar}).Fisher(ith) = length(sigChangeFisherM)/length(totalFisherM) * 100;
            
            
            sigChangeTTestW = find(withinstruct.Women.(ChannameOSIM{ichan}).(Variables{ivar}).TTest.P(totalTTestW)<ThresholdsP(ith) & ...
                 sign(withinstruct.Women.(ChannameOSIM{ichan}).(Variables{ivar}).TTest.delta(totalTTestW))==signTTestW);
            
            Proportion.Women.(ChannameOSIM{ichan}).(Variables{ivar}).TTest(ith) = length(sigChangeTTestW)/length(totalTTestW) * 100;
            
            
            sigChangeFisherW = find(withinstruct.Women.(ChannameOSIM{ichan}).(Variables{ivar}).Fisher.P(totalFisherW)<ThresholdsP(ith) & ...
                sign(withinstruct.Women.(ChannameOSIM{ichan}).(Variables{ivar}).Fisher.delta(totalFisherW))==signFisherW);
            
            Proportion.Women.(ChannameOSIM{ichan}).(Variables{ivar}).Fisher(ith) = length(sigChangeFisherW)/length(totalFisherW) * 100;
            
        end
        
        
    end
    
    
    
end
