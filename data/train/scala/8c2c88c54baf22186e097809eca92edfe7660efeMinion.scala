package akka

import akka.actor.Actor
import akka.actor.ActorRef
import akka.actor.Props
import akka.pattern.ask

import model.RobotPart

class Minion(mansionName: String, nightlyCycle: Int, theDroidskyRobotFactoryDump: ActorRef) extends Actor {
  
  var partsRequester: ActorRef = null
  var fetchedParts = List[RobotPart]()
  var responsesReceived = 0
  var responsesExpected = 0

  override def receive: Receive = {
    case FetchPartsFromDump(numberOfPartsToFetch) =>
      partsRequester = sender
      responsesExpected = numberOfPartsToFetch
      for (i <- 1 to numberOfPartsToFetch) {
        theDroidskyRobotFactoryDump ! TakePart(nightlyCycle)
      }
    case FetchedRobotPart(theRobotPart) =>
      responsesReceived+= 1
      fetchedParts = fetchedParts ++ List(theRobotPart)
      
      if (responsesReceived == responsesExpected) {
        partsRequester ! FetchedRobotParts(fetchedParts, nightlyCycle)
      }
    case PartUnavailableGenerationComplete =>
      responsesReceived+= 1
      
      if (responsesReceived == responsesExpected) {
        partsRequester ! FetchedRobotParts(fetchedParts, nightlyCycle)
      }
      
    case PartsCurrentlyUnavailable =>
      println("Waiting For Part")
      wait(5)
      theDroidskyRobotFactoryDump ! TakePart(nightlyCycle)
    case DumpClosedForTheNight() =>
      responsesReceived+= 1
      
      if (responsesReceived == responsesExpected) {
        partsRequester ! FetchedRobotParts(fetchedParts, nightlyCycle)
      }
  }
}
object Minion {
  def props(mansionName: String, nightlyCycle: Int, theDroidskyRobotFactoryDump: ActorRef): Props = Props(new Minion(mansionName, nightlyCycle, theDroidskyRobotFactoryDump))
}

case class FetchPartsFromDump(numberOfPartsToFetch: Integer)