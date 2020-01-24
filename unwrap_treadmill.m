function speed = unwrap_treadmill(analog_tread,ts)
%speed = unwrap_treadmill(analog_tread,ts)
% Marina Oct 29, 2019

%   Converts analog signal acquired by bpod from treadmill into speed
%   ******INPUTS******
%   analog_tread:   the analog signal from bpod
%   ts:             the timestamps of the analog_tread signal in seconds. 
%                   should be same size vector as analog_tread 
%                   OR a scalar whose magnitude is the size of the timebin

%   ******OUTPUT******
%   speed:          speed mouse was running in cm/s

if length(ts) == length(analog_tread)
    tb = mean(unique(diff(ts)));% time bin in s (seems to be 0.005)
else
    tb = ts;
end

cal_factor = 7.5/(2*pi);%centimeters per one voltage "cycle" (~5V)

% converts signal into 2*pi scale, inverts to positive
tread = -2*pi*(analog_tread - range(analog_tread))/range(analog_tread);

%unwraps treadmill
tread = unwrap(tread);

%converts signal to centimeters and divides by time to get speed (cm/s)
if length(ts) == length(analog_tread)
    speed = diff(tread*cal_factor)./diff(ts);
else
    speed = diff(tread*cal_factor)/tb;
end

%copies last measurement so speed has same size as analog_tread
speed(end+1) = speed(end);
end

