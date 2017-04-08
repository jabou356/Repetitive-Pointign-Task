% ----------------------------------------------------------------------- %
% The OpenSim API is a toolkit for musculoskeletal modeling and           %
% simulation. See http://opensim.stanford.edu and the NOTICE file         %
% for more information. OpenSim is developed at Stanford University       %
% and supported by the US National Institutes of Health (U54 GM072970,    %
% R24 HD065690) and by DARPA through the Warrior Web program.             %
%                                                                         %
% Copyright (c) 2005-2012 Stanford University and the Authors             %
% Author(s): Edith Arnold                                                 %
%                                                                         %
% Licensed under the Apache License, Version 2.0 (the "License");         %
% you may not use this file except in compliance with the License.        %
% You may obtain a copy of the License at                                 %
% http://www.apache.org/licenses/LICENSE-2.0.                             %
%                                                                         %
% Unless required by applicable law or agreed to in writing, software     %
% distributed under the License is distributed on an "AS IS" BASIS,       %
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or         %
% implied. See the License for the specific language governing            %
% permissions and limitations under the License.                          %
% ----------------------------------------------------------------------- %

% Modified from setupAndRunIKBatchExample.m
% Author: Edith Arnold (Modified by Jason BouffarD)

% Pull in the modeling classes straight from the OpenSim distribution
import org.opensim.modeling.*


% Get and operate on the files
scaleTool = ScaleTool(Path.OpensimGenericScale);

TRCfiles=dir([Path.TRCpath '*.trc']);
TRCName=TRCfiles(1).name;
trialForScale = [Path.TRCpath TRCName]; %Eventually Static trial

ScaledModelFile=Path.ScaledModel;
ScaleSetFile=[Path.SubjectPath 'StandfordVA_Hiram' num2str(subjectID(isubject)) 'ScaleSet.xml'];
ScaleModelNewMKRFiler=Path.ScaledAdjustedModel;
scaleTool.setName(['StandfordVA_Hiram' num2str(subjectID(isubject)) 'scaled']);

scaleTool.getGenericModelMaker().setModelFileName(Path.OpensimGenericModel);

% Get initial and intial time
markerData = MarkerData(trialForScale);
% initial_time = markerData.getStartFrameTime(); %For static Trial
% final_time = markerData.getLastFrameTime(); %For static trial
range=ArrayDouble;
range.setValues([5 5.5],2);%([initial_time final_time],2); for static trial

%Setup Model Scaler for this subject

modelscaler=scaleTool.getModelScaler;
modelscaler.setMarkerFileName(trialForScale);
modelscaler.setTimeRange(range);
modelscaler.setOutputModelFileName(ScaledModelFile);
modelscaler.setOutputScaleFileName(ScaleSetFile);
subjectMass=scaleTool.getSubjectMass;
%run Model Scaler
GenModel = Model(Path.OpensimGenericModel);
MyState = GenModel.initSystem();

modelscaler.processModel(MyState,GenModel);

%Setup Marker Placer for this subject



% Setup the ikTool for this trial
markerplacer=scaleTool.getMarkerPlacer;
markerplacer.setStaticPoseFileName(trialForScale);
markerplacer.setTimeRange(range);
markerplacer.setOutputModelFileName(ScaleModelNewMKRFiler);

%Run MarkerPlacer
ScaledModel=Model(ScaledModelFile);
MyState=ScaledModel.initSystem();

markerplacer.processModel(MyState,ScaledModel)

% Save the settings in a setup file
outfile = ['Setup_Scale' num2str(subjectID(isubject)) '.xml'];
scaleTool.print([Path.SubjectPath outfile]);

  

