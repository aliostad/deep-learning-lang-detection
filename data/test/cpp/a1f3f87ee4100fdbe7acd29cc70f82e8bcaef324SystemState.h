#ifndef SYSTEM_STATE_H
#define SYSTEM_STATE_H

#include <mutex>
#include "models/SystemStateModel.h"


class SystemState {
public:
	SystemState(SystemStateModel model) : m_model(model) {};
	~SystemState() {};

	void setData(SystemStateModel model);
	void getData(SystemStateModel& model);

	void setGPSModel(GPSModel gpsModel);
	void setWindsensorModel(WindsensorModel windsensorModel);
	void setCompassModel(CompassModel compassModel);
	void setAnalogArduinoModel(AnalogArduinoModel arduinoModel);
	void setRudder(int value);
	void setSail(int value);

private:
	std::mutex m_mutex; // mutex for critical section
	SystemStateModel m_model;
};

#endif
