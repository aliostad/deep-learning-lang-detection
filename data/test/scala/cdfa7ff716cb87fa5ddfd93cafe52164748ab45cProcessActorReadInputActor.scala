package com.github.madoc.process_actor

import java.io.InputStream

import akka.actor.{Actor, ActorRef, Props}
import akka.util.ByteString
import com.github.madoc.process_actor.ProcessServiceProtocol.Request.ProcessOutputAcknowledged
import com.github.madoc.process_actor.ProcessServiceProtocol.Response.ProcessOutput
import com.github.madoc.process_actor.ProcessServiceProtocol.Utility.{ProcessStartingOptions, ProcessStreamType}

import scala.concurrent.blocking

private object ProcessActorReadInputActor {
  def props(processActor:ActorRef, inputStream:InputStream, streamType:ProcessStreamType, processID:Long,
    options:ProcessStartingOptions, callerContext:Any) =
    Props(new ProcessActorReadInputActor(processActor, inputStream, streamType, processID, options, callerContext))
}
private class ProcessActorReadInputActor(processActor:ActorRef, inputStream:InputStream, streamType:ProcessStreamType,
  processID:Long, options:ProcessStartingOptions, callerContext:Any) extends Actor {
  private val buffer = new Array[Byte](1024)
  private var reachedEndOfFile = false
  private var waitingForAck = false

  override def preStart() {super.preStart(); self ! 'read_on}

  def receive = {
    case 'read_on ⇒
      blocking(inputStream read buffer) match { // TODO IOException?
        case -1 ⇒
          reachedEndOfFile = true
          if(!waitingForAck) context stop self
        case numberOfBytesRead ⇒
          processActor ! ProcessOutput(ByteString.fromArray(buffer, 0, numberOfBytesRead), streamType, processID,
            options processOutputAckRequired, callerContext)
          if(options.processOutputAckRequired) waitingForAck = true
          else self ! 'read_on
      }
    case _:ProcessOutputAcknowledged ⇒
      if(waitingForAck) {
        waitingForAck = false
        if(reachedEndOfFile) context stop self
        else self ! 'read_on
      }
  }
}
