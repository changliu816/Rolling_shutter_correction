% 2012-2-17
% This is the demo script for rolling shutter correction
% pure rotational motion model
% All the necessary parameters are supposed to have been calibrated; especially ts,td and f

clear all;
clc;
load 'para.mat';
addpath('ekf');
addpath('file_manage');
run('vlfeat/toolbox/vl_setup')
% [gyrostamp1, gyrogap1, anglev1, firststamp1] = readgyro('data/gyro1.txt');
% [framestamp, framegap] = readts('data/framestamps4.txt');
[gyrostamp, gyrogap, anglev, firststamp] = readgyro('data/gyro1.txt');
newimgpath = 'data/steadyimages';
imagepath = 'data/images';
videopath='data/33.mp4' ; %'data/videosample.mp4';
obj = VideoReader(videopath);  %'data/videosample.mp4'   'data/11_converted.mp4' 
framenum = obj.NumberofFrames;

% read the video and extract the frames
%% Insert the time delay  (td)
[framestamp, framegap] = readts('data/framestamps1.txt');
cd 'data/shutter_correction_samples';
fid = fopen('td.txt');
%data = textscan(fid,'%f%f%f%f','HeaderLines',2,'CollectOutput',1);
td = textscan(fid,'%f');
fid = fclose(fid);
cd  ../..;
para.td=cell2mat(td);
%%
para.w=1920;
para.h=1080;
para.f=1329.75; %1.7333e+03  =1329.75
para.Kinv=[1,0,-(para.w-1)/2;0,1,-(para.h-1)/2;0,0,para.f];
para.K=inv(para.Kinv);
%% calculate new td and drop those frames ahead of gyro
tmp1=find(framestamp>para.td);
tmp2=framestamp(tmp1);
framestamp=0;
framestamp=tmp2;
para.td= framestamp(1)-para.td;
framestamp=framestamp-framestamp(1);

imreadfromvideo(videopath, imagepath,tmp1(1));
  
framestart = 1;
frameend = length(framestamp);
%%
% read feature tracks detected from the video
% feature tracks are available for the example video
[match_idx, match_x1, match_x2] = read_sift('data');

% if the feature tracks are not available, detect the matched features first
% [match_idx, match_x1, match_x2] = sift_track(imagepath, framestart, frameend);
% save_sift('data', match_idx, match_x1, match_x2);
%% 
% load the parameters of the cellphone camera and gyroscope
% The parameters are different for different cellphones
% The provided prameters are used for Google Nexus S
% For other cellphones please do calibration first using the script "calib_demo.m"
% The delay between the video timestamp and gyroscope timestamp "para.td" is video-specific now  0.586  
%     so it needs to be re-estimate using "calib_demo.m" for different video sequences. This will be
%     solved later when Android platform can return the video timestamps.
%load 'data/cam_para.mat';
%load 'para.mat';




%%
% subtract the bias from gyroscope readings
% the bias (in cam_para.mat) used here is only for Google Nexus S
% This step is not necessary since our algorithm can effectively correct the bias automatically
% anglev = anglev - repmat(bias,size(anglev,1),1);

% estimate the angular velocities using EKF filtering
endidx = frameend-2;
[anglev_est, tran_err, err_unftd, var_est] = ekf_r_est(match_idx, match_x1, match_x2, gyrostamp, gyrogap, anglev, framestamp, para, endidx);

% start correction
idxstart = 1;
for i = 1: frameend
	% stabilize i_th frame
	oldimg = imread([imagepath, '/image',num2str(i),'.bmp']);
	oldimg = double(oldimg);
	
	stabi_diff = eye(3); % This matrix can be the one to stabilize the video. Now we don't consider stabilization
	[newimg, idxstart] = gyrosteady(oldimg, gyrostamp, gyrogap, anglev_est, idxstart, framestamp(i), para, stabi_diff);
	newimg = uint8(newimg);
	imwrite(newimg, [newimgpath, '/image', num2str(i),'.bmp'], 'bmp');
	
	%show progress
	fprintf('.');
	if mod(i,10)==0 fprintf('\n'); end
end


% show the rectified frames and generate the rectified video file
for k = 1:frameend
	a = imread([newimgpath, '/image',num2str(k),'.bmp']);
	imshow(a);
	M(k) = getframe;
end

vidObj = VideoWriter('rectify.avi');
open(vidObj);
for k = 1:frameend
   writeVideo(vidObj,M(k));
end
close(vidObj);