package sss.ui

import akka.actor.Actor
import akka.actor.Props
import akka.actor.ActorRef
import protocol._

object CoordinatingActor extends DefaultActorSystem {

  lazy val coordinator = actorSystem.actorOf(Props(classOf[CoordinatingActor]), "rugbyGameEventsink")

}

case class Register(gameId: String)
case class UnRegister(gameId: String)

class CoordinatingActor extends Actor {

  private def manageRegister(registeredParties: Map[String, Set[ActorRef]]): Receive = {

    case Register(gameId) => {
      println(s"Adding to gamid ${gameId}")
      val newRegistrant = sender()
      val currentRegistered = registeredParties(gameId)
      context.become(manageRegister(registeredParties + (gameId -> (currentRegistered + newRegistrant))))
    }

    case UnRegister(gameId) => {
      println(s"Removing gamid ${gameId} registrant ")
      val registrant = sender()
      val newRegistrantList = registeredParties(gameId).filterNot(_ == registrant)
      context.become(manageRegister(registeredParties + (gameId -> (newRegistrantList))))
    }

    case e: Event => {
      println(s"We got en event -> $e")
      registeredParties(e.gameId).foreach(_ ! e)
    }

    case str: String => println(s"We got a string -> $str")
  }

  def receive = manageRegister(Map().withDefaultValue(Set()))

}