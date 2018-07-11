function [ p, r, rLow, rUp ] = CorrelationAnalysis( Megadatabase, signal, statistic, variable)
%CorrelationAnalysis Summary of this function goes here
%   Detailed explanation goes here

Y=[Megadatabase(strcmp(signal,[Megadatabase.Signal]) & ...
    strcmp(statistic,[Megadatabase.Stat]) & ...
    ~isnan([Megadatabase.(variable)])).(variable)];

Sex=[Megadatabase(strcmp(signal,[Megadatabase.Signal]) & ...
    strcmp(statistic,[Megadatabase.Stat]) & ...
    ~isnan([Megadatabase.ROMFwd])).Sex];

Time=[Megadatabase(strcmp(signal,[Megadatabase.Signal]) & ...
    strcmp(statistic,[Megadatabase.Stat]) & ...
    ~isnan([Megadatabase.ROMFwd])).Time];

SUBJ=[Megadatabase(strcmp(signal,[Megadatabase.Signal]) & ...
    strcmp(statistic,[Megadatabase.Stat]) & ...
    ~isnan([Megadatabase.ROMFwd])).SubjectID];

Endurance=[Megadatabase(strcmp(signal,[Megadatabase.Signal]) & ...
    strcmp(statistic,[Megadatabase.Stat]) & ...
    ~isnan([Megadatabase.ROMFwd])).Endurance];

%% Compute correlation for men
Men=unique(SUBJ(Sex==1));
EndTime = Endurance(ismember(SUBJ,Men) & Time==1);

% Correlation with baseline values
Ycorr = Y(ismember(SUBJ,Men) & Time==1);
[r.Men.Baseline, p.Men.Baseline, rLow.Men.Baseline, rUp.Men.Baseline]=corrcoef(Ycorr,EndTime);

% Correlation with changes in values
Ycorr=Y(ismember(SUBJ,Men) & Time==2)-Y(ismember(SUBJ,Men) & Time==1);
[r.Men.Change, p.Men.Change, rLow.Men.Change, rUp.Men.Change]=corrcoef(Ycorr,EndTime);

%% Compute correlation for women
Women=unique(SUBJ(Sex==2));
EndTime = Endurance(ismember(SUBJ,Women) & Time==1);

% Correlation with baseline values
Ycorr = Y(ismember(SUBJ,Women) & Time==1);
[r.Women.Baseline, p.Women.Baseline, rLow.Women.Baseline, rUp.Women.Baseline]=corrcoef(Ycorr,EndTime);

% Correlation with changes in values
Ycorr=Y(ismember(SUBJ,Women) & Time==2)-Y(ismember(SUBJ,Women) & Time==1);
[r.Women.Change, p.Women.Change, rLow.Women.Change, rUp.Women.Change]=corrcoef(Ycorr,EndTime);

end
