package kafka.cluster

import scala.language.implicitConversions

/**
 * Copyright 2014 Box Inc. All rights reserved.
 * User: olvovitch
 * Date: 8/21/14
 * Time: 11:52 AM
 */
// For reasons defying common sense, the Broker class in the Kafka library is private, so we will be defining our own, which is effectively identifcal to it
// Because the "kafka" broker class can only be accessed from the kafka.cluster packes, we need to define these there
object KafkaConversions {
  implicit def kafkaBrokerToBroker(kafkaBroker: Broker): com.box.kafka.Broker = new com.box.kafka.Broker(kafkaBroker.id, kafkaBroker.host, kafkaBroker.port)

  implicit def brokerToKafkaBroker(broker: com.box.kafka.Broker): Broker = new Broker(broker.id, broker.host, broker.port)
}
