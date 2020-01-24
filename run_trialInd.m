function [runTr,speedTr] = run_trialInd(SessionData)
%%
run_thresh=1; %1 cm/s

if ~iscell(SessionData.AnalogInputData) %fix for dark protocol
    SessionData.AnalogInputData={SessionData.AnalogInputData};
end

%measure number of timestamps in each trial
nts = nan(size(SessionData.AnalogInputData));
for t = 1:length(SessionData.AnalogInputData)
    nts(t) = size(SessionData.AnalogInputData{t}.y,2);
end

% extract treadmill and timestamp
tread = nan(min(nts),length(SessionData.AnalogInputData));
tb = nan(min(nts),length(SessionData.AnalogInputData));
for t = 1:length(SessionData.AnalogInputData)
    tread(:,t) = SessionData.AnalogInputData{t}.y(1,1:min(nts))';
    tb(:,t) = SessionData.AnalogInputData{t}.x(1:min(nts))';
end

% unwrap treadmill signal
tb = mode(diff(tb(:)));
avgWind=(1/tb)/2; %smooth over 0.5s
speed = smooth(unwrap_treadmill(tread(:),tb),avgWind);

% separate back into trials
speedTr = reshape(speed,size(tread));

% extract running trials
runTr = trialSepByRun(speedTr,run_thresh);

%     % save run trials
%     save([savefn filesep 'runTr_' flag],'runTr')
end