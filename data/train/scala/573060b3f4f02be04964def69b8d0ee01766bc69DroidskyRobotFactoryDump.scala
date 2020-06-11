
package synchronization

import scala.collection.mutable.Queue
import scala.util.Random
import model.RobotPart

class DroidskyRobotFactoryDump(val initialNumberOfParts: Int) extends Thread {
  
  override def run() = {
    while (DroidskyRobotFactoryDump.nightlyCycle <= 100 && RobotFactorySimulator.nightlyCycleStarted(DroidskyRobotFactoryDump.nightlyCycle)) {
      println("Starting robot factory dump cycle " + DroidskyRobotFactoryDump.nightlyCycle + " with " + DroidskyRobotFactoryDump.availableRobotParts.size + " parts")  
      val numberOfPartsToAdd = DroidskyRobotFactoryDump.randomGenerator.nextInt(4) + 1
      DroidskyRobotFactoryDump.addBodyParts(numberOfPartsToAdd)
      println("Droidsky Robot Factory Dumped " + numberOfPartsToAdd + " Robot Parts for nightly cycle : " + DroidskyRobotFactoryDump.nightlyCycle)
      DroidskyRobotFactoryDump.nightlyCycle += 1
    }
  }

  DroidskyRobotFactoryDump.addBodyParts(initialNumberOfParts)
  DroidskyRobotFactoryDump.nightlyCycle = 1
  
}
object DroidskyRobotFactoryDump {
  var nightlyCycle = 0
  var completedPartGenerationForNightCycle = 0
  
  val availableRobotParts = Queue[RobotPart]()
  private val availableRobotPartsWriteLock: Object = new Object()
  private val randomGenerator = new Random()
  
  def retrieveBodyPart(duringNightlyCycle: Int) : RobotPart = {

    availableRobotPartsWriteLock.synchronized {
       if (availableRobotParts.size > 0) {
         availableRobotParts.dequeue()
       } else {
         while (duringNightlyCycle > DroidskyRobotFactoryDump.completedPartGenerationForNightCycle && DroidskyRobotFactoryDump.availableRobotParts.size == 0) {
           availableRobotPartsWriteLock.wait(5)
         }
         availableRobotPartsWriteLock.notifyAll()

         if (duringNightlyCycle >= DroidskyRobotFactoryDump.completedPartGenerationForNightCycle && availableRobotParts.size > 0) {
           availableRobotParts.dequeue()
         } else {
           null
         }
       }
     }
  }

  private def addBodyParts(numberOfPartsToAdd: Int) = {
    for (i <- 1 to numberOfPartsToAdd) {
      DroidskyRobotFactoryDump.addRobotPart()
    }  
    completedPartGenerationForNightCycle = nightlyCycle
  }
  
  private def addRobotPart() = {
    availableRobotPartsWriteLock.synchronized {
      availableRobotParts.enqueue(new RobotPart(randomGenerator.nextInt(9)))
      availableRobotPartsWriteLock.notifyAll()
    }
  }

}