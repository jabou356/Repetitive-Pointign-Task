clear 
close all

load('ai_indices.mat');
load('DatabaseRPT.mat');
%% Compute confusion analysis for each variable (ROC analysis) 
for isignal = 1:length(DataBaseRPT.CAssignAll)
% Generate confusion table for each threshold value, from min(X) to max(X)   
[Xvalue(:,isignal), TruePositive(:,isignal), TrueNegative(:,isignal), FalsePositive(:,isignal), FalseNegative(:,isignal)] = Discriminant(DataBaseRPT.AllX(isignal,train+1),DataBaseRPT.Y(train+1));

% Compute Sensitivity and Specificity at each threshold value
Sensitivity(:,isignal)= TruePositive(:,isignal)./(TruePositive(:,isignal)+FalseNegative(:,isignal));
Specificity(:,isignal)= TrueNegative(:,isignal)./(TrueNegative(:,isignal)+FalsePositive(:,isignal));

% Find the optimal cutoff point based on Youden's J statistic
J(:,isignal) = Sensitivity(:,isignal) + Specificity(:,isignal) - 1 ;
OptimalID(isignal)=find(J(:,isignal)==max(J(:,isignal)),1,'first');
OptimalThreshold(isignal)=Xvalue(OptimalID(isignal),isignal);

optSpec(isignal) = Specificity(OptimalID(isignal),isignal);
optSens(isignal) = Sensitivity(OptimalID(isignal),isignal);

% AUC = int (y*dx) here dx is 1/100;
ROCauc(isignal) = abs(trapz(1-Specificity(:,isignal),Sensitivity(:,isignal)));


end

%% Compute confusion analysis (ROC analysis) for a compound variable (i.e. summing Z scores of variables with SRM > 0.8 in Bouffard et al 2018)
%For each of BestX: compute Average and StandDev of train dataset. Will be
%used to compute z score for test dataset
Average = mean(DataBaseRBT.BestX(:,train+1),2);
StandDev = std(DataBaseRBT.BestX(:,train+1),0,2);

% Compute Z score for the variables with SRM > 0.8
Average = mean(DataBaseRBT.BestX(:,train+1),2);
StandDev = std(DataBaseRBT.BestX(:,train+1),0,2);
Z=zscore(DataBaseRPT.BestX,[],2);

% Revert the z scores for variables whose values decrease with fatigue
revert=find(mean(DataBaseRPT.BestX(:,DataBaseRPT.Y==1),2)>mean(DataBaseRPT.BestX(:,DataBaseRPT.Y==2),2));
Z(revert,:)=Z(revert,:)*-1;

% Generate confusion table for each threshold value, from min(X) to max(X) 
[Xvalue(:,isignal+1), TruePositive(:,isignal+1), TrueNegative(:,isignal+1), FalsePositive(:,isignal+1), FalseNegative(:,isignal+1)] = Discriminant(sum(Z(:,train+1),1),DataBaseRPT.Y(train+1));
DataBaseRPT.CAssignAll{isignal+1}='BestXCombined';

% Compute Sensitivity and Specificity at each threshold value
Sensitivity(:,isignal+1)= TruePositive(:,isignal+1)./(TruePositive(:,isignal+1)+FalseNegative(:,isignal+1));
Specificity(:,isignal+1)= TrueNegative(:,isignal+1)./(TrueNegative(:,isignal+1)+FalsePositive(:,isignal+1));

% Find the optimal cutoff point based on Youden's J statistic
J(:,isignal+1) = Sensitivity(:,isignal+1) + Specificity(:,isignal+1) - 1 ;
OptimalID(isignal+1)=find(J(:,isignal+1)==max(J(:,isignal+1)),1,'first');
OptimalThreshold(isignal+1)=Xvalue(OptimalID(isignal+1),isignal+1);

optSpec(isignal+1) = Specificity(OptimalID(isignal+1),isignal+1);
optSens(isignal+1) = Sensitivity(OptimalID(isignal+1),isignal+1);

% AUC = int (x*y*dx) here dx is 1/100;
ROCauc(isignal+1) = abs(trapz(1-Specificity(:,isignal+1),Sensitivity(:,isignal+1)));

%% Figure 1: Position of the optimal cutoff point for each variable on a ROC curve (Train Dataset)

g=gramm('x',1-optSpec,'y',optSens,'label', DataBaseRPT.CAssignAll,'color', max(J));
g.geom_point();
g.geom_label('Color','k');
g.axe_property('YLim',[0 1],'XLim', [0 1]); 
g.set_point_options('base_size',12);
g.geom_abline();
g.set_names('x', 'False Positive rate; 1-specificity', 'y', 'True positive rate. sensitivity', 'color', 'Youden'' s J');
g.draw;

