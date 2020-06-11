#pragma once

#include <math/Types.h>
#include <util/OrocosHelperFunctions.h>

namespace aa
{
namespace data
{
namespace obstacle
{
namespace util
{
/**
  * definition of all available Sensors
  **/

enum SensorModel {
	SENSOR_MODEL_UNKNOWN 	= 0,
	SENSOR_MODEL_ALASCA  	= 1,
	SENSOR_MODEL_LUX	= 2,
	SENSOR_MODEL_VELODYNE 	= 3,
	SENSOR_MODEL_CAMERA	= 4,
	SENSOR_MODEL_TRW_FRONT	= 5,
	SENSOR_MODEL_ULTRASONIC = 6,
	SENSOR_MODEL_TRW_REAR   = 7,
	SENSOR_MODEL_TRW_LEFT   = 8,
	SENSOR_MODEL_TRW_RIGHT  = 9,
	SENSOR_MODEL_HELLA      = 10,
	SENSOR_MODEL_SMS        = 11

};

std::string sensorModelString(SensorModel model);

}
}
}
}
std::ostream & operator<< (std::ostream & lhs, const aa::data::obstacle::util::SensorModel & ob);
RTT::Logger & operator<<(RTT::Logger & lhs , const aa::data::obstacle::util::SensorModel & ob);


