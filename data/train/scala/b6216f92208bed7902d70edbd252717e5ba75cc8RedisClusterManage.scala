package com.ecfront.ez.framework.cluster.redis

import com.ecfront.common.Resp
import com.ecfront.ez.framework.core.EZManager
import com.ecfront.ez.framework.core.cluster.ClusterManage
import com.fasterxml.jackson.databind.JsonNode
import redis.clients.jedis._

import scala.collection.JavaConversions._

object RedisClusterManage extends ClusterManage {

  private var redisCluster: JedisCluster = _
  private var redisPool: JedisPool = _

  override def init(config: JsonNode): Resp[Void] = {
    val address = config.get("address").asText().split(";")
    val db = config.path("db").asInt(0)
    val auth = config.path("auth").asText("")

    if (address.size == 1) {
      val Array(host, port) = address.head.split(":")
      redisPool = new JedisPool(
        new JedisPoolConfig(), host, port.toInt,
        Protocol.DEFAULT_TIMEOUT, if (auth == null || auth.isEmpty) null else auth, db)
    } else {
      val node = address.map {
        addr =>
          val Array(host, port) = addr.split(":")
          new HostAndPort(host, port.toInt)
      }.toSet
      redisCluster = new JedisCluster(node)
      // TODO select db & pwd
    }
    Resp.success(null)
  }


  def client(): JedisCommands = {
    if (redisPool != null) {
      if(!EZManager.isClose) {
        redisPool.getResource
      }else{
        null
      }
    } else {
      redisCluster
    }
  }

  override def close(): Unit = {
    if (redisCluster != null) {
      redisCluster.close()
    }
    if (redisPool != null) {
      redisPool.destroy()
      redisPool.close()
    }
  }

  private[redis] def execute[T](client: JedisCommands, fun: JedisCommands => T, method: String): T = {
    try {
      if (client != null) {
        fun(client)
      } else {
        logger.warn("Redis is closed.")
        null.asInstanceOf[T]
      }
    } catch {
      case e: Throwable =>
        logger.error(s"Redis $method error.", e)
        throw e
    } finally {
      if (RedisClusterManage.redisPool != null && client != null) {
        client.asInstanceOf[Jedis].close()
      }
    }
  }

  def flushdb(): Unit = {
    execute[Unit](RedisClusterManage.client(), {
      client =>
        if (redisPool != null) {
          client.asInstanceOf[Jedis].flushDB()
        }
    }, "flushdb")
  }

}
