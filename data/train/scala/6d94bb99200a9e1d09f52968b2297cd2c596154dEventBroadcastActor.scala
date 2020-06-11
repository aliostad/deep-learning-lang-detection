package sss.ui.reactor

import akka.actor.{ Actor, ActorLogging, ActorRef }

class EventBroadcastActor extends Actor with ActorLogging {

  private def manageRegister(registeredParties: Map[String, Set[ActorRef]]): Receive = {

    case Register(eventCategory) => {
      log.info(s"Adding to eventCategory ${eventCategory}")
      val newRegistrant = sender()
      val currentRegistered = registeredParties(eventCategory)
      context.become(manageRegister(registeredParties + (eventCategory -> (currentRegistered + newRegistrant))))
    }

    case UnRegister(eventCategory) => {
      log.info(s"Removing eventCategory ${eventCategory} registrant ")
      val registrant = sender()
      val newRegistrantList = registeredParties(eventCategory).filterNot(_ == registrant)
      context.become(manageRegister(registeredParties + (eventCategory -> (newRegistrantList))))
    }

    case e: Event => {
      if (log.isDebugEnabled) log.debug(s"We got en event -> $e")
      registeredParties(e.category).foreach(_ ! e)
    }

    case Detach =>
      val registrant = sender()
      val newRegistrantMap = registeredParties map {
        case (eventCategory, newRegistrantList) => (eventCategory -> newRegistrantList.filterNot(_ == registrant))
      }
      context.become(manageRegister(newRegistrantMap))

    case str: String => log.debug(s"We got a string? -> $str")
  }

  final def receive = manageRegister(Map().withDefaultValue(Set()))

}