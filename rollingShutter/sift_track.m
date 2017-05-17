function [match_idx, match_x1, match_x2] = sift_track(imagepath, framestart, frameend);

% This function is used for rolling shutter camera calibration
% and synchronization with gyro readings.

% This function will provide matched features between adjacent
% frames, detected by SIFT with RANSAC.

% the sift detection will use "vlfeat" library
%s = warning('off', 'Images:initSize:adjustingMag');
warning off;

% make sure VLFEAT has been installed 

tempimg = imread([imagepath,'/image1.bmp']);
h = size(tempimg, 1);
w = size(tempimg, 2);

base_frame = imread([imagepath,'/image',num2str(framestart),'.bmp']);
Ib = single(rgb2gray(base_frame)) / 255;
[fb, db] = vl_sift(Ib, 'PeakThresh', 0.01);

match_idx = [];
match_x1 = [];
match_x2 = [];

for i = framestart+1 : frameend
	% frame reading and sift detection
	current_frame = imread([imagepath,'/image',num2str(i),'.bmp']);
	Ia = single(rgb2gray(current_frame)) / 255;
	[fa, da] = vl_sift(Ia, 'PeakThresh', 0.01);
	
	% sift matching, select matches with high scores
	[matches, scores] = vl_ubcmatch(da, db);
	matches = matches(:, scores > median(scores));
	ma = fa(1:2, matches(1,:));
	mb = fb(1:2, matches(2,:));
	
	% RANSAC re-selection
	[inlier_idx, best_error] = sift_ransac(current_frame, base_frame, ma', mb', 1, 50);
	if length(inlier_idx)>90
		inlier_idx = inlier_idx(1:90);
	end
	
	% show the matching result
	imshow([base_frame, current_frame]);
	line([mb(1,inlier_idx); ma(1,inlier_idx)+w],[mb(2,inlier_idx); ma(2,inlier_idx)],'Color','b');
    %pause(0.1);
	
	% prepare for next matching
	base_frame = current_frame;
	fb = fa;
	db = da;
	
	% save the matchings and display parameters
	match_idx = [match_idx; (i-1).*ones(length(inlier_idx),1)];
	match_x1 = [match_x1; mb(:,inlier_idx)'];
	match_x2 = [match_x2; ma(:,inlier_idx)'];
	fprintf('num inliers: %d, error: %d, frame %d\n', numel(inlier_idx), best_error, i);
end

% restore warning state
%warning(s);
warning on;
	
	
	
	
	
	
	