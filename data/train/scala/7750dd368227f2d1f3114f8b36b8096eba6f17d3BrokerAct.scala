package org.dolphin.client.actor

import akka.actor.Actor
import org.dolphin.domain.BrokerModel
import org.dolphin.mail.SendBatchMessage
import org.dolphin.common._
import org.dolphin.domain.BrokerModel
import org.dolphin.mail.SendBatchMessage

/**
 * User: bigbully
 * Date: 14-5-10
 * Time: 下午9:24
 */
class BrokerAct(val brokerModel:BrokerModel) extends Actor{

  import context._

  val brokerActPath = "akka.tcp://broker@" + brokerModel.host + ":" + brokerModel.port + "/user/" + ENROLL_ACT_NAME + "/" + STORE_ACT_NAME

  //todo 异常后逻辑和确认机制
  override def receive: Actor.Receive = {
    case SendBatchMessage(batch) => actorSelection(brokerActPath) ! SendBatchMessage
  }
}
