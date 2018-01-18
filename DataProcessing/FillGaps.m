Signal={'RWRB'};

VideoLength=length(fieldnames(data.VideoData));

%% Find signal to fill gaps
for i=VideoLength:-1:1
    isSignal(i)=strcmp(data.VideoData.(['channel' num2str(i)]).label,Signal{1});
end

Signalchan=find(isSignal);

% Find gaps
gaps=find(isnan(data.VideoData.(['channel', num2str(Signalchan)]).xdata));
nogaps=find(~isnan(data.VideoData.(['channel', num2str(Signalchan)]).xdata));

while length(gaps>0) % While there are still gaps
    
    % Show number of gaps remaining
    disp(num2str(length(gaps)))
    
    % Find moment before and after the gap 
    before = nogaps(find(nogaps<gaps(1),1,'last'));
    after = nogaps(find(nogaps>gaps(1),1,'first'));
    
    
    if isempty(before) % IF the gap is at the beginning of the file, replace first data points (NaN) by first valid data point
        
        data.VideoData.(['channel', num2str(Signalchan)]).xdata(1:after-1) = data.VideoData.(['channel', num2str(Signalchan)]).xdata(after);
        data.VideoData.(['channel', num2str(Signalchan)]).ydata(1:after-1) = data.VideoData.(['channel', num2str(Signalchan)]).ydata(after);
        data.VideoData.(['channel', num2str(Signalchan)]).zdata(1:after-1) = data.VideoData.(['channel', num2str(Signalchan)]).zdata(after);
        
    elseif isempty(after) % IF the gap is at the end of the file, replace last data points (NaN) by last valid data point
        
        data.VideoData.(['channel', num2str(Signalchan)]).xdata(before+1:end) = data.VideoData.(['channel', num2str(Signalchan)]).xdata(before);
        data.VideoData.(['channel', num2str(Signalchan)]).ydata(before+1:end) = data.VideoData.(['channel', num2str(Signalchan)]).ydata(before);
        data.VideoData.(['channel', num2str(Signalchan)]).zdata(before+1:end) = data.VideoData.(['channel', num2str(Signalchan)]).zdata(before);

        
    else % If not at the beginning or the end of the file: Linearly interpolate between valid data points just before and after the gap

        data.VideoData.(['channel', num2str(Signalchan)]).xdata(before+1:after-1) = interp1(1:2,data.VideoData.(['channel', num2str(Signalchan)]).xdata([before, after]),1:1/(after-before-2):2);
        data.VideoData.(['channel', num2str(Signalchan)]).ydata(before+1:after-1) = interp1(1:2,data.VideoData.(['channel', num2str(Signalchan)]).ydata([before, after]),1:1/(after-before-2):2);
        data.VideoData.(['channel', num2str(Signalchan)]).zdata(before+1:after-1) = interp1(1:2,data.VideoData.(['channel', num2str(Signalchan)]).zdata([before, after]),1:1/(after-before-2):2);
        
    end

    % Find remaining gaps
gaps=find(isnan(data.VideoData.(['channel', num2str(Signalchan)]).xdata));
nogaps=find(~isnan(data.VideoData.(['channel', num2str(Signalchan)]).xdata));

end