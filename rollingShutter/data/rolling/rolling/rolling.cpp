#include "stdafx.h"
#include <iostream>
#include <fstream>
#include <opencv/cv.h>
#include <opencv/cxcore.h>
#include <opencv/highgui.h>

using namespace cv;
using namespace std;

int _tmain(int argc, _TCHAR* argv[])
{		
		int i;
		Mat img;
		//VideoCapture cap("videosample.mp4");
		VideoCapture cap("C:/Users/changliu816/Desktop/44.mp4");
		if(!cap.isOpened()) // check if we succeeded
			return -1;
		ofstream myfile;
		myfile.open("C:/Users/changliu816/Desktop/framestamps1.txt");
		//myfile.open("framestamps.txt");
		// specify the number of frames
		// the returned frame number of the "get" function in OpenCV is not always correct
		int frame_num = 414;
		for (i=0; i<frame_num; i++) {
			cap>>img;
			myfile << cap.get(CV_CAP_PROP_POS_MSEC) <<endl;
		}
		myfile.close();

        return 0;
}
