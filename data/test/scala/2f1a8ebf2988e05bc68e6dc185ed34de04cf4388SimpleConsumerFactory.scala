package com.box.castle.consumer

import com.box.kafka.Broker
import kafka.consumer.SimpleConsumer

import scala.concurrent.duration.FiniteDuration

// $COVERAGE-OFF$
class SimpleConsumerFactory {

  def create(broker: Broker,
             brokerTimeout: FiniteDuration,
             bufferSize: Int,
             clientId: ClientId): SimpleConsumer = {
    require(brokerTimeout.toMillis > 0, "broker timeout must be positive")
    new SimpleConsumer(broker.host,
                       broker.port,
                       brokerTimeout.toMillis.toInt,
                       bufferSize,
                       clientId.value)
  }
}

// $COVERAGE-ON$
