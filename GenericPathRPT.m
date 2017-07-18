Path.ProjectPath=uigetdir('C:','Go get the project folder');
projet=input('Which project are you working on?');
machinetype=menu('Are you working on a PC or a MAC?', 'PC', 'MAC');
%% Setup common paths
if machinetype == 1
Path.DataPath=[Path.ProjectPath '\Data\', projet, '\'];
Path.OpensimSetupJB=[Path.ProjectPath '\OpenSimSetUpFiles\'];
Path.OpensimGenericModel=[Path.OpensimSetupJB,'Humerothoracic_wscapula.osim'];
Path.OpensimGenericScale=[Path.OpensimSetupJB,'Conf_scaling - ' projet '.xml'];
Path.OpensimGenericIK=[Path.OpensimSetupJB,'Conf_IK.xml'];
Path.OpensimGenericBK=[Path.OpensimSetupJB,'Conf_BK.xml'];
Path.GroupDataPath=[Path.ProjectPath '\GroupData\'];

elseif machinetype == 2 
    
Path.DataPath=[Path.ProjectPath '/Data/', projet, '/'];
Path.OpensimSetupJB=[Path.ProjectPath '/OpenSimSetUpFiles/'];
Path.OpensimGenericModel=[Path.OpensimSetupJB,'Humerothoracic_wscapula.osim'];
Path.OpensimGenericScale=[Path.OpensimSetupJB,'Conf_scaling.xml'];
Path.OpensimGenericIK=[Path.OpensimSetupJB,'Conf_IK.xml'];
Path.OpensimGenericBK=[Path.OpensimSetupJB,'Conf_BK.xml'];
Path.GroupDataPath=[Path.ProjectPath '/GroupData/'];
end