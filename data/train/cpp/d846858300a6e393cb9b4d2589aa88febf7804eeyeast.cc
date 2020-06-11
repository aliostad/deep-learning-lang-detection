#include "yeast_internalization_model.h"
//#include "yeast_reorientation_model.h"
#include "cell.h"
#include <cmath>
#include <cstdio>
#include <iostream>
using namespace std;


//#ifdef INTERNALIZATION
	#define YeastModel YeastInternalizationModel
//#elif REORIENTATION
//	#define YeastModel YeastReorientationModel
//#else
//	#define YeastModel YeastReorientationModel
//#endif


int main(int argc, char* argv[]){
	if(argc < 2){
		return 1;
	}

	YeastModel model(argc, argv);
	model.ShowOption();

	int checkIntervalStep = 60 * int( ceil( model.output_interval / model.dt ) );
	while (model.current_time < model.tot_time){
		printf("\n# time : %d\n", model.current_time);
		model.DisplayCell();
		model.EvolveSteps(checkIntervalStep);
		model.current_time += model.output_interval;
	}
	printf("\n# time : %d\n", model.current_time);
	model.DisplayCell();

	return 0;
}
