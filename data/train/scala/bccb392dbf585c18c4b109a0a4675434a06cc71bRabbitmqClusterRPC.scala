package com.ecfront.ez.framework.cluster.rabbitmq

import java.util.concurrent.TimeoutException

import com.ecfront.ez.framework.core.EZ
import com.ecfront.ez.framework.core.cluster.ClusterRPC
import com.rabbitmq.client.AMQP.BasicProperties
import com.rabbitmq.client.{AlreadyClosedException, QueueingConsumer, ShutdownSignalException}

import scala.collection.JavaConversions._
import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.Future

object RabbitmqClusterRPC extends ClusterRPC {

  override def ack(address: String, message: String, args: Map[String, String], timeout: Long): (String, Map[String, String]) = {
    val channel = RabbitmqClusterManage.getChannel()
    channel.exchangeDeclare(RabbitmqClusterManage.defaultRPCExchangeName, "direct")
    channel.queueDeclare(address, false, false, false, null)
    val replyQueueName = channel.queueDeclare().getQueue
    val consumer = new QueueingConsumer(channel)
    channel.basicConsume(replyQueueName, true, consumer)
    val corrId = java.util.UUID.randomUUID().toString
    val opt = new BasicProperties
    .Builder()
      .correlationId(corrId)
      .headers(args)
      .replyTo(replyQueueName)
      .build()
    channel.basicPublish("", address, opt, message.getBytes("UTF-8"))
    var replyMessage: String = null
    var replyHeader: Map[String, String] = null
    var hasReply = false
    try {
      while (!hasReply) {
        val delivery = consumer.nextDelivery(timeout)
        if (delivery != null) {
          if (delivery.getProperties.getCorrelationId.equals(corrId)) {
            hasReply = true
            replyHeader =
              if (delivery.getProperties.getHeaders != null) {
                delivery.getProperties.getHeaders.map {
                  header =>
                    header._1 -> header._2.toString
                }.toMap
              } else {
                Map[String, String]()
              }
            replyMessage = new String(delivery.getBody, "UTF-8")
            channel.close()
          }
        } else {
          channel.close()
          throw new TimeoutException("RabbitMQ ack timeout")
        }
      }
    } catch {
      case _: ShutdownSignalException =>
      case _: AlreadyClosedException =>
      case e: Throwable => throw e
    }
    (replyMessage, replyHeader)
  }

  override def ackAsync(address: String, message: String, args: Map[String, String], timeout: Long)
                       (replyFun: => (String, Map[String, String]) => Unit, replyError: => (Throwable) => Unit): Unit = {
    val channel = RabbitmqClusterManage.getChannel()
    channel.exchangeDeclare(RabbitmqClusterManage.defaultQueueExchangeName, "direct")
    channel.queueDeclare(address, false, false, false, null)
    val replyQueueName = channel.queueDeclare().getQueue
    val consumer = new QueueingConsumer(channel)
    channel.basicConsume(replyQueueName, true, consumer)
    val corrId = java.util.UUID.randomUUID().toString
    val opt = new BasicProperties
    .Builder()
      .correlationId(corrId)
      .headers(args)
      .replyTo(replyQueueName)
      .build()
    channel.basicPublish("", address, opt, message.getBytes("UTF-8"))
    EZ.execute.execute(new Runnable {
      override def run(): Unit = {
        var replyMessage: String = null
        var replyHeader: Map[String, String] = null
        var hasReply = false
        try {
          while (!hasReply) {
            val delivery = consumer.nextDelivery(timeout)
            if (delivery != null) {
              if (delivery.getProperties.getCorrelationId.equals(corrId)) {
                hasReply = true
                replyHeader =
                  if (delivery.getProperties.getHeaders != null) {
                    delivery.getProperties.getHeaders.map {
                      header =>
                        header._1 -> header._2.toString
                    }.toMap
                  } else {
                    Map[String, String]()
                  }
                replyMessage = new String(delivery.getBody, "UTF-8")
                channel.close()
              }
            } else {
              channel.close()
              throw new TimeoutException("RabbitMQ ack timeout")
            }
          }
          replyFun(replyMessage, replyHeader)
        } catch {
          case e: ShutdownSignalException => replyError(e)
          case e: AlreadyClosedException => replyError(e)
          case e: Throwable =>
            replyError(e)
            throw e
        }
      }
    })
  }

  override def reply(address: String)(receivedFun: (String, Map[String, String]) => (String, Map[String, String])): Unit = {
    val channel = RabbitmqClusterManage.getChannel()
    channel.exchangeDeclare(RabbitmqClusterManage.defaultRPCExchangeName, "direct")
    channel.queueDeclare(address, false, false, false, null)
    channel.queueBind(address, RabbitmqClusterManage.defaultRPCExchangeName, address)
    val consumer = new QueueingConsumer(channel)
    EZ.execute.execute(new Runnable {
      override def run(): Unit = {
        try {
          while (true) {
            val delivery = consumer.nextDelivery()
            val props = delivery.getProperties()
            val header =
              if (props.getHeaders != null) {
                props.getHeaders.map {
                  header =>
                    header._1 -> header._2.toString
                }.toMap
              } else {
                Map[String, String]()
              }
            val message = new String(delivery.getBody, "UTF-8")
            EZ.execute.execute(new Runnable {
              override def run(): Unit = {
                val result = receivedFun(message, header)
                channel.basicPublish("", props.getReplyTo, new BasicProperties
                .Builder()
                  .headers(result._2)
                  .correlationId(props.getCorrelationId)
                  .build(), result._1.getBytes("UTF-8"))
              }
            })
          }
        } catch {
          case _: ShutdownSignalException =>
          case _: AlreadyClosedException =>
          case e: Throwable => throw e
        }
      }
    })
    channel.basicConsume(address, true, consumer)
  }

  override def replyAsync(address: String)(receivedFun: (String, Map[String, String]) => Future[(String, Map[String, String])]): Unit = {
    val channel = RabbitmqClusterManage.getChannel()
    channel.exchangeDeclare(RabbitmqClusterManage.defaultRPCExchangeName, "direct")
    channel.queueDeclare(address, false, false, false, null)
    channel.queueBind(address, RabbitmqClusterManage.defaultRPCExchangeName, address)
    val consumer = new QueueingConsumer(channel)
    EZ.execute.execute(new Runnable {
      override def run(): Unit = {
        try {
          while (true) {
            val delivery = consumer.nextDelivery()
            val props = delivery.getProperties()
            val header =
              if (props.getHeaders != null) {
                props.getHeaders.map {
                  header =>
                    header._1 -> header._2.toString
                }.toMap
              } else {
                Map[String, String]()
              }
            val message = new String(delivery.getBody, "UTF-8")
            EZ.execute.execute(new Runnable {
              override def run(): Unit = {
                receivedFun(message, header).onSuccess {
                  case result =>
                    channel.basicPublish("", props.getReplyTo, new BasicProperties
                    .Builder()
                      .headers(result._2)
                      .correlationId(props.getCorrelationId)
                      .build(), result._1.getBytes("UTF-8"))
                }
              }
            })
          }
        } catch {
          case _: ShutdownSignalException =>
          case _: AlreadyClosedException =>
          case e: Throwable => throw e
        }
      }
    })
    channel.basicConsume(address, true, consumer)
  }

}
