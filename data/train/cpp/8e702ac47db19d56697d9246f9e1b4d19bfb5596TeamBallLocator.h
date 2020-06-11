/**
* @file TeamBallLocator.h
*
* Declaration of class TeamBallLocator
*/

#ifndef __TeamBallLocator_h_
#define __TeamBallLocator_h_

#include <ModuleFramework/Module.h>

// Debug
#include "Tools/Debug/DebugRequest.h"
#include "Tools/Debug/DebugDrawings.h"

// Representations
#include "Representations/Modeling/TeamMessage.h"
#include "Representations/Modeling/RobotPose.h"
#include "Representations/Modeling/TeamBallModel.h"

BEGIN_DECLARE_MODULE(TeamBallLocator)
  REQUIRE(TeamMessage)
  REQUIRE(RobotPose)

  PROVIDE(TeamBallModel)
END_DECLARE_MODULE(TeamBallLocator)

class TeamBallLocator : protected TeamBallLocatorBase
{

public:
  TeamBallLocator();
  ~TeamBallLocator(){}

  virtual void execute();

private:
  std::map<unsigned int, TeamMessage::Data> msgData;
};

#endif //__TeamBallLocator_h_



