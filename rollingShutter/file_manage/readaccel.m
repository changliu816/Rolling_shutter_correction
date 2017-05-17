function [timestamp, accel] = readaccel(filepath, firststamp)

% 2012-2-28
% read accel information with timestamps from the android app generated file

[timestamp, acc, accelx, accely, accelz] = textread(filepath, '%f,%d,%f,%f,%f,');
accel = [accelx, accely, accelz];
timestamp = timestamp./(1e9);
timestamp = timestamp - firststamp; % synchronize with gyro readings