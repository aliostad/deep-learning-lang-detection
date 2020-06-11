package utils

import com.typesafe.config.ConfigFactory

object Config {
  val RABBITMQ_HOST = ConfigFactory.load().getString("rabbitmq.host")
  val RABBITMQ_QUEUE = ConfigFactory.load().getString("rabbitmq.queue")
  val RABBITMQ_EXCHANGEE = ConfigFactory.load().getString("rabbitmq.exchange")
  val RABBITMQ_USERNAME = ConfigFactory.load().getString("rabbitmq.username")
  val RABBITMQ_PASSWORD = ConfigFactory.load().getString("rabbitmq.password")
  val RABBITMQ_PORT = ConfigFactory.load().getInt("rabbitmq.port")
  val RABBITMQ_VHOST = ConfigFactory.load().getString("rabbitmq.vhost")
}