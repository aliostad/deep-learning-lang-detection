package framework.queuing


import application.configuration.Config
import framework.queuing.rabbitmq.RabbitMQConnectionManager

/**
  * Created by nuno on 18-08-2016.
  */
object Messaging {

  private var messaging: BrokerManager = null

  /**
    * Gives a reference to messaging broker.
    *
    * @param broker
    * @return BrokerManager
    */
  private def apply(broker: String): BrokerManager = broker.toLowerCase match {
    case "rabbitmq" => {
      RabbitMQConnectionManager
    }
    case "standario" => {
      throw new UnsupportedClassVersionError("Not implemented")
    }
    case "kafka" => {
      throw new UnsupportedClassVersionError("Not implemented")
    }
    case _ =>
      throw new IllegalArgumentException("Not found")

  }

  /**
    * Simplified Abstract Factory
    *
    * @return BrokerManager
    */
  def getBrokerInstance(): BrokerManager = messaging match {
    case null =>
      messaging = Messaging(Config.MESSAGING_SYSTEM)
      messaging
    case _ => messaging
  }

}
