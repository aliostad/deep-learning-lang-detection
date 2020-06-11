package com.mediative.eigenflow.process

import java.util.Date

import akka.actor.SupervisorStrategy.Stop
import akka.actor.{ Actor, ActorRef, OneForOneStrategy, Props, SupervisorStrategy, Terminated }
import com.mediative.eigenflow.StagedProcess
import com.mediative.eigenflow.publisher.MessagingSystem

object ProcessSupervisor {
  def props(process: StagedProcess, date: Option[Date], processTypeId: String, stopSystem: Int => Unit)(implicit messagingSystem: MessagingSystem) =
    Props(new ProcessSupervisor(process, date, processTypeId, stopSystem))

  case object Done
  case object Failed
}

class ProcessSupervisor(val process: StagedProcess, val startDate: Option[Date], processTypeId: String, stopSystem: Int => Unit)(implicit val messagingSystem: MessagingSystem) extends Actor {
  private val processManager: ActorRef = context.actorOf(Props(new ProcessManager(process, startDate, processTypeId)))

  context.watch(processManager)

  override def supervisorStrategy: SupervisorStrategy = OneForOneStrategy() {
    case _ => Stop
  }

  override def receive: Receive = {
    case ProcessSupervisor.Done => stopSystem(0)
    case ProcessSupervisor.Failed | Terminated(`processManager`) =>
      stopSystem(1)
    case message => processManager.forward(message)
  }
}
