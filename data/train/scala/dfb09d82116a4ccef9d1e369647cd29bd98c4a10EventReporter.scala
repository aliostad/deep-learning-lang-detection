package org.kolokolov.plane

import akka.actor.{Actor, ActorRef}

/**
  * Created by kolokolov on 6/30/17.
  */
trait EventReporter {
  def manageListeners: Actor.Receive
  def sendEvent[T](event: T): Unit
}

object EventReporter {
  case class Register(listener: ActorRef)
  case class Unregister(listener: ActorRef)
}

trait ProductionEventReporter extends EventReporter {

  this: Actor =>

  import EventReporter._

  var listeners = Vector.empty[ActorRef]

  def manageListeners: Receive = {
    case Register(listener) => listeners = listeners :+ listener
    case Unregister(listener) => listeners = listeners.filterNot(_ == listener)
  }

  def sendEvent[T](event: T): Unit = {
    listeners.foreach(_ ! event)
  }
}
