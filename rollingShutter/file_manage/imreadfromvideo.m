function imreadfromvideo(videopath, imagepath,num)
% read out images from video

obj = VideoReader(videopath);  %'data/videosample.mp4'   'data/11_converted.mp4' 
framenum = obj.NumberofFrames;
for idx = num: framenum
	img = read (obj,idx);  
	% sometimes the saved video is rotated by 90 degrees
	% img = imrotate(img, 90);
	imwrite(img, [imagepath, '/image', int2str(idx-num+1),'.bmp'],'bmp');

end
	
