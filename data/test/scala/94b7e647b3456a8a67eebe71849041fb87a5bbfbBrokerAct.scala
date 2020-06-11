package org.dolphin.manager.actor

import akka.actor.Actor
import org.dolphin.domain.TopicModel
import org.dolphin.common._
import org.dolphin.manager.domain.{Topic, Broker}
import org.dolphin.mail.{TopicCreated, CreateTopic}
import org.dolphin.manager.mail.CreateTopicFinished

/**
 * User: bigbully
 * Date: 14-4-28
 * Time: 下午9:58
 */
class BrokerAct(broker: Broker) extends Actor {

  import context._

  val from = actorSelection(broker.remotePath)
  var topics = Set.empty[String] //当前broker所带的topic

  override def receive: Actor.Receive = {
    case CreateTopic(TopicModel(name, cluster)) => {
      if (!topics.contains(name)) {
        actorSelection(broker.remotePath) ! CreateTopic(TopicModel(name, cluster))
      }
    }
    case CreateTopicFinished(topic, _) => {
      topics += topic.name
    }
    case REGISTER_SUCCESS => from ! REGISTER_SUCCESS
  }


}
