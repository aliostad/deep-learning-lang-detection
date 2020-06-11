package com.kodekutters.ripple.core

import akka.actor.{ActorRef, Actor}
import messages._
import scala.collection.mutable

/**
 * manages the registration and closing of handlers,
 * a handler is an actor that deals with the server responses.
 */
trait HandlersManager {
  this: Actor =>

  // the list of response handlers
  val handlerList = new mutable.HashSet[ActorRef]()

  protected def manageHandlers: Receive = {

    case Register(handler) => handlerList += handler

    case DeRegister(handler) => handlerList -= handler

    case CloseAll => handlerList.foreach(handler => handler forward CloseHandler)

    case Close(handler) => handler forward CloseHandler

  }

}