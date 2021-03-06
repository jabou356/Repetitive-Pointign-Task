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
Average = mean(DataBaseRPT.BestX(:,train+1),2);
StandDev = std(DataBaseRPT.BestX(:,train+1),0,2);

% Compute Z score for the variables with SRM > 0.8
for isignal = 1:length(DataBaseRPT.CAssignBest)
    
Z(isignal,:)=(DataBaseRPT.BestX(isignal,:)-Average(isignal))/StandDev(isignal);

end

% Revert the z scores for variables whose values decrease with fatigue
revert=find(mean(DataBaseRPT.BestX(:,DataBaseRPT.Y==1),2)>mean(DataBaseRPT.BestX(:,DataBaseRPT.Y==2),2));
Z(revert,:)=Z(revert,:)*-1;

% Generate confusion table for each threshold value, from min(X) to max(X) 
[Xvalue(:,length(DataBaseRPT.CAssignAll)+1), TruePositive(:,length(DataBaseRPT.CAssignAll)+1), TrueNegative(:,length(DataBaseRPT.CAssignAll)+1), FalsePositive(:,length(DataBaseRPT.CAssignAll)+1), FalseNegative(:,length(DataBaseRPT.CAssignAll)+1)] = Discriminant(sum(Z(:,train+1),1),DataBaseRPT.Y(train+1));

% Compute Sensitivity and Specificity at each threshold value
Sensitivity(:,length(DataBaseRPT.CAssignAll)+1)= TruePositive(:,length(DataBaseRPT.CAssignAll)+1)./(TruePositive(:,length(DataBaseRPT.CAssignAll)+1)+FalseNegative(:,length(DataBaseRPT.CAssignAll)+1));
Specificity(:,length(DataBaseRPT.CAssignAll)+1)= TrueNegative(:,length(DataBaseRPT.CAssignAll)+1)./(TrueNegative(:,length(DataBaseRPT.CAssignAll)+1)+FalsePositive(:,length(DataBaseRPT.CAssignAll)+1));

% Find the optimal cutoff point based on Youden's J statistic
J(:,length(DataBaseRPT.CAssignAll)+1) = Sensitivity(:,length(DataBaseRPT.CAssignAll)+1) + Specificity(:,length(DataBaseRPT.CAssignAll)+1) - 1 ;
OptimalID(length(DataBaseRPT.CAssignAll)+1)=find(J(:,length(DataBaseRPT.CAssignAll)+1)==max(J(:,length(DataBaseRPT.CAssignAll)+1)),1,'first');
OptimalThreshold(length(DataBaseRPT.CAssignAll)+1)=Xvalue(OptimalID(length(DataBaseRPT.CAssignAll)+1),length(DataBaseRPT.CAssignAll)+1);

optSpec(length(DataBaseRPT.CAssignAll)+1) = Specificity(OptimalID(length(DataBaseRPT.CAssignAll)+1),length(DataBaseRPT.CAssignAll)+1);
optSens(length(DataBaseRPT.CAssignAll)+1) = Sensitivity(OptimalID(length(DataBaseRPT.CAssignAll)+1),length(DataBaseRPT.CAssignAll)+1);

% AUC = int (x*y*dx) here dx is 1/100;
ROCauc(length(DataBaseRPT.CAssignAll)+1) = abs(trapz(1-Specificity(:,length(DataBaseRPT.CAssignAll)+1),Sensitivity(:,length(DataBaseRPT.CAssignAll)+1)));

% Append 'BestXCombined' at the end of CAssignAll
DataBaseRPT.CAssignAll{length(DataBaseRPT.CAssignAll)+1}='BestXCombined';


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
for isignal = 1: length(DataBaseRPT.CAssignAll)
    disp([DataBaseRPT.CAssignAll{rankJ(isignal)}, ': Sensitivity = ', num2str(Sensitivity(OptimalID(rankJ(isignal)),rankJ(isignal))), '; Specifcity = ', ...
        num2str(Specificity(OptimalID(rankJ(isignal)),rankJ(isignal))), ...
        '; Optimal Threshold = ', num2str(OptimalThreshold(rankJ(isignal))), '; Youden''s J = ', num2str(max(J(:,rankJ(isignal))))])
    
    % romain
    train_sensitivity(rankJ(isignal)) = Sensitivity(OptimalID(rankJ(isignal)),rankJ(isignal));
    train_specificity(rankJ(isignal)) = Specificity(OptimalID(rankJ(isignal)),rankJ(isignal));
