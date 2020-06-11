package com.ecfront.ez.framework.cluster.nats

import com.ecfront.common.JsonHelper
import com.ecfront.ez.framework.core.EZ
import com.ecfront.ez.framework.core.cluster.ClusterRPC
import io.nats.client.{Message, MessageHandler}

import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.Future

object NatsClusterRPC extends ClusterRPC {

  override def ack(address: String, message: String, args: Map[String, String], timeout: Long = NatsClusterManage.timeout): (String, Map[String, String]) = {
    val msgWrap = new MessageWrap
    msgWrap.message = message
    msgWrap.args = args
    val replyMsg = NatsClusterManage.getConnection.request(address, JsonHelper.toJsonString(msgWrap).getBytes("UTF-8"), timeout)
    val replyInfo = JsonHelper.toObject[MessageWrap](new String(replyMsg.getData, "UTF-8"))
    (replyInfo.message, replyInfo.args)
  }

  override def ackAsync(address: String, message: String, args: Map[String, String], timeout: Long = NatsClusterManage.timeout)
                       (replyFun: => (String, Map[String, String]) => Unit, replyError: => (Throwable) => Unit): Unit = {
    val msgWrap = new MessageWrap
    msgWrap.message = message
    msgWrap.args = args
    EZ.execute.execute(new Runnable() {
      override def run(): Unit = {
        val replyMsg = NatsClusterManage.getConnection.request(address, JsonHelper.toJsonString(msgWrap).getBytes("UTF-8"), timeout)
        val replyInfo = JsonHelper.toObject[MessageWrap](new String(replyMsg.getData, "UTF-8"))
        replyFun(replyInfo.message, replyInfo.args)
      }
    })
  }

  override def reply(address: String)(receivedFun: (String, Map[String, String]) => (String, Map[String, String])): Unit = {
    NatsClusterManage.getConnection.subscribe(address, address, new MessageHandler {
      override def onMessage(msg: Message) = {
        EZ.execute.execute(new Runnable {
          override def run(): Unit = {
            val replyMsg = JsonHelper.toObject[MessageWrap](new String(msg.getData, "UTF-8"))
            val result = receivedFun(replyMsg.message, replyMsg.args)
            val msgWrap = new MessageWrap
            msgWrap.message = result._1
            msgWrap.args = result._2
            NatsClusterManage.getConnection.publish(msg.getReplyTo, JsonHelper.toJsonString(msgWrap).getBytes("UTF-8"))
          }
        })
      }
    })
  }

  override def replyAsync(address: String)(receivedFun: (String, Map[String, String]) => Future[(String, Map[String, String])]): Unit = {
    NatsClusterManage.getConnection.subscribe(address, address, new MessageHandler {
      override def onMessage(msg: Message) = {
        EZ.execute.execute(new Runnable {
          override def run(): Unit = {
            val replyMsg = JsonHelper.toObject[MessageWrap](new String(msg.getData, "UTF-8"))
            receivedFun(replyMsg.message, replyMsg.args).onSuccess {
              case result =>
                val msgWrap = new MessageWrap
                msgWrap.message = result._1
                msgWrap.args = result._2
                NatsClusterManage.getConnection.publish(msg.getReplyTo, JsonHelper.toJsonString(msgWrap).getBytes("UTF-8"))
            }
          }
        })
      }
    })
  }

}
