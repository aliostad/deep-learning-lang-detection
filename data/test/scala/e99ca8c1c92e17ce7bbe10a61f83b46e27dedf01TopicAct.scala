package org.dolphin.manager.actor

import akka.actor.{ActorLogging, Actor}
import org.dolphin.manager._
import org.dolphin.manager.mail._
import org.dolphin.manager.domain.{Broker, Topic, Client}
import org.dolphin.manager.mail.FindLazyBrokers
import org.dolphin.manager.mail.TopicFromBroker
import org.dolphin.manager.mail.LazyBrokersForTopic
import org.dolphin.mail.ClientRegisterSuccess
import org.dolphin.mail.CreateTopic
import org.dolphin.manager.mail.TopicFromClient

/**
 * User: bigbully
 * Date: 14-4-29
 * Time: 下午6:09
 */
class TopicAct(topic: Topic) extends Actor with ActorLogging {

  import context._

  var clientMap = Map.empty[String, String]
  var brokerMap = Map.empty[Int, String]

  val brokerRouterAct = {
    actorSelection(ACTOR_ROOT_PATH + "/" + CLUSTER_ROUTER_ACT_NAME + "/" + topic.cluster + "/" + BROKER_ROUTER_ACT_NAME)
  }

  override def receive: Actor.Receive = {
    case TopicFromClient(topic, c@Client(id, _)) => {
      clientMap += (id -> c.path)
      brokerRouterAct ! FindLazyBrokers(topic)
    }
    case TopicFromBroker(topic, b@Broker(id, _, _, _)) => {
      brokerMap += (id -> b.path)
    }
    case LazyBrokersForTopic(lazyBrokerPaths) => {
      lazyBrokerPaths.foreach(actorSelection(_) ! CreateTopic(topic.model))
    }
    case CreateTopicFinished(_, broker) => {
      brokerMap += (broker.id -> broker.asInstanceOf[Broker].path)
      log.info("topic:{}现在创建在以下broker列表中:{}", topic, brokerMap)
      //把某个broker上topic创建成功的消息依次通知与topic关联的client
      clientMap.values.foreach(actorSelection(_) ! ClientRegisterSuccess(topic.model, List(broker.model)))
    }
  }

}
