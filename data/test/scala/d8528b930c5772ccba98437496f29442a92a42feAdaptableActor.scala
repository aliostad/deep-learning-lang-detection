package example.akka

import akka.actor.actorRef2Scala

case object BecomeChatty
case object BecomeNormal

/**
 * Actors are useful to manage state. This example actor manages the
 * can change its behavior by adapting another receive function.
 */
class AdaptableActor extends ActorBase {

  // Manage the actors lifecycle-hooks to change their
  // behavior when distinct events occur. 
  override def preStart = {
    context.parent ! "I'am going to start now.s"
  }

  def receive = {
    case BecomeChatty => context.become(chatty)
    case BecomeNormal => context.unbecome
    case _ =>
  }

  // You can replace the default behavior from the receive function
  // with other custom functions within an actor. 
  def chatty: Receive = {
    case _ => sender ! "Hey" + sender.path.name + "! How are you?"
  }

}