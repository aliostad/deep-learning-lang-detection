package org.dolphin.manager.actor

import akka.actor.{Identify, ActorLogging, Props, Actor}
import org.dolphin.domain.{TopicModel, BrokerModel}
import org.dolphin.common._
import org.dolphin.manager.mail.{RegisterBroker, LazyBrokersForTopic, FindLazyBrokers}


/**
 * 所有broker的parent
 * User: bigbully
 * Date: 14-4-27
 * Time: 下午9:25
 */
class BrokerRouterAct(val clusterName:String) extends Actor with ActorLogging{
  import context._

  //todo 实现一个查找懒惰的broker的算法
  def findLazyBrokers(topic: String) = {
    List(children.last.path)
  }

  override def receive: Actor.Receive = {
    case RegisterBroker(broker) => {
      child(generateStrId(broker.id)) match {
        case Some(brokerAct) => log.error("存在相同的broker:{}, 不继续创建!", broker)
        case None => {
          actorOf(Props(classOf[BrokerAct], broker), generateStrId(broker.id)) ! REGISTER_SUCCESS
          log.info("成功注册了一个broker{}", broker)
        }
      }
    }
    case FindLazyBrokers(topic) => {
      sender ! LazyBrokersForTopic(findLazyBrokers(topic.name))
    }
  }
}
