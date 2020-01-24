%% Runing vs non Running - Ground truth Pipeline
%% Steps 
%       A - File list and Information
% 1 - Input the session 
%       Warning: ! It assumes that the camera files are inside the position
%       folder in a folder called camera  ! 
% 2 - Get the information about the session
% 3 - Get the list of the files 
% 4 - Get stimulus types 
%       B - Region of interest and crop
% 1 - Select one stimulus to be analyzed
% 2 - Load one image of the video
% 3 - Select the region of interest 
% 4 - Load the cropped secction of the video
%       C - Flow
% 1 - Calculate the flow of the cropped secction 
%       D - Theadmill data 
% 1 - Input the threadmill data 
% 2 - Load the data 
% 3 - Transform the data into speed
%       E - Plots 
% 1 - Format the threadmill and the pixel date data in the same time axis 
% 2 - Plot the threadmill data 
% 3 - Plot the pixel change data 
%       F - Threshold parameters
% 1 - Infer the threshold the correct threshold forr separating running vs
% non running 
%       G - Check with a different stimulus 
%% 
%% A - File list and information 
cd('F:\Oihane')
% 1 - Input the session
path = uigetdir({},'Select the session with both the threadmil and camera data');
% the camera files are inside the camera folder 
cameraPath = [path filesep 'camera'];
% 2 - Get the information about the session 
info = f_getSessionInfo(cameraPath);
% 3 - Get the list of the files 
filetype = '*.avi'; % type of files to be processed
files = subdir(fullfile(cameraPath,filetype));   % list of filenames (will search all subdirectories)
nTrials = length(files);
% 4 - Get the stimulus types 
for trial = 1:nTrials
    nameTemp = files(trial).name;
    stimsSep = regexp(nameTemp,'_','split');
    tempStim{trial} = stimsSep{end-1};
   
end
% get the names of the different stimulus
stimTypes = unique(tempStim);
nStim = length(stimTypes);
%% B - Region of interest and crop 
% 1 - Select one stimulus to be analyzed
% we will select one stimulus -> Gratings
stimSelect = 'Grat';
% find the selected stimulus in the stimulus types 
isSelect = contains(stimTypes,stimSelect);
% get the list of the names with that stimulus 
stimType = ['*' stimTypes{isSelect} '*.avi'];
filesStim = subdir(fullfile(cameraPath,stimType)); 
nTrials = length(filesStim);
% Order them appropriatelly 
for trial = 1:nTrials
    nameTemp = filesStim(trial).name;
    stimsSep = regexp(nameTemp,'_','split');
    numberTrial(trial) = str2num(stimsSep{end}(1:end-4));
end
[~,orderedIndx] = sort(numberTrial);

% 2 - Load the image of one of the videos 
% one frame of second trial will be displayed
trial2load = 2;
% increase the brightness
brightadd = 20;
vDisp = VideoReader(filesStim(orderedIndx(trial2load)).name);
vidDisp = read(vDisp);
nFrames = size(vidDisp,4);
imgDisp = vidDisp(:,:,:,floor(nFrames/2))+brightadd;

% 3 - Selct the region of interest 
roiPaw = roipoly(imgDisp);
% make it a mask 
mask = uint8(roiPaw);
% 4 - Load the cropped secction of the video in a structure 
% start from the second trial
for trial = trial2load:nTrials
    vTemp = VideoReader(filesStim(orderedIndx(trial)).name);
    vidTemp = read(vTemp);
    nFrames = size(vidTemp,4);
    for frame = 1:nFrames 
        % separate the colors
        imgTempR = squeeze(vidTemp(:,:,1,frame));
        imgTempG = squeeze(vidTemp(:,:,2,frame));
        imgTempB = squeeze(vidTemp(:,:,3,frame));
        % apply the mask individually        
        imgTempR = imgTempR.*mask;
        imgTempG = imgTempG.*mask;
        imgTempB = imgTempB.*mask;
        % concatenate them again in a matrix
        vidCroped{trial-1}(:,:,:,frame) = cat(3,imgTempB,imgTempG,imgTempR);
    end
end
  
%% C - Flow 
% calculate the pixel flow of the cropped secction 
for trial = 1:nTrials - 1
    nFrames = size(vidCroped{trial},4);
    for frame = 1:nFrames-1 
        pixFlow{trial}(frame) = sum(mean(mean(vidCroped{trial}(:,:,:,frame+1)-vidCroped{trial}(:,:,:,frame))));
    end
end

%% D - Theadmill data
% 1 - Select the stimulus data file 
[stimFile,pathstim] = uigetfile('*.mat',['Select the ', info.aniName ' date ' info.date ' and ' stimSelect,' stimulus file']);
fileStr= load([pathstim filesep stimFile]);
StrName=fieldnames(fileStr);
StrName=StrName{1};
stimData = fileStr.(StrName);
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
