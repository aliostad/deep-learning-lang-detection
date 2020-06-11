package org.dolphin.manager.actor

import akka.actor.{ActorLogging, Props, ActorRef, Actor}
import org.dolphin.domain.{TopicModel, BrokerModel}
import org.dolphin.common._
import org.dolphin.mail.{TopicCreated, BrokerRegister, ClientRegister}
import org.dolphin.manager.mail._
import org.dolphin.manager.domain.{Broker, Topic, Client}
import org.dolphin.manager._
import org.dolphin.manager.mail.RegisterClient
import org.dolphin.mail.ClientRegister
import org.dolphin.manager.mail.RegisterBroker
import org.dolphin.mail.BrokerRegister
import org.dolphin.domain.BrokerModel
import scala.Some
import org.dolphin.manager.mail.TopicFromClient
import org.dolphin.manager.mail.TopicsFromBroker


/**
 * User: bigbully
 * Date: 14-4-26
 * Time: 下午5:03
 */
class RegistryAct extends Actor with ActorLogging{

  import context._

  var clusterRouterAct: ActorRef = _
  var clientRouterAct: ActorRef = _

  override def receive: Actor.Receive = {
    case ClientRegister(clientModel, topicModel) => {
      val client = Client(clientModel)
      client.remotePath = sender.path.toString
      clientRouterAct ! RegisterClient(client)
      clusterRouterAct ! TopicFromClient(Topic(topicModel), client)
    }
    case BrokerRegister(brokerModel, topicModels) => {
      val broker = Broker(prepare(brokerModel), sender.path.toString)
      clusterRouterAct ! RegisterBroker(broker)
      topicModels match {
        case Some(topics) => {
          clusterRouterAct ! TopicsFromBroker(topics.map(model => Topic(model)), broker)
        }
        case None => //donothing
      }
    }
    case mail@TopicCreated(topicModel, brokerModel) => {
      val topic = Topic(topicModel)
      val broker = Broker(prepare(brokerModel), sender.path.toString)
      val mail = CreateTopicFinished(topic, broker)
      actorSelection(topic.path) ! mail
      actorSelection(broker.path) ! mail
      log.info("broker:{}完成topic:{}的创建!", brokerModel, topicModel)
    }
  }

  /**
   * 如果broker没有设置host，直接从sender中获取
   * @param model
   * @return
   */
  def prepare(model: BrokerModel): BrokerModel = {
    model.host match {
      case null => BrokerModel(model.id, model.cluster, sender.path.address.host.get.toString, model.port)
      case _ => model
    }
  }

  @throws[Exception](classOf[Exception])
  override def preStart() {
    clusterRouterAct = actorOf(Props(classOf[ClusterRouterAct]), CLUSTER_ROUTER_ACT_NAME)
    clientRouterAct = actorOf(Props(classOf[ClientRouterAct]), CLIENT_ROUTER_ACT_NAME)
  }

}

