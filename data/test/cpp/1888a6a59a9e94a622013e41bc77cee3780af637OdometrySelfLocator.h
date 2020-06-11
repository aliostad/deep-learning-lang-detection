/**
* @file OdometrySelfLocator.h
*
* @author <a href="mailto:mellmann@informatik.hu-berlin.de">Heinrich Mellmann</a>
* Declaration of class OdometrySelfLocator
*/

#ifndef __OdometrySelfLocator_h_
#define __OdometrySelfLocator_h_

#include <ModuleFramework/Module.h>

// Debug
#include "Tools/Debug/DebugRequest.h"
#include "Tools/Debug/DebugDrawings.h"

// Representations
#include "Representations/Modeling/OdometryData.h"
#include "Representations/Modeling/RobotPose.h"

//////////////////// BEGIN MODULE INTERFACE DECLARATION ////////////////////

BEGIN_DECLARE_MODULE(OdometrySelfLocator)
  REQUIRE(OdometryData)
  PROVIDE(RobotPose)
END_DECLARE_MODULE(OdometrySelfLocator)

//////////////////// END MODULE INTERFACE DECLARATION //////////////////////

class OdometrySelfLocator : public OdometrySelfLocatorBase
{
public:

  OdometrySelfLocator();
  ~OdometrySelfLocator(){}


  /** executes the module */
  void execute();

private:
  OdometryData lastRobotOdometry;
};

#endif //__OdometrySelfLocator_h_
