%% Chemin des fichiers
    % Dossier du sujet
    Path.SubjectPath  = [Path.DataPath 'Subject' num2str(subjectID(isubject)) '/'];
    % Dossier du modèle pour le sujet
    Path.ScaledModel  = [Path.SubjectPath 'StandfordVA_Hiram' num2str(subjectID(isubject)) '.osim'];
    Path.ScaledAdjustedModel  = [Path.SubjectPath 'StandfordVA_Hiram' num2str(subjectID(isubject)) 'Adjusted.osim'];

    % Dossier des data
    Path.KLOimportPath = [Path.SubjectPath 'inputKLO/'];
    % Dossiers d'exportation
    
    Path.RotateKLOPath = [Path.SubjectPath 'rotateKLO/'];
    if isdir(Path.RotateKLOPath)==0
        mkdir(Path.RotateKLOPath);
    end
    
    Path.exportPath = [Path.SubjectPath 'Result/'];
    
    if isdir(Path.exportPath)==0
        mkdir(Path.exportPath);
    end
    
    Path.TRCpath=[Path.SubjectPath,'TRC/'];
    if isdir(Path.TRCpath)==0
        mkdir(Path.TRCpath);
    end
    
    Path.IKpath=[Path.SubjectPath,'IK/'];
    Path.IKresultpath=[Path.IKpath,'result/'];
    Path.IKsetuppath=[Path.IKpath,'setup/'];
    if isdir(Path.IKpath)==0
        mkdir(Path.IKpath);
        mkdir(Path.IKresultpath);
        mkdir(Path.IKsetuppath);
    end
    
   