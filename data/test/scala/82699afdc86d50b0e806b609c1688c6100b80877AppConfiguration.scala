package com.configuration

import com.gateway.MQProducerActor.ProducerConf
import com.rabbitmq.client.ConnectionFactory
import com.rabbitmq.client.MessageProperties._

import scala.util.{Failure, Success, Try}

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

  val producerConf = ProducerConf(
    name = conf.getString("broker.exchange.name"),
    exchangeType = conf.getString("broker.exchange.type"),
    durable = conf.getBoolean("broker.exchange.durable"),
    routingKey = Try(conf.getString("broker.exchange.routingKey")).getOrElse(EmptyString),
    PERSISTENT_TEXT_PLAIN)
}

object AppConfiguration extends AppConfiguration