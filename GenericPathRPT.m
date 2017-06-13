Path.ProjectPath=uigetdir('C:','Go get the project folder');


%% Setup common paths
Path.DataPath=[Path.ProjectPath '/Data/'];
Path.OpensimSetupJB=[Path.ProjectPath '/OpenSimSetUpFiles/'];
Path.OpensimGenericModel=[Path.OpensimSetupJB,'Humerothoracic_wscapula.osim'];
Path.OpensimGenericScale=[Path.OpensimSetupJB,'Conf_scaling.xml'];
Path.OpensimGenericIK=[Path.OpensimSetupJB,'Conf_IK.xml'];
Path.OpensimGenericBK=[Path.OpensimSetupJB,'Conf_BK.xml'];
Path.GroupDataPath=[Path.ProjectPath '/GroupData/'];
