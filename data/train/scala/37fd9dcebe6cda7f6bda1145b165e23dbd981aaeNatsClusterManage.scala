package com.ecfront.ez.framework.cluster.nats

import com.ecfront.common.Resp
import com.ecfront.ez.framework.core.cluster.ClusterManage
import com.fasterxml.jackson.databind.JsonNode
import io.nats.client.{Connection, ConnectionFactory}

import scala.collection.JavaConversions._

object NatsClusterManage extends ClusterManage {

  private var connection: Connection = _
  private[nats] var timeout: Long = _

  override def init(config: JsonNode): Resp[Void] = {
    val address = config.get("address").map("nats://"+_.asText()).toArray
    timeout = config.path("timeout").asLong(-1)

    val cf = new ConnectionFactory()
    cf.setServers(address)
    connection = cf.createConnection()
    Resp.success(null)
  }

  private[nats] def getConnection = connection

  override def close(): Unit = {
    connection.close()
  }

}
