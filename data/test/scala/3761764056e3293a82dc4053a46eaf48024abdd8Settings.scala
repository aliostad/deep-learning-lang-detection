package com.example.config

import java.io.File

import com.itv.bucky.AmqpClientConfig
import com.typesafe.config.{Config, ConfigFactory}

object Settings {

  val configFilePathEnv: String = "/etc/practice.json"
  val configFilePathLocal: String = "/etc/practice.json"

  private val environmentSpecificConfig = ConfigFactory.parseFileAnySyntax(new File(configFilePathEnv))
  private val deployedEnvironmentAgnosticConfig = ConfigFactory.parseFileAnySyntax(new File("/etc/practice.json"))
  private val defaultConfig = ConfigFactory.load()

  private val applicationConfig =
    environmentSpecificConfig
      .withFallback(deployedEnvironmentAgnosticConfig)
      .withFallback(defaultConfig)

  val config: Config = applicationConfig

  object MessageBroker {
    private val messageBrokerConfig = config.getConfig("messageBroker")

    val host: String = messageBrokerConfig.getString("host")
    val port: Int = messageBrokerConfig.getInt("port")
    val userName: String = messageBrokerConfig.getString("username")
    val password: String = messageBrokerConfig.getString("password")
    val vhost: String = messageBrokerConfig.getString("vhost")
    val adminPort: Int = messageBrokerConfig.getInt("adminPort")

    val exchangeName: String = messageBrokerConfig.getString("exchange-name")
    val queueName: String = messageBrokerConfig.getString("queue-name")

    val amqpClientConfig: AmqpClientConfig = AmqpClientConfig(host, port, userName, password, virtualHost = Some(vhost))

    val amqp = Amqp(exchangeName, queueName, amqpClientConfig)

    val inMemory: Boolean = messageBrokerConfig.getBoolean("inMemory")

  }

}

final case class Amqp(exchangeName: String, queueName: String, messageBroker: AmqpClientConfig)