SignalEndpoint={'RINXF'};

VideoLength=length(fieldnames(data.VideoData));

for ichan=1:VideoLength
isRIDX(ichan)=strcmp(data.VideoData.(['channel' num2str(ichan)]).label,SignalEndpoint);
end
    
EndpointData=data.VideoData.(['channel' num2str(find(isRIDX))]).xdata;

%% Filter joint angles 15Hz lowpass
[b, a]=butter(2, 15/50, 'low');
for ichan=1:length(fieldnames(data.OSIMDoF))
    fdata.OSIMDoF.(['channel' num2str(ichan)]).data...
     =filtfilt(b,a,data.OSIMDoF.(['channel' num2str(ichan)]).data);
end


kfwd=0;
kbwd=0;
for imvt=1:length(data.PartData.Xvideo)-1
    
    start=data.PartData.Xvideo(imvt);
    finish=data.PartData.Xvideo(imvt+1);
    isfwd = EndpointData(finish) - EndpointData(start) > 0;
    
    % Variables for interpolation  
    x=1:(finish-start);
   
    
    if isfwd
        kfwd=kfwd+1;
        for ichan=1:length(fieldnames(data.OSIMDoF))
         y=fdata.OSIMDoF.(['channel' num2str(ichan)]).data(start:finish-1);    
         channame=data.OSIMDoF.(['channel' num2str(ichan)]).label;       
         data.Forward.(channame)(:,kfwd)=interp1(x,y,1:(length(x)-1)/99:length(x));
        end
            
    else
        kbwd=kbwd+1;
        for ichan=1:length(fieldnames(data.OSIMDoF))
         y=fdata.OSIMDoF.(['channel' num2str(ichan)]).data(start:finish-1);
         channame=data.OSIMDoF.(['channel' num2str(ichan)]).label;       
         data.Backward.(channame)(:,kbwd)=interp1(x,y,1:(length(x)-1)/99:length(x));
        end
        
    end
            
    
end

   