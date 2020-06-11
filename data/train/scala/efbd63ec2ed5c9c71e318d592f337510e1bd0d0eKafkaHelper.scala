package com.ldaniels528.broadway.core.actors.kafka

import com.ldaniels528.trifecta.io.kafka.{Broker, KafkaMicroConsumer}
import com.ldaniels528.trifecta.io.zookeeper.ZKProxy
import com.ldaniels528.commons.helpers.ResourceHelper._

/**
 * Kafka Helper
 * @author Lawrence Daniels <lawrence.daniels@gmail.com>
 */
object KafkaHelper {

  def getBrokerList(zkConnectionString: String) = ZKProxy(zkConnectionString) use(_.getBrokerList)

  implicit class ZkProxyExtensions(val zKProxy: ZKProxy) extends AnyVal {

    def getBrokerList: Seq[Broker] = {
      val brokerList = KafkaMicroConsumer.getBrokerList(zKProxy)
      (0 to brokerList.size - 1) zip brokerList map { case (n, b) => Broker(b.host, b.port, n) }
    }

  }

}
