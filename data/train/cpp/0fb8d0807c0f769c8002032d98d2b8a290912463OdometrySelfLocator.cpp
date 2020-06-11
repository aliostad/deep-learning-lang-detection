/**
* @file OdometrySelfLocator.h
*
* @author <a href="mailto:mellmann@informatik.hu-berlin.de">Heinrich Mellmann</a>
* Implementation of class OdometrySelfLocator
*/

#include "OdometrySelfLocator.h"

OdometrySelfLocator::OdometrySelfLocator()
{
  DEBUG_REQUEST_REGISTER("OdometrySelfLocator:draw_position","draw robot's position (self locator)", false);
  DEBUG_REQUEST_REGISTER("OdometrySelfLocator:reset","reset the robot's position", false);
}


void OdometrySelfLocator::execute()
{
  getRobotPose() += getOdometryData() - lastRobotOdometry;
  lastRobotOdometry = getOdometryData();

  DEBUG_REQUEST("OdometrySelfLocator:draw_position",
    FIELD_DRAWING_CONTEXT;
    PEN("0000FF", 20);
    CIRCLE(getRobotPose().translation.x, getRobotPose().translation.y, 150);
    ARROW(getRobotPose().translation.x,  getRobotPose().translation.y, 
          getRobotPose().translation.x + 50*cos(getRobotPose().rotation), 
          getRobotPose().translation.y + 50*sin(getRobotPose().rotation));
  );
  DEBUG_REQUEST("OdometrySelfLocator:reset",
    getRobotPose().translation.x = 0;
    getRobotPose().translation.y = 0;
    getRobotPose().rotation = 0;
  );
}//end execute

