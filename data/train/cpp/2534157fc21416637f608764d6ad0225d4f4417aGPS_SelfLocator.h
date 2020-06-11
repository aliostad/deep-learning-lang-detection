/**
* @file GPS_SelfLocator.h
*
* @author <a href="mailto:goehring@informatik.hu-berlin.de">Daniel Goehring</a>
* Declaration of class GPS_SelfLocator
*/

#ifndef __GPS_SelfLocator_h_
#define __GPS_SelfLocator_h_

#include <ModuleFramework/Module.h>

// debug
#include "Tools/Debug/DebugRequest.h"
#include "Tools/Debug/DebugDrawings.h"

// Representations
#include "Representations/Infrastructure/GPSData.h"

#include "Representations/Modeling/PlayerInfo.h"
#include "Representations/Modeling/RobotPose.h"
#include "Representations/Modeling/OdometryData.h"


//////////////////// BEGIN MODULE INTERFACE DECLARATION ////////////////////

BEGIN_DECLARE_MODULE(GPS_SelfLocator)
  REQUIRE(GPSData)
  REQUIRE(OdometryData)
  REQUIRE(PlayerInfo)

  PROVIDE(RobotPose)
END_DECLARE_MODULE(GPS_SelfLocator)

//////////////////// END MODULE INTERFACE DECLARATION //////////////////////

class GPS_SelfLocator : public GPS_SelfLocatorBase
{
public:

  GPS_SelfLocator();
  ~GPS_SelfLocator(){}


  /** executes the module */
  void execute();

private:
  void drawGPSData();
  Pose2D calculateFromGPS(const GPSData& gps) const;

  Pose2D gpsRobotPose;
  Pose2D lastRobotOdometry;
};

#endif //__GPS_SelfLocator_h_
