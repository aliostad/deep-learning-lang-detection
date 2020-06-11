package org.dolphin.manager.actor

import akka.actor.{ActorRef, Props, Actor}
import org.dolphin.manager.mail.{TopicsFromBroker, RegisterBroker, TopicFromClient}
import org.dolphin.manager._

/**
 * User: bigbully
 * Date: 14-5-1
 * Time: 上午10:12
 */
class ClusterAct(val clusterName: String) extends Actor {

  import context._

  var brokerRouterAct: ActorRef = _
  var topicRouterAct: ActorRef = _

  override def receive: Actor.Receive = {
    case mail: TopicFromClient => topicRouterAct ! mail
    case mail: TopicsFromBroker => topicRouterAct ! mail
    case mail: RegisterBroker => brokerRouterAct ! mail
  }

  @throws[Exception](classOf[Exception])
  override def preStart() {
    brokerRouterAct = actorOf(Props(classOf[BrokerRouterAct], clusterName), BROKER_ROUTER_ACT_NAME)
    topicRouterAct = actorOf(Props(classOf[TopicRouterAct], clusterName), TOPIC_ROUTER_ACT_NAME)
  }
}
