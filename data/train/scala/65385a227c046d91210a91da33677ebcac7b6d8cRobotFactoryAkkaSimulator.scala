package akka

import akka.actor.ActorSystem
import akka.actor.ActorRef
import akka.actor.Props

object RobotFactoryAkkaSimulator extends App {
  val system = ActorSystem("the-actor-system")
  val DroidskyRobotFactoryDump: ActorRef = system.actorOf(Props(new DroidskyRobotFactoryDump(20)))
  val theFrankensteelMansion = RobotFactoryAkkaSimulator.system.actorOf(Props(new Mansion("Frankensteel", DroidskyRobotFactoryDump)))
  val theFrankenstealMansion = RobotFactoryAkkaSimulator.system.actorOf(Props(new Mansion("Frankensteal", DroidskyRobotFactoryDump)))

  private var currentNightlyCycle = 0


  while (currentNightlyCycle < 100) {
    currentNightlyCycle += 1
    println("Nightly Cycle: " + currentNightlyCycle)
    DroidskyRobotFactoryDump ! StartNightlyCycle(currentNightlyCycle)
    theFrankensteelMansion ! StartNightlyCycle(currentNightlyCycle)
    theFrankenstealMansion ! StartNightlyCycle(currentNightlyCycle)
    java.lang.Thread.sleep(100)
  }
  
  theFrankensteelMansion ! ReportRobotStatistics
  theFrankenstealMansion ! ReportRobotStatistics
  
  system.shutdown()

}