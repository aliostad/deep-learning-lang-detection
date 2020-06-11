package com.github.madoc.process_actor

import java.io.OutputStream

import akka.actor.{Actor, ActorRef, Props}
import com.github.madoc.process_actor.ProcessServiceProtocol.Request.{CloseProcessInput, WriteToProcess}

import scala.concurrent.blocking

private object ProcessActorWriteToProcessActor {
  def props(processActor:ActorRef, processID:Long, outputStream:OutputStream) =
    Props(new ProcessActorWriteToProcessActor(processActor, processID, outputStream))
}
private class ProcessActorWriteToProcessActor(processActor:ActorRef, processID:Long, outputStream:OutputStream)
extends Actor {
  def receive = {
    case request:CloseProcessInput ⇒ outputStream.close(); sender ! request.responseForClosed
    case request@WriteToProcess(_, bytes, _) ⇒
      blocking {outputStream.write(bytes toArray); outputStream.flush()}
      sender ! request.responseForAcknowledged
    case 'exit ⇒ context stop self
  }
}
