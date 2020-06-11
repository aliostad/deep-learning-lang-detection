#include "AMBeamlineSupport.h"

namespace AMBeamlineSupport{
	AMBeamlineControlAPI *beamlineControlAPI_ = 0;
	AMBeamlineControlAPI *beamlineControlAPI(){
		return beamlineControlAPI_;
	}
	void setBeamlineControlAPI(AMBeamlineControlAPI *beamlineControlAPI){
		beamlineControlAPI_ = beamlineControlAPI;
	}

	AMBeamlineControlSetAPI *beamlineControlSetAPI_ = 0;
	AMBeamlineControlSetAPI *beamlineControlSetAPI(){
		return beamlineControlSetAPI_;
	}
	void setBeamlineControlSetAPI(AMBeamlineControlSetAPI *beamlineControlSetAPI){
		beamlineControlSetAPI_ = beamlineControlSetAPI;
	}

	AMBeamlineDetectorAPI *beamlineDetectorAPI_ = 0;
	AMBeamlineDetectorAPI *beamlineDetectorAPI(){
		return beamlineDetectorAPI_;
	}
	void setBeamineDetectorAPI(AMBeamlineDetectorAPI *beamlineDetectorAPI){
		beamlineDetectorAPI_ = beamlineDetectorAPI;
	}

	AMBeamlineDetectorSetAPI *beamlineDetectorSetAPI_ = 0;
	AMBeamlineDetectorSetAPI *beamlineDetectorSetAPI(){
		return beamlineDetectorSetAPI_;
	}
	void setBeamlineDetectorSetAPI(AMBeamlineDetectorSetAPI *beamlineDetectorSetAPI){
		beamlineDetectorSetAPI_ = beamlineDetectorSetAPI;
	}

	AMBeamlineSynchronizedDwellTimeAPI *beamlineSynchronizedDwellTimeAPI_ = 0;
	AMBeamlineSynchronizedDwellTimeAPI *beamlineSynchronizedDwellTimeAPI(){
		return beamlineSynchronizedDwellTimeAPI_;
	}
	void setBeamlineSynchronizedDwellTimeAPI(AMBeamlineSynchronizedDwellTimeAPI *beamlineSynchronizedDwellTimeAPI){
		beamlineSynchronizedDwellTimeAPI_ = beamlineSynchronizedDwellTimeAPI;
	}
}
