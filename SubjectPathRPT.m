%% Subject specific paths

    % Parent subject path
    Path.SubjectPath  = [Path.DataPath 'Subject' num2str(subjectID(isubject)) '/'];
    
    % Subject specific scaled and adjusted (technical markers placed) models
    Path.ScaledModel  = [Path.SubjectPath 'StandfordVA_' projet num2str(subjectID(isubject)) '.osim'];
    Path.ScaledAdjustedModel  = [Path.SubjectPath 'StandfordVA_' projet num2str(subjectID(isubject)) 'Adjusted.osim'];

    % Path toward inputKLO files
    Path.KLOimportPath = [Path.SubjectPath 'inputKLO/'];
    
    % Path toward Rotated KLOfiles (x: vector between PTRG and DTRG, y: up, z: cross(x,y)    
    Path.RotateKLOPath = [Path.SubjectPath 'rotateKLO/'];
    if isdir(Path.RotateKLOPath)==0
        mkdir(Path.RotateKLOPath);
    end
    
    % Path toward the result folder (including partitionned, IK, etc.)
    Path.exportPath = [Path.SubjectPath 'Result/'];
    
    if isdir(Path.exportPath)==0
        mkdir(Path.exportPath);
    end
    
    % Path toward TRC files (Rotated marker position used to input in
    % OpenSim
    Path.TRCpath=[Path.SubjectPath,'TRC/'];
    if isdir(Path.TRCpath)==0
        mkdir(Path.TRCpath);
    end
    
    % Path toward IK results (Output from OpenSIM)
    Path.IKpath=[Path.SubjectPath,'IK/'];
    Path.IKresultpath=[Path.IKpath,'result/'];
    Path.IKsetuppath=[Path.IKpath,'setup/'];
    if isdir(Path.IKpath)==0
        mkdir(Path.IKpath);
        mkdir(Path.IKresultpath);
        mkdir(Path.IKsetuppath);
    end
    
    % Path toward Body kinematics (output from OpenSim, not used)
    Path.BKpath=[Path.SubjectPath,'BodyKinematics/'];
    Path.BKresultpath=[Path.BKpath,'result/'];
    Path.BKsetuppath=[Path.BKpath,'setup/'];
    if isdir(Path.BKpath)==0
        mkdir(Path.BKpath);
        mkdir(Path.BKresultpath);
        mkdir(Path.BKsetuppath);
    end
    

    
   