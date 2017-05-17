% Demo script of calibration and synchronization of rolling shutter cameras for video stabilization
% 2012-2-10

clear all;
clc;
addpath('ekf');
addpath('file_manage');

% read files and prepare the parameters
imagepath = 'data/images';
[framestamp, framegap] = readts('data/framestamps1.txt');
[gyrostamp, gyrogap, anglev] = readgyro('data/gyro2.txt');

framestart = 1;
frameend = length(framestamp);

% sift feature detection and matching
% [match_idx, match_x1, match_x2] = sift_track(imagepath, framestart, frameend);
% save_sift('data', match_idx, match_x1, match_x2);
% if have done sift tracking before, just read files
[match_idx, match_x1, match_x2] = read_sift('data');

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calibration and synchronization using the method in the following paper
% "Digital video stabilization and rolling shutter correction using gyroscopes", A. Karpenko, et. al.

% initialize variables
w = 1920; % size of the video
h = 1080; % size of the video
p0 = zeros(8,1);
p0(1)= 0.0183; % duty cycle
p0(2) = 0.5860; % delay between video and gyroscope timestamps
p0(3:5) = [0; 0; 0];
p0(6) = 1329.75; %f % the initial guess of focal length, got from Zhang's camear calibration method
p0(7) = 0.5*(w-1); % optical center
p0(8) = 0.5*(h-1); % optical center


% the actual measurements
x = reshape(match_x2', 2*size(match_x2,1), 1);

% call levmar
options=[1E-03, 1E-15, 1E-15, 1E-20, 1E-06];
INFI = 1E20;
lb = [0; 0; -pi; -pi; -pi; 0];
ub = [0.05; 2; pi; pi; pi; INFI];
tic
[ret, popt, info, covar] = levmar('calibfun', p0, x, 500, options, 'unc', match_x1, match_x2, match_idx, gyrostamp, gyrogap, anglev, framestamp, w, h);
toc

% the estimated parameters are in the variable 'popt'
	



