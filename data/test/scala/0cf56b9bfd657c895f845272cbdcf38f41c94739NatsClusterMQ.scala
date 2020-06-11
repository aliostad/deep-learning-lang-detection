package com.ecfront.ez.framework.cluster.nats

import com.ecfront.common.JsonHelper
import com.ecfront.ez.framework.core.EZ
import com.ecfront.ez.framework.core.cluster.ClusterMQ
import io.nats.client.{Message, MessageHandler}

object NatsClusterMQ extends ClusterMQ {

  override def publish(topic: String, message: String, args: Map[String, String]): Unit = {
    val msgWrap = new MessageWrap
    msgWrap.message = message
    msgWrap.args = args
    NatsClusterManage.getConnection.publish(topic, JsonHelper.toJsonString(msgWrap).getBytes("UTF-8"))
  }

  override def subscribe(topic: String)(receivedFun: (String, Map[String, String]) => Unit): Unit = {
    NatsClusterManage.getConnection.subscribe(topic, new MessageHandler {
      override def onMessage(msg: Message) = {
        EZ.execute.execute(new Runnable {
          override def run(): Unit = {
            val replyMsg = JsonHelper.toObject[MessageWrap](new String(msg.getData, "UTF-8"))
            receivedFun(replyMsg.message, replyMsg.args)
          }
        })
      }
    })
  }

  override def request(address: String, message: String, args: Map[String, String]): Unit = {
    val msgWrap = new MessageWrap
    msgWrap.message = message
    msgWrap.args = args
    NatsClusterManage.getConnection.request(address, JsonHelper.toJsonString(msgWrap).getBytes("UTF-8"))
  }

  override def response(address: String)(receivedFun: (String, Map[String, String]) => Unit): Unit = {
    NatsClusterManage.getConnection.subscribe(address, address, new MessageHandler {
      override def onMessage(msg: Message) = {
        EZ.execute.execute(new Runnable {
          override def run(): Unit = {
            val replyMsg = JsonHelper.toObject[MessageWrap](new String(msg.getData, "UTF-8"))
            receivedFun(replyMsg.message, replyMsg.args)
            NatsClusterManage.getConnection.publish(msg.getReplyTo, "".getBytes("UTF-8"))
          }
        })
      }
    })
  }

}
