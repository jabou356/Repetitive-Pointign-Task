% modified by shaheen
% 2017-03-08 Gives the use the option to select individual files or all the
% files in a folder and its subfolders
%
% 2016-11-29 added a msg that asks user to use "sg_Heart_Beat_Removal.m" for heart beat removal.
% Removed notch filter as default.
% Changed the folder selection to multiple files selections
% The Moving Average RMS had problem with different window size and also
% padding. It is now changed.


function rawfilt_OBL(varargin)

% Loops through specifed folder & subfolders to load raw data (*.klo)
% then
% -> Band pass filter EMG data using a zero-lag, 2d order Butterworth (20-500Hz)
% -> Low pass filter kinematics data
% -> Low pass filter FP data
%
% Input : pairs of inputs
%
% GENERAL inputs
% filesnames : name of the files to be filter (fullpath) : cell of string :
%       files{1}='J:\HJR\Data for Francois\Subject 1\Subject 1\Subject 1\Subject 2\Session 1\Trial01.c3d'
%       >>rawfilt_OBL('filesnames',files)
%
% EMG inputs
%
% do_emg : 1 (do filtering : default) or 0 (do not)
%
% emg_bp_fq : frequency of the band filter for emg data. Default [10 450]Hz
%       >>rawfilt_OBL('emg_bp_fq',[10 450])
%
% emg_chan : Ask for selection of the emg channel to filter
%       [1]  : select the channels to filter for each file (Default)
%       [0] : select the channels to filter just one time (first file)
%       [1 0 0 1 0] : select channel to filter for file 1 then repeat until
%       file 3, then ask again at file 4 then repeat to end.
%       [-1 1:8] : will not ask the user and take channel 1 to 8
%       >>rawfilt_OBL('emg_chan',[0])
%
% emg_visu : visualisation of emg
%       [1]  : visualize all the channel (Default)
%       [0]  : visualize none channel
%       [0 1 1 0 1] : visualize channel 2, 3 & 5
%       >>rawfilt_OBL('emg_visu',[0])
%
% emg_hb_rem : remose heart beat : boolean : true | false
%       [true] : remove
%       [false] : don't remove (Default)
%       >>rawfilt_OBL('emg_hb_rem',[0])
%
% emg_window : length of the window in ms for the moving average used to
%       obtain the rms. Default 100ms.
%       >> rawfilt_OBL('emg_window',100)
%
% emg_notch : remove 60Hz and harmonics (up to 480Hz) : true | false
%       [true] : notch filtering 
%       [false] : nothing (Default)
%       >>rawfilt_OBL('emg_notch',true)
%
% emg_notch_fq : frequency noise (default 60Hz)
% >>rawfilt_OBL('emg_notch_fq',60)
%
% emg_notch_harm : harmonics to remove : default : [120 180 240 300 360 420 480]
% >>rawfilt_OBL('emg_notch_harm',[120 180 240 300 360 420 480])
%
% KINEMATIC inputs
%
% % do_kin : 1 (do filtering  : default) or 0 (do not)
%
% kin_fc : low pass cutoff frequency. Default 10Hz
%       >>rawfilt_OBL('kin_fc',[10])
%
% kin_chan : Ask for selection of the kin channel to filter
%       [1]  : select the channels to filter for each file (Default)
%       [0] : select the channels to filter just one time (first file)
%       [1 0 0 1 0] : select channel to filter for file 1 then repeat until
%       file 3, then ask again at file 4 then repeat to end.
%       [-1 1:8] : will not ask the user and take channel 1 to 8
%       >>rawfilt_OBL('kin_chan',[0])
%
% kin_visu : visualisation of kinematics data
%       [1]  : visualize all the channel (Default)
%       [0]  : visualize none channel
%       [0 1 1 0 1] : visualize channel 2, 3 & 5
%       >>rawfilt_OBL('kin_visu',[0])
%
%
% FORCEPLATE inputs
%
%
% exemple :
% #1. empty : default parameters
% rawfilt_OBL
% #2. full : automatic
% 
% rawfilt_OBL('filesnames',matfiles,'emg_chan',[0],'emg_visu',[0],'emg_hb_rem',false,'emg_window',100,'emg_notch',true,'emg_notch_fq',60,'emg_notch_harm',[120 180 240 300 360 420 480],'kin_chan',0,'kin_visu',0)
%
% Karen Lomond, September 22, 2008
% Modified by KL October 31, 2008 to handle klo files
% Modified by KE April,29th, 2013: bandpass changed from 10-500 to 10-450
% to work with new sampling frequency (1000Hz), line 68
% major update Francois Thénault juin 2016

