% Go get the Parent project folder: In our case it is the
% RepetitivePointingTask_forJason folder in the OneDrive
Path.ProjectPath=uigetdir('C:','Go get the project folder');

% If working on Windows, it will find the \ and replace by /
Path.ProjectPath(regexp(Path.ProjectPath,'\'))='/';

% Indicate data from which project you want to analyze (e.g. 'Jason',
% 'Asha', etc.) DO NOT FORGET THE QUOTES
projet=input('Which project are you working on?');


%% Setup common paths

    
    % single subjects Data Path
    Path.DataPath=[Path.ProjectPath '/Data/', projet, '/'];
    
    % OpenSim Setup files (Generic models, scale config, IK config, etc.)
    Path.OpensimSetupJB=[Path.ProjectPath '/OpenSimSetUpFiles/'];
    
    % If the project is Kathryn, take her model (T12 instead of T10)
    if strcmp(projet,'Kathryn')
        
        Path.OpensimGenericModel=[Path.OpensimSetupJB,'Humerothoracic_wscapula - Kathryn.osim'];
        
    else
        
        Path.OpensimGenericModel=[Path.OpensimSetupJB,'Humerothoracic_wscapula.osim'];
        
    end
    
    %  OpenSim scale config
    Path.OpensimGenericScale=[Path.OpensimSetupJB,'Conf_scaling - ' projet '.xml'];
    
    % OpenSim IK config 
    Path.OpensimGenericIK=[Path.OpensimSetupJB,'Conf_IK.xml']; %(generic, not used anymore) 
    Path.OpensimGenericIKtrunk=[Path.OpensimSetupJB,'Conf_IK_trunk.xml']; %(Compute Trunk DoFs first)
    Path.OpensimGenericIKtrunkmot=[Path.OpensimSetupJB,'Conf_IK_wmot.xml']; %(Input Trunk DoFs to compute other DoFs)

    % OpenSim Body kinematics config, not used
    Path.OpensimGenericBK=[Path.OpensimSetupJB,'Conf_BK.xml'];
    
    % Group Paths
    Path.GroupPath=[Path.ProjectPath '/GroupData/']; % Parent group path
    Path.GroupDataPath=[Path.GroupPath 'MegaDatabase/']; % Path containing the .txt database
    Path.JBAnalyse=[Path.GroupPath 'Analysis/Jason/']; % Path where Jason do data analysis (stats. etc.)
   