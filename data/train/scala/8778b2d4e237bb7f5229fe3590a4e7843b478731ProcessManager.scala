package tanukkii.backpressured.processmanager.example

import akka.actor.{PoisonPill, Props, ActorLogging, Actor}
import scala.concurrent.duration._

class ProcessManager extends Actor with ActorLogging {
  import context.dispatcher
  import ProcessManager._

  def receive: Receive = {
    case cmd: ProcessCommand =>
      // execute long running process
      context.system.scheduler.scheduleOnce(1 seconds, sender(), ProcessCommandResponse(cmd.id, cmd.payload))
      // After process is executed, stop the process.
      context.system.scheduler.scheduleOnce(1 seconds, self, PoisonPill)
  }
}

object ProcessManager {
  case class ProcessCommand(id: CommandRequestId, payload: String)
  case class ProcessCommandResponse(id: CommandRequestId, payload: String)

  def props = Props(new ProcessManager)
}