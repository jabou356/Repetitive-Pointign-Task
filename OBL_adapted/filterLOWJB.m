% Nancy St-Onge, April 2004
% You need trouver_fc
% Zero-lag low-pass filter
%  dataFILT=filterLOW(data,order,Fs,Fc)

function dataFILT=filterLOW(data,order,Fs,Fc)

% Wn = high cut-off frequency

%nFc=trouver_fc(order,Fs,Fc,'low');
Wn=2*Fc/Fs;

% to find coefficients for a low-pass butterworth filter

[b,a]=butter(order,Wn);

% filter data using filtfilt to avoid delay
 
dataFILT = filtfilt(b,a,data);
    
 