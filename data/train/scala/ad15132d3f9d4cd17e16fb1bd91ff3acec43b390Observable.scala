package org.citysimulator.core.message

import akka.actor.ActorRef

/**
 * Defines all the messages that the actors must manage in order to implement the observer pattern
 */
object Observable {

  /**
   * The message inform the actor that another actor is interested in events produced by this reference
   *
   * @param listener [[ActorRef]] of the listener actor
   */
  case class RegisterListener(listener: ActorRef)

  /**
   * The message inform the actor that an actor is no more interested in events produced by this reference
   *
   * @param listener [[ActorRef]] of the listener actor
   */
  case class UnregisterListener(listener: ActorRef)
}