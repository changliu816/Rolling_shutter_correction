Rolling Shutter Video Rectification 

Overall Description: 

1. To rectify the rolling shutter videos, we need the video file and also the gyroscope readings while the video is recorded.
  - The gyroscope file is recorded through Samsung camera shooted by Christoph Mertz
  - To preprocess the gyroscople script, delete the 2nd to the 12th row of log file such that Matlab can read the log file easier:
     '' Zoom:1.0x
	   ......
	   {Sensor name= ...}''
  - Put the gyroscope log file into folder:¡¡ data\shutter_correction_samples
  - Run "gyro_pre.m" and you can get two file - gyro.txt and td.txt 
  - Put the gyro.txt into its parent folder:  data\
      
2. In addition, we need to extract the framestamps of the video. The framestamps are extracted by a C++ implementation (source file "extract_framestamp.cpp") based on OpenCV. 
  - Attention! Only visual studio 2010 version can correctly extract the framestamp
  - Go to the folder: data\rolling
  - Run the "rolling.sln"
  - Specifically, revise the input and output folder address in cpp script
  - Revise the "frame_num" according to the number of images in folder: "data\images"
  
3. The parameters of the camera on different smartphones are different, so we need to estimate the parameters first (calibration step). 
  
4. Please run the "rolling_shutter_demo.m" script 
--------------------------------------------------------

Final accessment:

Implementation:
- Please run the "rolling_shutter_demo.m" 
- Check the output video named "rectify.avi" for retification
- Also, you can compare the retification frame by frame in "images folder, and steadyimages folder"
