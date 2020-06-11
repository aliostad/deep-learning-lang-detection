package org.elihw.manager.communication

import com.jd.bdp.whale.communication.{TransportConnection_Thread, ServerWorkerHandler}
import com.jd.bdp.whale.communication.message.Message
import com.jd.bdp.whale.common.communication.{CommonResponse, MessageType}
import com.jd.dd.glowworm.PB
import com.jd.bdp.whale.common.command.{HeartOfBrokerCmd, RegisterBrokerReqCmd}
import akka.actor.{ActorRef, ActorSystem}
import org.elihw.manager.mail.{BrokerHeartMail, StartManagerMail, RegisterMail}

/**
 * User: biandi
 * Date: 13-11-22
 * Time: 上午10:33
 */
class BrokerServerHandler(val connection: TransportConnection_Thread, val brokerRouter:ActorRef) extends ServerWorkerHandler {

  var broker:ActorRef = null

  def transportOnException(p1: Exception) = {

  }

  def doMsgHandler(message: Message): Message = {
    message.getMsgType match {
      case MessageType.REGISTER_BROKER_REQ => {
        val registerBrokerReqCmd = PB.parsePBBytes(message.getContent).asInstanceOf[RegisterBrokerReqCmd]
        brokerRouter ! RegisterMail(registerBrokerReqCmd, this)
      }
      case MessageType.BROKER_HEART  => {
        val heartOfBrokerCmd  = PB.parsePBBytes(message.getContent).asInstanceOf[HeartOfBrokerCmd]
        broker ! BrokerHeartMail(heartOfBrokerCmd)
      }
      case _ => println("不支持的类型")
    }

    val result = new Message
    result.setContent(PB.toPBBytes(CommonResponse.successResponse))
    result
  }

  def finishRegister(broker:ActorRef) = {
    this.broker = broker
    val result = new Message
    result.setMsgType(MessageType.CONNECT_MANAGER_SUCCESS)
    result.setContent(PB.toPBBytes(CommonResponse.successResponse))
    connection.sendMsg(result)
  }

}
