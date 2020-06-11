package com.github.madoc.process_actor

import akka.actor.{Actor, ActorRef, Props, Terminated}
import com.github.madoc.process_actor.ProcessServiceProtocol.Request.{CloseProcessInput, ProcessOutputAcknowledged, TerminateProcess, WriteToProcess}
import com.github.madoc.process_actor.ProcessServiceProtocol.Response.{ProcessExited, ProcessOutput, ProcessStarted}
import com.github.madoc.process_actor.ProcessServiceProtocol.Utility.ProcessOutputType.{OutputLines, OutputStringFragments}
import com.github.madoc.process_actor.ProcessServiceProtocol.Utility.ProcessStartingOptions

private object ProcessActor {
  def props(parentService:ActorRef, processID:Long, processSpec:ProcessSpec, processOutputRecipient:ActorRef,
    callerContext:Any, options:ProcessStartingOptions):Props = Props(new ProcessActor(parentService, processID,
    processSpec, processOutputRecipient, callerContext, options))
}
private class ProcessActor(
  parentService:ActorRef,
  processID:Long,
  processSpec:ProcessSpec,
  processOutputRecipient:ActorRef,
  callerContext:Any,
  options:ProcessStartingOptions
) extends Actor {
  private var ackFromServiceRecipient = processOutputRecipient
  private var rawBytesOutputRecipient = processOutputRecipient
  private val workerActor =
    context.actorOf(ProcessActorWorkerActor.props(self, processID, processSpec, options, callerContext))

  private var activeChildren = Set(workerActor)

  override def preStart() {super.preStart(); self ! 'start_process; context watch workerActor}

  def receive:Receive = {
    case output:ProcessOutput ⇒ rawBytesOutputRecipient ! output
    case ack:ProcessOutputAcknowledged ⇒ workerActor.tell(ack, sender)
    case Terminated(child) ⇒
      activeChildren -= child
      if(activeChildren isEmpty) context stop self
    case request:TerminateProcess ⇒ workerActor.tell(request, sender)
    case (caller:ActorRef, request:WriteToProcess) ⇒ workerActor.tell(request, caller)
    case (caller:ActorRef, request:CloseProcessInput) ⇒ workerActor.tell(request, caller)
    case ('exited, exitValue:Int) ⇒ rawBytesOutputRecipient ! ProcessExited(exitValue, processID, callerContext)
    case ('from_service, ack:ProcessOutputAcknowledged) ⇒
      if(ackFromServiceRecipient != processOutputRecipient) ackFromServiceRecipient ! ack else self ! ack
    case 'start_process ⇒
      options.processOutputType match {
        case OutputLines ⇒
          val toLinesActor = context actorOf OutputToLinesActor.props(processOutputRecipient)
          val toStringActor = context actorOf OutputToStringActor.props(toLinesActor, self)
          rawBytesOutputRecipient = toStringActor
          ackFromServiceRecipient = toLinesActor
          activeChildren ++= Set(toLinesActor, toStringActor)
          context watch toLinesActor; context watch toStringActor
        case OutputStringFragments ⇒
          val toStringActor = context actorOf OutputToStringActor.props(processOutputRecipient, self)
          rawBytesOutputRecipient = toStringActor
          ackFromServiceRecipient = rawBytesOutputRecipient
          activeChildren += toStringActor
          context watch toStringActor
        case _ ⇒ ()
      }
      rawBytesOutputRecipient ! ProcessStarted(processID, callerContext)
  }
}
