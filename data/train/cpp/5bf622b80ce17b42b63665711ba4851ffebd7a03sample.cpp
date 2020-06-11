//
//  sample.h
//  Moc
//
//  Created by Wei Li on 6/4/15.
//

#ifndef Moc_sample_h
#define Moc_sample_h

#include "camera_calibration.h"
#include "vicon_tracker.h"
#include "freenect.h"
#include "fusion.h"
#include "sample_fusion.h"
#include "sample_cl.h"
#include "sample_cali.h"


void main() {
	//sample_main_vicon_track();
	//sample_main_kinect();
	sample_main_calibrate_vicon_kinect();
	//sample_main_calibrate_kinect_kinect();
	//sample_main_calibrate_vicon_velodyne();
	//sample_main_cl();
	//sample_main_fusion();
	//sample_main_sync();
	getchar();
}
#endif
