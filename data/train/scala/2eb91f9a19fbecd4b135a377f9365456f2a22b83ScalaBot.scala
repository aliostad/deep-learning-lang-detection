package infrastructure

import robocode._

class ScalaBot extends AdvancedRobot {
  var radarDirection: Int = -1
  
  override def run() {
    //turnLeft(getHeading())
    setTurnRadarRight(360)
    while(true){
      execute
      while(getRadarTurnRemaining > 0) execute
    }
  }
  
  override def onScannedRobot(e: ScannedRobotEvent) ={
    setTurnRadarRight(0)
    System.out.println("Radar: " + getRadarHeading() + " e.bearing " + e.getBearing() + " my heading: " + getHeading())
    centerRadarOnTarget(e)
    System.out.println("Radar: " + getRadarHeading() + " e.bearing " + e.getBearing() + " my heading: " + getHeading())
    /*System.out.println("Scanned robot " + e.getName)
    // if it is my target: 
    if(prevTarg.name == "" || e.getDistance < prevTarg.distance || e.getName == prevTarg.name){
      if(prevTarg.name != e.getName){
        centerRadarOnTarget(e)
      }asdf
      prevTarg.update(e)
      //radarDirection = radarDirection * -1
      //setTurnRadarRight(360 * radarDirection)
    }*/
  }
  
  def centerRadarOnTarget(e: ScannedRobotEvent) {
      //if(e.getBearing > 0) setTurnRadarRight(e.getBearing - getRadarHeading)
      //else setTurnRadarLeft(e.getBearing - )
    val oldNum = (getHeading + e.getBearing - getRadarHeading)
    val newNum = if (oldNum > 180.0) oldNum - 360
      else if (oldNum < -180.0) oldNum + 360
      else if(oldNum < 0.0001 && oldNum > -0.0001) 0
      else oldNum
    System.out.println("Turning right: " + newNum)
    setTurnRadarRight(newNum)
    execute
    
  }
} 


object prevTarg{
  var name: String = ""
  var bearing: Double = 0.0
  var heading: Double = 0.0
  var velocity: Double = 0.0
  var distance: Double = 0.0
  def update(r: ScannedRobotEvent){
    name = r.getName
    bearing = r.getBearing
    heading = r.getHeading
    velocity = r.getVelocity
    distance = r.getDistance
  }
}