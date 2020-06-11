package com.configuration

import com.Consumer.ConsumerConf
import com.rabbitmq.client.ConnectionFactory

import scala.util.Try

trait AppConfiguration {

  val EmptyString = ""

  import com.typesafe.config._

  val conf: Config = ConfigFactory.load()

  val factory = new ConnectionFactory()
  factory.setHost(conf.getString("broker.host"))
  factory.setPort(conf.getInt("broker.port"))
  factory.setUsername(conf.getString("broker.username"))
  factory.setPassword(conf.getString("broker.password"))
  factory.setAutomaticRecoveryEnabled(conf.getBoolean("broker.automatic-recovery"))
  factory.setTopologyRecoveryEnabled(conf.getBoolean("broker.topology-recovery"))

  val consumerConf = ConsumerConf(
    exchange = conf.getString("broker.exchange.name"),
    queue = conf.getString("broker.queue.name"),
    routingKey = Try(conf.getString("broker.exchange.routingKey")).getOrElse(EmptyString),
    durable = conf.getBoolean("broker.queue.durable"),
    exclusive =  conf.getBoolean("broker.queue.exclusive"),
    autoDelete = conf.getBoolean("broker.queue.autoDelete"))

  val consumers = conf.getInt("broker.consumers")

}

object AppConfiguration extends AppConfiguration