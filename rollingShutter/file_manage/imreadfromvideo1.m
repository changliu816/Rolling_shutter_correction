function imreadfromvideo1(videopath, imagepath,filepath)


fid = fopen(filepath);
timestamp = fscanf(fid,'%f');
timestamp = timestamp./1000; % convert unit from 'msec' to 'sec'
%timegap = diff(timestamp);
fclose(fid);

% read out images from video
%obj = VideoReader(videopath);  %'data/videosample.mp4'   'data/11_converted.mp4' 

for i=1:length(timestamp)
    obj = VideoReader(videopath,'CurrentTime',timestamp(i)); 
    img = readFrame(obj);
    imwrite(img, [imagepath, '/image', int2str(i),'.bmp'],'bmp');
end
%obj = VideoReader(videopath); 
% framenum = obj.NumberofFrames;
% for idx = 1: framenum
% 	img = read (obj,idx);  
% 	% sometimes the saved video is rotated by 90 degrees
% 	% img = imrotate(img, 90);
% 	imwrite(img, [imagepath, '/image', int2str(idx),'.bmp'],'bmp');
% 
% end
	
