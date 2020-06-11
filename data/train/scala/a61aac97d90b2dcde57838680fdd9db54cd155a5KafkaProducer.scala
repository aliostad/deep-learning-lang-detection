package org.kafka

import java.util.Properties

import kafka.message.Message
import kafka.javaapi.producer.Producer
import kafka.producer.ProducerConfig
import kafka.server.{KafkaConfig, KafkaServer}
import org.apache.curator.test.TestingServer

trait KafkaProducer {
 
  def withKafkaProducer(zkPort: Int = 2182, brokerPort: Int = 9092, executionBlock: Producer[String, String] => Any) = {
    val zookeeperCluster = createZookeeperCluster(zkPort)
    val kafkaBroker = createKafkaBroker(zkPort, brokerPort)
    val kafkaProducer = createKafkaProducer(brokerPort)
    initializeServices(zookeeperCluster, kafkaBroker)
    executionBlock(kafkaProducer)
    shutdownServices(zookeeperCluster, kafkaBroker, kafkaProducer)
  }
  
  def createZookeeperCluster(zkPort: Int) =  new TestingServer(zkPort)

  def createKafkaBroker(zkPort: Int, brokerPort: Int) = {
    val props = new Properties()
    val brokerId = "1"
    props.setProperty("zookeeper.connect", s"localhost:$zkPort")
    props.setProperty("broker.id", brokerId)
    props.setProperty("host.name", "localhost")
    props.setProperty("port", Integer.toString(brokerPort))
    props.setProperty("log.dir", s"/tmp/kafka/$zkPort$brokerPort")
    props.setProperty("log.flush.interval.messages", String.valueOf(1))
    props.put("metadata.broker.list", s"localhost:$brokerPort")
    props.put("auto.leader.rebalance.enable", "true")
    props.put("controlled.shutdown.enable", "true")
    new KafkaServer(new KafkaConfig(props))
  }
  
  def createKafkaProducer(brokerPort: Int) = {
    val propsProd = new Properties()
    propsProd.put("metadata.broker.list", s"localhost:$brokerPort")
    propsProd.put("request.required.acks", "1")
    propsProd.put("serializer.class","kafka.serializer.StringEncoder")
    val prodConfig = new ProducerConfig(propsProd)
    new Producer[String, String](prodConfig)
  }
  
  def initializeServices(zkCluster: TestingServer, kafkaBroker: KafkaServer) = {
    zkCluster.start
    kafkaBroker.startup
  }

  def shutdownServices(zkCluster: TestingServer,
                       kafkaBroker: KafkaServer,
                       kafkaProducer: Producer[String, String]) = {
    kafkaProducer.close
    kafkaBroker.shutdown
    kafkaBroker.awaitShutdown
    zkCluster.stop
  }
}