% gestion input
p=inputParser;
validationFcn=@(x) iscell(x) | ischar(x);
addParameter(p,'filesnames',[],validationFcn);
addParameter(p,'do_emg',1);
addParameter(p,'emg_bp_fq',[10 450]);
addParameter(p,'emg_chan',1);
addParameter(p,'emg_visu',1);
addParameter(p,'emg_window',100);
addParameter(p,'emg_hb_rem',false);
addParameter(p,'emg_notch',false);% addParameter(p,'emg_notch',true);
addParameter(p,'emg_notch_fq',60);
addParameter(p,'emg_notch_harm',[120 180 240 300 360 420 480]);
addParameter(p,'do_kin',1);
addParameter(p,'kin_fc',10);
addParameter(p,'kin_chan',0);
addParameter(p,'kin_visu',1);
parse(p,varargin{:})

% files IO
files=p.Results.filesnames;
lecture=false;
if ~iscell(files)
    if ischar(files)
        if isempty(files)
            % ask user
            lecture=true;
        else
            % conver to cell
            files=cellstr(files);
        end
    else
        % ask user to select
        lecture=true;
    end
end
% if true
if lecture
    choice = questdlg('Individual FILE selection or selecting all the files in a FOLDER and its subfolders?', ...
        '!!!Selection Type!!!', ...
        'FILE','FOLDER','FILE');
    % Handle response
    switch choice
        case 'FILE'
            [files,path] = uigetfile('*.klo', 'multiselect', 'on','Select the raw KLO files of interest');
            if isequal(files,0)
                uiwait(msgbox('No KLO file is selected!','No File','error','modal'));
                return;
            end
            if ~iscell(files)
                files = {files};
            end
            files = cellfun(@(x)[path x],files,'uni',false);
        case 'FOLDER'
            fld = uigetdir('Select the folder where your raw data are stored');
            files = engine('path',fld,'extension','klo');
        otherwise
            return;
    end
end

% agencement des choix de canaux
choix_canaux_emg=p.Results.emg_chan;
visu_canaux_emg=p.Results.emg_visu;
choix_canaux_kin=p.Results.kin_chan;
visu_canaux_kin=p.Results.kin_visu;
flag_emg=true;
if numel(choix_canaux_emg) == 1;
    choix_canaux_emg = repmat(choix_canaux_emg,length(files),1);
else
    if choix_canaux_emg(1) == (-1)
        flag_emg=false;
        ok=1;
        s_emg=choix_canaux_emg(2:end);
    end
end
if numel(visu_canaux_emg) == 1;
    plotemgdata = repmat(visu_canaux_emg,length(files),1);
end
flag_kin=true;
if numel(choix_canaux_kin) == 1;
    choix_canaux_kin = repmat(choix_canaux_kin,length(files),1);
else
    if choix_canaux_kin(1) == (-1)
        flag_kin=false;
        ok=1;
        if length(choix_canaux_kin)>1
            
        s_kin=choix_canaux_kin(2:end);
        end
        
    end
end
if numel(visu_canaux_kin) == 1;
    plotkindata = repmat(visu_canaux_kin,length(files),1);
end

% Loops through all emg files
for f = 1:length(files);
    fname = files{f};
