package readwriteactor

import akka.actor.Actor
import readwriteactor.ReadWriteActorState.{ReadMsg, WriteMsg, WriteReadMsg}
import readwriteactor.Types.{Read, Write, WriteRead}

import scala.concurrent.Promise

class ReadWriteActorState[S](var state: S) extends Actor {

  override def receive: Receive = {
    case writeMsg: WriteMsg[S] =>
      state = writeMsg.write(state)
      writeMsg.newStatePromise.success(state)

    case writeReadMsg: WriteReadMsg[S, Any] =>
      writeReadMsg.writeRead(state) match {
        case (newState, returnValue) =>
          state = newState
          writeReadMsg.readPromise.success(returnValue)
      }

    case readMsg: ReadMsg[S, Any] =>
      val value = readMsg.read(state)
      readMsg.readPromise.success(value)
  }
}

object ReadWriteActorState {
  case class WriteMsg[S](write: Write[S], newStatePromise: Promise[S])
  case class WriteReadMsg[S, R](writeRead: WriteRead[S, R], readPromise: Promise[R])
  case class ReadMsg[S, U](read: Read[S, U], readPromise: Promise[U])
}
