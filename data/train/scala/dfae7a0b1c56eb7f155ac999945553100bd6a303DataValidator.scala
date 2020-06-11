package fi.proweb.train.actor.component

import akka.actor.Actor
import akka.actor.ActorRef
import akka.actor.ActorLogging

case class Invalid(loadData: String)

abstract class DataValidator extends Actor with ActorLogging {

  var deliveryTarget: Option[ActorRef] = None
  
  def receive = {
    case DeliveryTarget(target) => deliveryTarget = Some(target)
    case LoadData(loadData) => validateAndDeliver(loadData)
  }

  def validateAndDeliver(loadData: String) {
    if (valid(loadData)) {
      if (deliveryTarget == None) {
        log.error("Empty Delivery target when trying to deliver")
      } else {
        log.debug("Validating and delivering loadData to " + deliveryTarget)
        deliveryTarget.foreach(_ ! LoadData(loadData))
      }
    } else {
      log.warning("Invalid load lata")
      context.parent ! Invalid(loadData)
    }
  }
  
  def valid(loadData: String): Boolean
  
}