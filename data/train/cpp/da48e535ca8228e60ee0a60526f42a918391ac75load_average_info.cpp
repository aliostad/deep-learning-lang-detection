#include "load_average_info.h"
#include <fstream>
#include <iostream>

using namespace std;


LoadAverageInfo get_load_average() {
  // TODO: implement me
	LoadAverageInfo load_average;

	//change to PROC ROOT before submitting
	ifstream loadavg_file(PROC_ROOT "/loadavg");

	if (!loadavg_file){
		cerr << "Unable to read from /proc/loadavg" << endl;
		return load_average;
	}

	loadavg_file
		>> load_average.one_min
		>> load_average.five_mins
		>> load_average.fifteen_mins;
	
	//close file before ending
	loadavg_file.close();
		
  return load_average;
}
