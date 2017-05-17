function [timestamp, timegap, anglev, firststamp] = readgyro ( filepath )

% read gyro information with timestamps from the android app generated file

% [timestamp, acc, anglevx, anglevy, anglevz] = textread(filepath, '%f,%d,%f,%f,%f,');
% anglev = [anglevx, anglevy, anglevz];
% timestamp = timestamp./(1e9);
% firststamp = timestamp(1);
% timestamp = timestamp - timestamp(1); % make the first timestamp as 0
% timegap = diff(timestamp);

% filepath='data/gyro2.txt';
[time, acc, anglevx, anglevy, anglevz] = textread(filepath, '%f,%d,%f,%f,%f,');
anglev = [anglevx, anglevy, anglevz];
a=num2str(time,17);
time= datevec(a,'yyyymmddHHMMSSFFF');

firststamp = time(1,:);

for i=1:length(time)
  timestamp(i,1)= etime(time(i,:),firststamp);
end
timegap = diff(timestamp);




