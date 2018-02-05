function [Xvalue, TruePositive, TrueNegative, FalsePositive, FalseNegative] = Discriminant (X, Y, varargin)
%Developed by Jason Bouffard to compute discriminant validity of outcome
%measures during the RPT.
%Input X: AxB matrix with the analyzed signals (A = number of signals, B =
%number of observations).
%Input Y = B vector with the dichotomic criterion. Highest value is a case
%Input S = scalar indicating number of steps (default 100)
%
%Output Xvalue: A x S matrix Values of the analyzed signal for which sensitivity and
%specificity has been tested. (A = number of analyzed signals, S = number
%of steps [usually 100]
%Output Sensitivity: A x S matrix Sensitivity of each signal at each Xvalue 
%Output Specificity: A x S matrix Specificity of each signal at each Xvalue 

%% Default number of steps is 100
if ~exist('S','var')
    S = 100;
end

    nCase = length(find(Y==max(Y)));
    nHealthy = length(find(Y==min(Y)));
    
for isignal = 1 : size(X,1)
    
    %% determine range of values to be tested for sensitivity and specificity
    lowest = min(X(isignal,:));
    highest = max(X(isignal,:));
    steps = (highest - lowest) / (S-1);
    Xvalue(isignal,:) = lowest : steps: highest;
    
    %% look if cases are > or < than healthy
    if mean(X(isignal,Y == max(Y))) > mean(X(isignal,Y == min(Y)))
        Xreverse = 0;
    else
        Xreverse = 1;
    end
    %% Determine Sensitivity and specificity
    
    for istep = 1:S
        
        if ~Xreverse
            
        TruePositive(isignal,istep) = length(find(Y==max(Y) & X(isignal,:) > Xvalue(isignal, istep)));
        TrueNegative(isignal,istep) = length(find(Y==min(Y) & X(isignal,:) < Xvalue(isignal, istep)));
        FalsePositive(isignal,istep) = length(find(Y==min(Y) & X(isignal,:) > Xvalue(isignal, istep)));
        FalseNegative(isignal,istep) = length(find(Y==max(Y) & X(isignal,:) < Xvalue(isignal, istep)));
        
        else
            
        TruePositive(isignal,istep) = length(find(Y==max(Y) & X(isignal,:) < Xvalue(isignal, istep)));
        TrueNegative(isignal,istep) = length(find(Y==min(Y) & X(isignal,:) > Xvalue(isignal, istep)));
        FalsePositive(isignal,istep) = length(find(Y==min(Y) & X(isignal,:) < Xvalue(isignal, istep)));
        FalseNegative(isignal,istep) = length(find(Y==max(Y) & X(isignal,:) > Xvalue(isignal, istep)));
        
        end
        
        
    end %istep
end %isignal


