#ifndef AMBEAMLINESUPPORT_H
#define AMBEAMLINESUPPORT_H

#include "beamline/AMBeamlineControlAPI.h"
#include "beamline/AMBeamlineControlSetAPI.h"
#include "beamline/AMBeamlineDetectorAPI.h"
#include "beamline/AMBeamlineDetectorSetAPI.h"
#include "beamline/AMBeamlineSynchronizedDwellTimeAPI.h"

namespace AMBeamlineSupport
{
	extern AMBeamlineControlAPI *beamlineControlAPI_;
	AMBeamlineControlAPI *beamlineControlAPI();
	void setBeamlineControlAPI(AMBeamlineControlAPI *beamlineControlAPI);

	extern AMBeamlineControlSetAPI *beamlineControlSetAPI_;
	AMBeamlineControlSetAPI *beamlineControlSetAPI();
	void setBeamlineControlSetAPI(AMBeamlineControlSetAPI *beamlineControlSetAPI);

	extern AMBeamlineDetectorAPI *beamlineDetectorAPI_;
	AMBeamlineDetectorAPI *beamlineDetectorAPI();
	void setBeamineDetectorAPI(AMBeamlineDetectorAPI *beamlineDetectorAPI);

	extern AMBeamlineDetectorSetAPI *beamlineDetectorSetAPI_;
	AMBeamlineDetectorSetAPI *beamlineDetectorSetAPI();
	void setBeamlineDetectorSetAPI(AMBeamlineDetectorSetAPI *beamlineDetectorSetAPI);

	extern AMBeamlineSynchronizedDwellTimeAPI *beamlineSynchronizedDwellTimeAPI_;
	AMBeamlineSynchronizedDwellTimeAPI *beamlineSynchronizedDwellTimeAPI();
	void setBeamlineSynchronizedDwellTimeAPI(AMBeamlineSynchronizedDwellTimeAPI *beamlineSynchronizedDwellTimeAPI);
}

#endif // AMBEAMLINESUPPORT_H
