package readwriteactor

import akka.actor.{ActorRef, ActorSystem, Props}
import readwriteactor.ReadWriteActorState.{ReadMsg, WriteMsg, WriteReadMsg}
import readwriteactor.Types.{Read, Write, WriteRead}

import scala.concurrent.{Future, Promise}

class ReadWriteActor[S](private val rwActor: ActorRef) {

  def this(state: S)(implicit system: ActorSystem) = this(system.actorOf(Props(new ReadWriteActorState(state))))

  def read[R](read: Read[S, R]): Future[R] = {
    val readPromise = Promise[R]()
    rwActor ! ReadMsg(read, readPromise)
    readPromise.future
  }

  def write(write: Write[S]): Future[S] = {
    val newStatePromise = Promise[S]()
    rwActor ! WriteMsg(write, newStatePromise)
    newStatePromise.future
  }

  def writeRead[R](write: WriteRead[S, R]): Future[R] = {
    val readPromise = Promise[R]()
    rwActor ! WriteReadMsg(write, readPromise)
    readPromise.future
  }

}

