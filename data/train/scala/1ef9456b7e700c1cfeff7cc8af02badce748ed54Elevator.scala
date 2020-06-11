package olim7t

import akka.actor.{Actor, ActorLogging}

import Protocol._

class Elevator extends Actor with ActorLogging with ElevatorController {
  def receive = {
    case event: Event =>
      log.debug(s"[${event}] - state before: ${dumpState}")
      handle(event)
      log.debug(s"   state after:  ${dumpState}")
      sender ! EventAck

    case NextCommand =>
      log.debug(s"[nextCommand] - state before: ${dumpState}")
      val command = nextCommand
      log.debug(s"   returning ${command} - state after: ${dumpState}")
      sender ! command
  }
}
