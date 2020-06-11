package com.ecfront.ez.framework.cluster.rabbitmq

import java.util.concurrent.CopyOnWriteArrayList

import com.ecfront.common.Resp
import com.ecfront.ez.framework.core.cluster.ClusterManage
import com.fasterxml.jackson.databind.JsonNode
import com.rabbitmq.client.{Channel, Connection, ConnectionFactory}

import scala.collection.JavaConversions._

object RabbitmqClusterManage extends ClusterManage {

  private var conn: Connection = _
  private var factory: ConnectionFactory = _
  private val channels: CopyOnWriteArrayList[Channel] = new CopyOnWriteArrayList[Channel]()

  private[rabbitmq] var defaultTopicExchangeName: String = _
  private[rabbitmq] var defaultRPCExchangeName: String = _
  private[rabbitmq] var defaultQueueExchangeName: String = _

  override def init(config: JsonNode): Resp[Void] = {
    factory = new ConnectionFactory()
    if (config.has("userName")) {
      factory.setUsername(config.get("userName").asText())
      factory.setPassword(config.get("password").asText())
    }
    if (config.has("virtualHost")) {
      factory.setVirtualHost(config.get("virtualHost").asText())
    }
    factory.setHost(config.get("host").asText())
    factory.setPort(config.get("port").asInt())
    if (config.has("defaultTopicExchangeName")) {
      defaultTopicExchangeName = config.get("defaultTopicExchangeName").asText()
    }
    if (config.has("defaultRPCExchangeName")) {
      defaultRPCExchangeName = config.get("defaultRPCExchangeName").asText()
    }
    if (config.has("defaultQueueExchangeName")) {
      defaultQueueExchangeName = config.get("defaultQueueExchangeName").asText()
    }
    conn = factory.newConnection()
    Resp.success(null)
  }

  override def close(): Unit = {
    closeChannel()
    conn.close()
  }

  private[rabbitmq] def getChannel(): Channel = {
    val channel = conn.createChannel()
    channels += channel
    channel
  }

  private[rabbitmq] def closeChannel(): Unit = {
    channels.foreach {
      channel =>
        if (channel.isOpen) {
          channel.close()
        }
    }
  }

}
