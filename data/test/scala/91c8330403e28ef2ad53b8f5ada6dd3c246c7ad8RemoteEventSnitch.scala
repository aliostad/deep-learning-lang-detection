package com.ericsson.scala

import akka.actor.{ Actor, ActorLogging, ActorRef, Props }
import akka.event.LoggingReceive
import akka.remote.{ AssociationEvent, AssociationErrorEvent, AssociatedEvent, DisassociatedEvent }
import akka.actor.Address

/**
 * Companion object for the RemoteEventSnitch.
 */
object RemoteEventSnitch {

  /**
   * Creates an instance of the class.
   * @param serviceLocator The actor reference to the ServiceLocator instance
   */
  def props(): Props = {
    Props(new RemoteEventSnitch())
  }
}

/**
 * Listens to remoting events such as association/disassociation events in order to determine the liveness of a remote actor system.
 * Should a terminal failure event be received the address for the remote system is reported to the ServiceLocator in order to suspect all actor references at that remote location.
 * @constructor Create a new instance
 * @param serviceLocator The actor reference to the ServiceLocator instance
 * @author Peter Nerg (epknerg)
 */
class RemoteEventSnitch() extends Actor with ActorLogging {

  /**
   * Used to solve - artf506620 : Stopping a SLR generates lots of logging (HT57186)<br>
   * Store address to suspected location in order to not log the same event twice if the location already is suspected
   */
  private[this] val suspectedAddresses = scala.collection.mutable.Set[Address]()

  /** The receiver method of the actor. */
  override def receive = LoggingReceive {
    case event: AssociatedEvent =>
      manageAssociatedEvent(event)
    case event: DisassociatedEvent =>
      manageDisassociatedEvent(event)
    case event: AssociationErrorEvent =>
      manageAssociationErrorEvent(event)
    case msg: Any => log.warning("Received unknown message: {}", msg)
  }

  private def manageAssociatedEvent(event: AssociationEvent) {
    val address = event.getRemoteAddress
    suspectedAddresses.remove(address)
    if (event.inbound) {
      log.info("Got an AssociatedEvent from address [{}]", address)
    } else {
      log.info("Got an AssociatedEvent to address [{}]", address)
    }
  }

  private def manageDisassociatedEvent(event: AssociationEvent) {
    val address = event.getRemoteAddress
    if (!suspectedAddresses.contains(address)) {
      if (event.inbound) {
        log.info("Got a DisassociatedEvent from address [{}]", address)
      } else {
        log.info("Got a DisassociatedEvent to address [{}]", address)
      }
    }
  }

  private def manageAssociationErrorEvent(event: AssociationEvent) {
    val address = event.getRemoteAddress
    if (!suspectedAddresses.contains(address)) {
      if (event.inbound) {
        log.info("Lost inbound connection from [{}], most likely due to a remote shutdown", address)
      } else {
        log.warning("Lost outbound connection to address [{}]", address)
      }
    }
  }

}