end

%% Figure 2: Actual performance of each variables on Test Dataset

% Generate confusion table for each variable at opimal threshold value using test Data 
X_train = DataBaseRPT.AllX(:,train+1);
y_train = DataBaseRPT.Y(train+1);

revert=find(mean(X_train(:, y_train==1), 2) > mean(X_train(:, y_train==2), 2));

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
    %id = find(abs(testXvalue(:,isignal)-OptimalThreshold(isignal)) == min(abs(testXvalue(:,isignal)-OptimalThreshold(isignal))));
    if any(isignal == revert)
        id = find(testXvalue(:,isignal)>=OptimalThreshold(isignal),1,'first');
    else
        id = find(testXvalue(:,isignal)<=OptimalThreshold(isignal),1,'last');
    end

    testSensitivity (isignal) = AlltestSensitivity (id,isignal);
    testSpecificity (isignal) = AlltestSpecificity (id,isignal);
    
    % AUC = int (y*dx) here dx is 1/100;
    testROCauc(isignal) = abs(trapz(1-AlltestSpecificity(:,isignal),AlltestSensitivity(:,isignal)));


end

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
    
    % romain
    test_sensitivity(isignal) = testSensitivity(isignal);
    test_specificity(isignal) = testSpecificity(isignal);
end

%% Figures: ROC curve for each variable (TrainDataset)
for isignal = 1: size(Sensitivity,2)
    disp([DataBaseRPT.CAssignAll{rankJ(isignal)}, ': ROC auc = ', num2str(ROCauc(rankJ(isignal)))])
end
% 
figure 
g=gramm('x',(1-Specificity)','y',Sensitivity');
g.fig(DataBaseRPT.CAssignAll);
g.geom_line();
g.geom_abline();
g.set_names('x', 'False Positive rate; 1-specificity', 'y', 'True positive rate. sensitivity');
g.draw;


%% Romain



for train_or_test = {train, test}
    if length(train_or_test{:}) > 50
        disp('train evaluation:')
        jason.auc = ROCauc;
        jason.sensitivity = train_sensitivity;%(end:-1:1);
        jason.specificity = train_specificity;%(end:-1:1);
    else
        disp('test evaluation:')
        jason.auc = testROCauc;
        jason.sensitivity = test_sensitivity;
        jason.specificity = test_specificity;
    end

    for isignal = 1 : length(DataBaseRPT.CAssignAll)
        if isignal == length(DataBaseRPT.CAssignAll)
            current = sum(Z(:, train_or_test{:} + 1), 1);
        else
            current = DataBaseRPT.AllX(isignal, train_or_test{:} + 1);
        end

        threshold = OptimalThreshold(isignal);


        if any(isignal == revert)
            y_pred = (current < threshold) + 1;
        else
            y_pred = (current > threshold) + 1;
        end

        y_true = DataBaseRPT.Y(train_or_test{:} + 1);

        c_mat = confusionmat(y_true, y_pred);

        tp = c_mat(2, 2);
        fp = c_mat(1, 2);
        fn = c_mat(2, 1);
        tn = c_mat(1, 1);

        fprintf('\t%s\n', DataBaseRPT.CAssignAll{isignal})

        % a. precision
        precision = tp ./ (tp + fp);
        fprintf('\t\tprecision = %4.2f\n', precision)

        % b. sensitivity (or recall)
        sensitivity = tp ./ (tp + fn);
        fprintf('\t\tsensitivity = %4.2f (Jason''s: %4.2f)\n',...
            sensitivity, jason.sensitivity(isignal))

        % c. specificity
        specificity = tn ./ (tn + fp);
        fprintf('\t\tspecificity = %4.2f (Jason''s: %4.2f)\n',...
            specificity, jason.specificity(isignal))

        % d. ROC AUC
        [X, Y, T, auc] = perfcurve(y_true, y_pred, 2);
        fprintf('\t\tROC auc = %4.2f (Jason''s: %4.2f)\n',...
            auc, jason.auc(isignal))
    end % isignal
    clear jason
end % train_or_test
