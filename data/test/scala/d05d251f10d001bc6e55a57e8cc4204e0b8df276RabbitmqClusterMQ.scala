package com.ecfront.ez.framework.cluster.rabbitmq

import com.ecfront.ez.framework.core.EZ
import com.ecfront.ez.framework.core.cluster.ClusterMQ
import com.rabbitmq.client.AMQP.BasicProperties
import com.rabbitmq.client._

import scala.collection.JavaConversions._

object RabbitmqClusterMQ extends ClusterMQ {

  override def publish(topic: String, message: String, args: Map[String, String]): Unit = {
    val channel = RabbitmqClusterManage.getChannel()
    channel.exchangeDeclare(RabbitmqClusterManage.defaultTopicExchangeName, "direct")
    channel.queueDeclare(topic, false, false, false, null)
    val opt = new AMQP.BasicProperties.Builder().headers(args).build()
    channel.basicPublish(RabbitmqClusterManage.defaultTopicExchangeName, topic, opt, message.getBytes("UTF-8"))
    channel.close()
  }

  override def subscribe(topic: String)(receivedFun: (String, Map[String, String]) => Unit): Unit = {
    val channel = RabbitmqClusterManage.getChannel()
    channel.exchangeDeclare(RabbitmqClusterManage.defaultTopicExchangeName, "direct")
    channel.queueDeclare(topic, false, false, false, null)
    val queueName = channel.queueDeclare().getQueue
    channel.queueBind(queueName, RabbitmqClusterManage.defaultTopicExchangeName, topic)
    val consumer = new DefaultConsumer(channel) {
      override def handleDelivery(consumerTag: String, envelope: Envelope, properties: BasicProperties, body: Array[Byte]): Unit = {
        val header =
          if (properties.getHeaders != null) {
            properties.getHeaders.map {
              header =>
                header._1 -> header._2.toString
            }.toMap
          } else {
            Map[String, String]()
          }
        val message = new String(body, "UTF-8")
        EZ.execute.execute(new Runnable {
          override def run(): Unit = {
            receivedFun(message, header)
          }
        })
      }
    }
    channel.basicConsume(queueName, true, consumer)
  }

  override def request(address: String, message: String, args: Map[String, String]): Unit = {
    val channel = RabbitmqClusterManage.getChannel()
    channel.exchangeDeclare(RabbitmqClusterManage.defaultQueueExchangeName, "direct")
    channel.queueDeclare(address, true, false, false, null)
    val opt = new AMQP.BasicProperties.Builder().headers(args).build()
    channel.basicPublish(RabbitmqClusterManage.defaultQueueExchangeName, address, opt, message.getBytes("UTF-8"))
    channel.close()
  }

  override def response(address: String)(receivedFun: (String, Map[String, String]) => Unit): Unit = {
    val channel = RabbitmqClusterManage.getChannel()
    channel.exchangeDeclare(RabbitmqClusterManage.defaultQueueExchangeName, "direct")
    channel.queueDeclare(address, true, false, false, null)
    channel.queueBind(address, RabbitmqClusterManage.defaultQueueExchangeName, address)
    val consumer = new QueueingConsumer(channel)
    EZ.execute.execute(new Runnable {
      override def run(): Unit = {
        try {
          while (true) {
            val delivery = consumer.nextDelivery()
            val header =
              if (delivery.getProperties.getHeaders != null) {
                delivery.getProperties.getHeaders.map {
                  header =>
                    header._1 -> header._2.toString
                }.toMap
              } else {
                Map[String, String]()
              }
            val message = new String(delivery.getBody, "UTF-8")
            EZ.execute.execute(new Runnable {
              override def run(): Unit = {
                receivedFun(message, header)
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
