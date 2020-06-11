package com.github.madoc.process_actor

import akka.actor.ActorRef
import akka.util.ByteString
import com.github.madoc.process_actor.ProcessServiceProtocol.Request.ProcessOutputAcknowledged
import com.github.madoc.process_actor.ProcessServiceProtocol.Response._
import com.github.madoc.process_actor.ProcessServiceProtocol.Utility.ProcessOutputType.OutputRawBytes
import com.github.madoc.process_actor.ProcessServiceProtocol.Utility.{ProcessStartingOptions, ProcessStreamType}

import scala.concurrent.duration.Duration

object ProcessServiceProtocol {
  sealed trait Request
  object Request {
    case class CloseProcessInput(processID:Long, callerContext:Any) extends Request {
      def responseForClosed:ProcessInputClosed = ProcessInputClosed(processID, callerContext)
    }
    object EnterShutdownMode extends Request
    case class ProcessOutputAcknowledged(processID:Long, streamType:ProcessStreamType) extends Request
    case class StartProcess(
      spec:ProcessSpec,
      processOutputRecipient:ActorRef,
      callerContext:Any,
      options:ProcessStartingOptions=ProcessStartingOptions()
    ) extends Request {
      def responseForShutdownMode:ProcessStartPreventedByShutdownMode = ProcessStartPreventedByShutdownMode(callerContext)
      def responseForStarted(processID:Long):ProcessStarted = ProcessStarted(processID, callerContext)
      def responseForTimeout:ProcessStartTimeout = ProcessStartTimeout(callerContext)
    }
    case class TerminateProcess(processID:Long, forcibly:Boolean=false) extends Request
    case class WriteToProcess(processID:Long, bytes:ByteString, callerContext:Any) extends Request {
      def responseForAcknowledged:WriteToProcessAcknowledged = WriteToProcessAcknowledged(processID, callerContext)
    }
  }

  sealed trait Response
  object Response {
    case class ProcessExited(exitValue:Int, processID:Long, callerContext:Any) extends Response
    case class ProcessInputClosed(processID:Long, callerContext:Any) extends Response
    case class ProcessOutput(
      bytes:ByteString,
      streamType:ProcessStreamType,
      processID:Long,
      ackRequired:Boolean,
      callerContext:Any
    ) extends Response {
      def responseForAcknowledged:ProcessOutputAcknowledged = ProcessOutputAcknowledged(processID, streamType)
    }
    case class ProcessOutputLine(
      line:String,
      streamType:ProcessStreamType,
      processID:Long,
      ackRequired:Boolean,
      callerContext:Any
    ) extends Response {
      def responseForAcknowledged:ProcessOutputAcknowledged = ProcessOutputAcknowledged(processID, streamType)
    }
    case class ProcessOutputStringFragment(
      stringFragment:String,
      outputType:ProcessStreamType,
      processID:Long,
      ackRequired:Boolean,
      callerContext:Any
    ) extends Response {
      def responseForAcknowledged:ProcessOutputAcknowledged = ProcessOutputAcknowledged(processID, outputType)
    }
    case class ProcessStarted(processID:Long, callerContext:Any) extends Response
    case class ProcessStartPreventedByShutdownMode(callerContext:Any) extends Response
    case class ProcessStartTimeout(callerContext:Any) extends Response
    case class WriteToProcessAcknowledged(processID:Long, callerContext:Any) extends Response
  }

  object Utility {
    sealed trait ProcessOutputType
    object ProcessOutputType {
      object OutputRawBytes extends ProcessOutputType
      object OutputStringFragments extends ProcessOutputType
      object OutputLines extends ProcessOutputType
    }

    sealed trait ProcessStreamType
    object ProcessStreamType {
      object StandardErrorType extends ProcessStreamType {override def toString="stderr"}
      object StandardOutputType extends ProcessStreamType {override def toString="stdout"}
    }

    case class ProcessStartingOptions(
      timeout:Duration=Duration.Inf,
      priority:Int=0,
      processOutputAckRequired:Boolean=true,
      processOutputType:ProcessOutputType = OutputRawBytes
    )
  }
}
