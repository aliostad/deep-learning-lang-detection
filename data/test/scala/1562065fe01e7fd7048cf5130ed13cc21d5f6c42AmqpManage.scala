package io.gatling.amqp.infra

import akka.actor.{ActorRef, Props}
import io.gatling.amqp.config._
import io.gatling.amqp.data._
import io.gatling.core.result.writer.StatsEngine

import scala.collection.JavaConversions._

class AmqpManage(statsEngine: StatsEngine)(implicit amqp: AmqpProtocol) extends AmqpActor {
  override def receive = {
    case msg@ DeclareExchange(AmqpExchange(name, tpe, durable, autoDelete, arguments)) =>
      log.info(s"Initializing AMQP exchange $name")
      interact(msg) { _.exchangeDeclare(name, tpe, durable, autoDelete, arguments) }

    case msg@ DeclareQueue(AmqpQueue(name, durable, exclusive, autoDelete, arguments)) =>
      log.info(s"Initializing AMQP queue $name")
      interact(msg) { _.queueDeclare(name, durable, exclusive, autoDelete, arguments) }

    case msg@ BindQueue(exchange, queue, routingKey, arguments) =>
      log.info(s"Initializing AMQP binding $exchange to $queue")
      interact(msg) { _.queueBind(queue.name, exchange.name, routingKey, arguments) }
  }
}

object AmqpManage {
  def props(statsEngine : StatsEngine, amqp: AmqpProtocol) = Props(classOf[AmqpManage], statsEngine, amqp)
}