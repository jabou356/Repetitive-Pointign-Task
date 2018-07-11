function [TruePositive, TrueNegative, FalsePositive, FalseNegative] = DiscriminantTest (X, Y, Threshold)
%Developed by Jason Bouffard to compute discriminant validity of outcome
%measures during the RPT.
%Input X: AxB matrix with the analyzed signals (A = number of signals, B =
%number of observations).
%Input Y = B vector with the dichotomic criterion. Highest value is a case
%Input S = scalar indicating number of steps (default 100)
%
%Output Xvalue: A vector Values of the analyzed signal for which sensitivity and
%specificity has been tested. (A = number of analyzed signals)
%Output Sensitivity: A vector Sensitivity of each signal at each Xvalue 
%Output Specificity: A vector Specificity of each signal at each Xvalue 

%% Default number of steps is 100

    nCase = length(find(Y==max(Y)));
    nHealthy = length(find(Y==min(Y)));
    
for isignal = size(X,1):-1:1
    
    %% look if cases are > or < than healthy
    if mean(X(isignal,Y == max(Y))) > mean(X(isignal,Y == min(Y)))
        Xreverse = 0;
    else
        Xreverse = 1;
    end
    %% Determine Sensitivity and specificity

        if ~Xreverse
            
        TruePositive(isignal) = length(find(Y==max(Y) & X(isignal,:) > Threshold(isignal)));
        TrueNegative(isignal) = length(find(Y==min(Y) & X(isignal,:) < Threshold(isignal)));
        FalsePositive(isignal) = length(find(Y==min(Y) & X(isignal,:) > Threshold(isignal)));
        FalseNegative(isignal) = length(find(Y==max(Y) & X(isignal,:) < Threshold(isignal)));
        
        else
            
        TruePositive(isignal) = length(find(Y==max(Y) & X(isignal,:) < Threshold(isignal)));
        TrueNegative(isignal) = length(find(Y==min(Y) & X(isignal,:) > Threshold(isignal)));
        FalsePositive(isignal) = length(find(Y==min(Y) & X(isignal,:) < Threshold(isignal)));
        FalseNegative(isignal) = length(find(Y==max(Y) & X(isignal,:) > Threshold(isignal)));
        
        end
              
end %isignal


