markerinput={'CLAV', 'STRN', 'C7', 'T10', 'LSHO', 'LUPA', 'LELB', 'LFRM', 'LWRA', 'LWRB', 'LFIN', 'LDIX'}; %'STRN',
markeroutput={'CLAV', 'STRN', 'C7', 'T10', 'RSHO', 'RUPA', 'RELB', 'RFRM', 'RWRA', 'RWRB', 'RFIN', 'RDIX'};%'STRN',

for i = 1 : length(fieldnames(data.VideoFilt))
    channame{i} = data.VideoFilt.(['channel', num2str(i)]).label;
end

for i = 1 : length(markerinput)
    
    chaninput=find(arrayfun(@(x)(strcmp(markerinput{i},x)),channame));
    chanoutput=find(arrayfun(@(x)(strcmp(markeroutput{i},x)),channame));
    
    data.VideoFilt.(['channel', num2str(chanoutput)]).xdata = data.VideoFilt.(['channel', num2str(chaninput)]).xdata;
    data.VideoFilt.(['channel', num2str(chanoutput)]).ydata = data.VideoFilt.(['channel', num2str(chaninput)]).ydata;
    data.VideoFilt.(['channel', num2str(chanoutput)]).zdata = data.VideoFilt.(['channel', num2str(chaninput)]).zdata * -1;
end