[~, rankJ] = sort(max(J(:,:)), 'descend');
for isignal = 1: size(Sensitivity,2)
    disp([DataBaseRPT.CAssignAll{rankJ(isignal)}, ': Sensitivity = ', num2str(Sensitivity(OptimalID(rankJ(isignal)),rankJ(isignal))), '; Specifcity = ', ...
        num2str(Specificity(OptimalID(rankJ(isignal)),rankJ(isignal))), ...
        '; Optimal Threshold = ', num2str(OptimalThreshold(rankJ(isignal))), '; Youden''s J = ', num2str(max(J(:,rankJ(isignal))))])
end

%% Figure 2: Actual performance of each variables on Test Dataset

% Generate confusion table for each variable at opimal threshold value using test Data 
for isignal = 1:length(DataBaseRPT.CAssignAll)

    if isignal == length(DataBaseRPT.CAssignAll)
    [testXvalue(:,isignal), testTruePositive(:,isignal), testTrueNegative(:,isignal), testFalsePositive(:,isignal), testFalseNegative(:,isignal)] = Discriminant(sum(Z(:,test+1),1),DataBaseRPT.Y(test+1));
    else
    [testXvalue(:,isignal), testTruePositive(:,isignal), testTrueNegative(:,isignal), testFalsePositive(:,isignal), testFalseNegative(:,isignal)] = Discriminant(DataBaseRPT.AllX(isignal,test+1),DataBaseRPT.Y(test+1));
    end
    
    % Compute Sensitivity and Specificity at each threshold value
    AlltestSensitivity(:,isignal)= testTruePositive(:,isignal)./(testTruePositive(:,isignal)+testFalseNegative(:,isignal));
    AlltestSpecificity(:,isignal)= testTrueNegative(:,isignal)./(testTrueNegative(:,isignal)+testFalsePositive(:,isignal));
    
    % Compute Sensitivity and Specificity at Optimal Threshold
    id = find(abs(testXvalue(:,isignal)-OptimalThreshold(isignal)) == min(abs(testXvalue(:,isignal)-OptimalThreshold(isignal))));
    testSensitivity (isignal) = AlltestSensitivity (id,isignal);
    testSpecificity (isignal) = AlltestSpecificity (id,isignal);
    
    % AUC = int (y*dx) here dx is 1/100;
    testROCauc(isignal) = abs(trapz(1-AlltestSpecificity(:,isignal),AlltestSensitivity(:,isignal)));


end

%[testTruePositive, testTrueNegative, testFalsePositive, testFalseNegative] = DiscriminantTest([DataBaseRPT.AllX(:,test+1);sum(Z(:,test+1),1)],DataBaseRPT.Y(test+1),OptimalThreshold);

% Compute sensitivity and specificity for the optimal cutoff point using test Data
% testSensitivity = testTruePositive./(testTruePositive+testFalseNegative);
% testSpecificity = testTrueNegative./(testTrueNegative+testFalsePositive);
testJ = testSensitivity + testSpecificity - 1;

% Generate report
figure
g=gramm('x',1-testSpecificity,'y',testSensitivity,'label', DataBaseRPT.CAssignAll,'color', testJ);
g.geom_point();
g.geom_label('Color','k');
g.axe_property('YLim',[0 1],'XLim', [0 1]); 
g.set_point_options('base_size',12);
g.geom_abline();
g.set_names('x', 'False Positive rate; 1-specificity', 'y', 'True positive rate. sensitivity', 'color', 'Youden'' s J');
g.draw;

for isignal = 1: length(testSensitivity)
    disp([DataBaseRPT.CAssignAll{rankJ(isignal)}, ': Sensitivity = ', num2str(testSensitivity(rankJ(isignal))), '; Specifcity = ', num2str(testSpecificity(rankJ(isignal))), ...
        '; Optimal Threshold = ', num2str(OptimalThreshold(rankJ(isignal))), '; Youden''s J = ', num2str(testJ(rankJ(isignal))),...
        '; ROC area = ',  num2str(testROCauc(rankJ(isignal)))])
end

%% Figures: ROC curve for each variable (TrainDataset)
for isignal = 1: size(Sensitivity,2)
    disp([DataBaseRPT.CAssignAll{rankJ(isignal)}, ': ROC auc = ', num2str(ROCauc(rankJ(isignal)))])
end

figure 
g=gramm('x',(1-Specificity)','y',Sensitivity');
g.fig(DataBaseRPT.CAssignAll);
g.geom_line();
g.geom_abline();
g.set_names('x', 'False Positive rate; 1-specificity', 'y', 'True positive rate. sensitivity');
g.draw;

