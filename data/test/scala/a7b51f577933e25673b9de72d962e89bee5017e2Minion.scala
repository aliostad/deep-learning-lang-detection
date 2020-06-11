package synchronization

import scala.util.Random
import scala.collection.immutable.List
import model.RobotPart

class Minion {

  def retrievePartsFromDump(forNightlyCycle: Int) : List[RobotPart] = {
    val numberOfPartsToRetrieve = Minion.randomPartCountGenerator.nextInt(4) + 1
    retrievePartsFromDump(forNightlyCycle, List[RobotPart](), numberOfPartsToRetrieve)
  }
  
  private def retrievePartsFromDump(forNightlyCycle: Int, partsRetrieved : List[RobotPart], numberOfPartsToRetrieve : Int) : List[RobotPart] = {
    if (partsRetrieved.size >= numberOfPartsToRetrieve) {
      partsRetrieved
    } else {
      val bodyPart = DroidskyRobotFactoryDump.retrieveBodyPart(forNightlyCycle)
      
      if (bodyPart != null) {
        retrievePartsFromDump(forNightlyCycle, partsRetrieved ++ List(bodyPart), numberOfPartsToRetrieve)
      } else {
        partsRetrieved
      }
    }
  }
}
object Minion {
  private val randomPartCountGenerator = new Random()
  
}