%     if f==14 || f==17
%         1
%     end
    
    %Load files
    disp(['--Loading ' fname]);
    load(fname, '-mat'); % -> load variable "data"
    
    
    %Load sample rate
    aFs = data.Parameter.ANALOG.RATE.data;
    vFs = data.Header.VideoHZ;
    
    % do analog data
    if p.Results.do_emg ~=0
        dummy = {};
        % Create dummy variable of just emg data (no labels)
        [v, a] = listchannelc3d(data);
        % if no kin fields
        if isempty(a)
            % Do nothing;
        else
            if flag_emg
                if f==1 | choix_canaux_emg(f) ==1
                    [s_emg ,ok] = listdlg('PromptString','Select EMG channels to filter: ','SelectionMode','multiple','ListString',a);
                else
                    ok =1;
                end
            end
            if ok == 0
                errordlg('No EMG channels selected')
                return
            else
                labels_emg = a(s_emg);
                for i = 1:length(labels_emg);
                    dummy{end+1} = klogetchannel_OBL(data,labels_emg{i},'AnalogData');
                end
            end
            
            %Convert from cell array
            dummy = cell2mat(dummy);
            
            %Remove Offsets
            md = mean(dummy);
            [r, c] = size(dummy);
            dummy=dummy-repmat(md,r,1);
            
            %Remove HB's
            if p.Results.emg_hb_rem;
                uiwait(msgbox({'Use "sg_Heart_Beat_Removal.m" program to remove Heart Beats first.','Then use rawfilt_OBL for filtering.'},...
                               'No HB Removal Here','modal'));
                return;
                % dummy = removeHB(dummy,labels_emg,fname,aFs);
            end
            % do HB remove before notch (signal distorsion)
            if p.Results.emg_notch;
                % check if harmonics > Nyquist
                nb_harm=p.Results.emg_notch_harm;
                nb_harm(nb_harm> (aFs./2))=[];
                for h=nb_harm;
                    d = designfilt('bandstopiir','FilterOrder',2,'HalfPowerFrequency1',h-0.3,'HalfPowerFrequency2',h+0.3,'DesignMethod','butter','SampleRate',aFs);
                    dummy = filtfilt(d,dummy);
                end
            end
            %Band-pass filter the emg emgdata
            disp(['--Filtering ' fname]);
            order=2;% hard coder ?
            [tempFILT]=filterBAND(dummy,order,aFs,p.Results.emg_bp_fq);
            
            %Option to compare filtered and unfiltered emgdata
            if plotemgdata(f) == 1
                %labels = a(s);
                [r ,c] = size(dummy);
                plotfilt(dummy,tempFILT,labels_emg);
                menubox = menu('Accept filter results?','yes','no');
                if menubox ==1
                    disp(' ')
                    disp(['--Saving filtered emgdata ' fname])
                else
                    disp('--Filtering terminated, adjust filter parameters and run again')
                    return
                end
            elseif plotemgdata(f) ~= 1
                disp(['--Saving filtered emgdata ' fname])
            end
            
            %Add filtered data to klo struct
            fldnms = fieldnames(data.AnalogData);
            for j = 1:length(s_emg)
                ch = fldnms{s_emg(j)};
                data.AnalogFilt.(ch) = data.AnalogData.(ch);
                data.AnalogFilt.(ch).data = tempFILT(:,j);
                % do rms
                data.AnalogRMS.(ch) = data.AnalogData.(ch);
                data.AnalogRMS.(ch).data=sg_moving_average_RMS(tempFILT(:,j),p.Results.emg_window);
            end
            
        end
    end % do analog
    
    % do 3d data
    if p.Results.do_kin ~=0
        dummy_kin=[];
        
        [v, a] = listchannelc3d(data);
        % if no kin fields
        if isempty(v)
            % Do nothing;
        else
            if flag_kin
                if choix_canaux_kin(1) ==-1 & length(choix_canaux_kin)==1 %JASON 10 aout 2017
                    s_kin=1:length(v);
                    ok=1;
                    
                elseif f==1 | choix_canaux_kin(f) ==1 | ~exist('s_kin','var')
                    [s_kin, ok] = listdlg('PromptString','Select channels to filter: ','SelectionMode','multiple','ListString',v);
                
                else
                    
                    ok =1;
                end
            end
            if ok == 0
                errordlg('No kinematics channels selected')
                return
            else
                
                labels_kin=v(s_kin);
                for i = 1:length(s_kin)
                    dummy_kin(:,i,1) = getchannelc3d(data,v(s_kin(i)),'x');
                    dummy_kin(:,i,2) = getchannelc3d(data,v(s_kin(i)),'y');
                    dummy_kin(:,i,3) = getchannelc3d(data,v(s_kin(i)),'z');
                end
            end
            % keep nan
            dummy_nan=isnan(dummy_kin);
            % interpolate
            for i=1:3;
                [dummy_kin(:,:,i),arret]=Interpolation_OBL(dummy_kin(:,:,i),'rapport.txt',round(vFs/4));
            end
            % filter
            tempFILT = filterLOWJB(dummy_kin,2,vFs,p.Results.kin_fc);
            % replace nan ?
            tempFILT(dummy_nan)=NaN;
            %Option to compare filtered and unfiltered kindata
            if plotkindata(f) == 1
                %labels = a(s);
                [r ,c] = size(dummy_kin);
                plotfilt(dummy_kin,tempFILT,labels_kin);
                menubox = menu('Accept filter results?','yes','no');
                if menubox ==1
                    disp(' ')
                    disp(['--Saving filtered kindata ' fname])
                else
                    disp('--Filtering terminated, adjust filter parameters and run again')
                    return
                end
            elseif plotkindata(f) ~= 1
                disp(['--Saving filtered emgdata ' fname])
            end
            % add fields
            fldnms = fieldnames(data.VideoData);
            for j = 1:length(s_kin)
                ch = char(fldnms(s_kin(j)));
                data.VideoFilt.(ch) = data.VideoData.(ch);
                data.VideoFilt.(ch).xdata= tempFILT(:,j,1);
                data.VideoFilt.(ch).ydata= tempFILT(:,j,2);
                data.VideoFilt.(ch).zdata= tempFILT(:,j,3);
            end
            
        end
    end
    % do FP data
    if data.Parameter.FORCE_PLATFORM.USED.data ~=0
        
    end
    
    %Save filtered fp data back to klo file
    save(extension(fname,'klo'),'data','-mat');
    clear data;
    
end

disp('>>Done saving filtered EMG data');