package com.soundcloud.sketchy.broker

/**
 * Suitable for a RabbitMQ HA topology, n consumer instances behind a single
 * load balancer. Load balancer is used by producers.
 */
trait HaBroker {
  def producer(): HaBrokerProducer
  def consumer(): HaBrokerConsumer
}

/**
 * Producer publishes messages to the load balancer.
 */
trait HaBrokerProducer {
  def publish(exchange: String, key: String, payload: String)
}

/**
 * Consumer can subscribe to messages. Subscriptions are duplicated on each
 * balanced broker in the topology.
 *
 * The consumer must declare all exchanges, queues and bindings. The balancer
 * round-robins messages to an effectively random node, so subscriptions have
 * to be bound to all balanced nodes.
 */
trait HaBrokerConsumer {
  def subscribe(
    queue: String,
    exchange: String,
    key: String,
    callback: (HaBrokerEnvelope) => Unit,
    autoDelete: Boolean = true)
}

/**
 * Contains message and a means of ACKing the message.
 */
trait HaBrokerEnvelope {
  def ack(): Unit = Unit
  def payload: String
}

