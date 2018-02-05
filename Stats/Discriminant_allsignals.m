clear J OptimalThreshold
%% For each signal, compute Discriminant validity statistics for each threshold value and find optimal threshold (ROC area)
for isignal = length(DataBaseRPT.CAssignAll):-1:1
    
[Xvalue(:,isignal), TruePositive(:,isignal), TrueNegative(:,isignal), FalsePositive(:,isignal), FalseNegative(:,isignal)] = Discriminant(DataBaseRPT.AllX(isignal,train+1),DataBaseRPT.Y(train+1));

% Find the optimal cutoff point based on 
J(:,isignal) = TruePositive(:,isignal)./(TruePositive(:,isignal)+FalseNegative(:,isignal))+TrueNegative(:,isignal)./(TrueNegative(:,isignal)+FalsePositive(:,isignal))-1;
OptimalID(isignal)=find(J(:,isignal)==max(J(:,isignal)),1,'first');
OptimalThreshold(isignal)=Xvalue(OptimalID(isignal),isignal);
Sensitivity(isignal)= TruePositive(OptimalID(isignal),isignal)/(TruePositive(OptimalID(isignal),isignal)+FalseNegative(OptimalID(isignal),isignal));
Specificity(isignal)= TrueNegative(OptimalID(isignal),isignal)/(TrueNegative(OptimalID(isignal),isignal)+FalsePositive(OptimalID(isignal),isignal));

end

%% Group the signals with a SRM > 0.8 in Bouffard et al 2018 by adding their Z scores
Z=zscore(DataBaseRPT.BestX,[],2);
revert=find(mean(DataBaseRPT.BestX(:,DataBaseRPT.Y==1),2)>mean(DataBaseRPT.BestX(:,DataBaseRPT.Y==2),2));
Z(revert,:)=Z(revert,:)*-1;
[Xvalue(:,isignal+1), TruePositive(:,isignal+1), TrueNegative(:,isignal+1), FalsePositive(:,isignal+1), FalseNegative(:,isignal+1)] = Discriminant(sum(Z(:,train+1),1),DataBaseRPT.Y(train+1));
DataBaseRPT.CAssignAll{isignal+1}='BestXCombined';

J(:,isignal+1) = TruePositive(:,isignal+1)./(TruePositive(:,isignal+1)+FalseNegative(:,isignal+1))+TrueNegative(:,isignal+1)./(TrueNegative(:,isignal+1)+FalsePositive(:,isignal+1))-1;
OptimalID(isignal+1)=find(J(:,isignal+1)==max(J(:,isignal+1)),1,'first');
OptimalThreshold(isignal+1)=Xvalue(OptimalID(isignal+1),isignal+1);
Sensitivity(isignal+1)= TruePositive(OptimalID(isignal+1),isignal+1)/(TruePositive(OptimalID(isignal+1),isignal+1)+FalseNegative(OptimalID(isignal+1),isignal+1));
Specificity(isignal+1)= TrueNegative(OptimalID(isignal+1),isignal+1)/(TrueNegative(OptimalID(isignal+1),isignal+1)+FalsePositive(OptimalID(isignal+1),isignal+1));
%% For each signal
close all

g=gramm('x',(FalsePositive./(FalsePositive+TrueNegative))','y',(TruePositive./(TruePositive+FalseNegative))');%, 'label', round(data.proportion))
g.fig(DataBaseRPT.CAssignAll);
g.geom_line();
g.geom_label('Color','auto');
g.draw;

figure
g=gramm('x',1-Sensitivity,'y',Specificity,'label', DataBaseRPT.CAssignAll,'color', max(J));
g.geom_point();
g.geom_label('Color','k');
g.axe_property('YLim',[0 1],'XLim', [0 1]); 
g.set_point_options('base_size',12)
g.draw;
