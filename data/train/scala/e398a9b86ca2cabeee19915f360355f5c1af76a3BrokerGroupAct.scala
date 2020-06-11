package org.dolphin.client.actor

import akka.actor.{ActorRef, ActorLogging, Props, Actor}
import org.dolphin.client.mail.{BrokersOnlineFinished, BrokersOnline}
import org.dolphin.common._
import org.dolphin.client.ClientConfig
import org.dolphin.client._
import scala.collection.immutable
import akka.routing._
import org.dolphin.Util.DolphinException
import org.dolphin.client.ClientConfig
import org.dolphin.client.mail.BrokersOnlineFinished
import akka.routing.RandomGroup
import org.dolphin.client.mail.BrokersOnline
import scala.Some
import akka.routing.RoundRobinGroup

/**
 * User: bigbully
 * Date: 14-5-10
 * Time: 下午9:10
 */
class BrokerGroupAct(conf:ClientConfig) extends Actor with ActorLogging{
  import context._

  val enrollAct = parent
  var brokerRouter :Option[ActorRef] = None

  override def receive: Actor.Receive = {
    case BrokersOnline(list) => {
      var brokerIds = List.empty[String]
      var brokerPaths = List.empty[String]
      list.foreach{brokerModel => {
        val brokerIdStr = generateStrId(brokerModel.id)
        child(brokerIdStr) match {
          case None => {
            val brokerAct = actorOf(Props(classOf[BrokerAct], brokerModel), brokerIdStr)
            brokerPaths ::= brokerAct.path.toString
            brokerIds ::= brokerIdStr
          }
          case Some(_) =>
        }
      }}
      registerToRouter(brokerPaths.reverse)
      enrollAct ! BrokersOnlineFinished(brokerIds.reverse)
    }
  }

  def registerToRouter(paths:List[String]) {
    brokerRouter match {
      case None => brokerRouter = Some(actorOf(getRouterGroup(paths).props(), BROKER_ROUTER_ACT_NAME))
      case Some(act) => act ! AddRoutee(SeveralRoutees(paths.map(path => ActorSelectionRoutee(actorSelection(path))).toIndexedSeq))
    }
  }

  def getRouterGroup(paths:immutable.Iterable[String]):Group = {
    conf.get(SEND_STRATEGY).get match {
      case ROUND_ROBIN => RoundRobinGroup(paths)
      case SMALLEST_MAILBOX => throw new DolphinException("todo")
      case RANDOM => RandomGroup(paths)
    }
  }

}
