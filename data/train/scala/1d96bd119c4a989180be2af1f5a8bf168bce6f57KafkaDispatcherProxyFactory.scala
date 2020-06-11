package com.box.castle.router.proxy

import akka.actor.ActorContext
import com.box.castle.router.kafkadispatcher.{KafkaDispatcherRef, KafkaDispatcherFactory}
import com.box.kafka.Broker
import org.slf4s.Logging

private[router]
class KafkaDispatcherProxyFactory(kafkaDispatcherFactory: KafkaDispatcherFactory, context: ActorContext) extends Logging {

  def create(broker: Broker, cacheSizePerBrokerInBytes: Long): KafkaDispatcherProxy = {
    new KafkaDispatcherProxy(
      KafkaDispatcherRef(context.actorOf(kafkaDispatcherFactory.props(broker, cacheSizePerBrokerInBytes))),
      KafkaDispatcherRef(context.actorOf(kafkaDispatcherFactory.props(broker, cacheSizePerBrokerInBytes))))
  }
}
