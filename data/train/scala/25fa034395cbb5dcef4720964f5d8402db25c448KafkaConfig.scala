package com.bear.common.configs

import com.bear.common.manage.BeanFactoryManage
import com.bear.web.service.KafkaService
import org.apache.kafka.clients.consumer.{ConsumerConfig, ConsumerRecord}
import org.apache.kafka.clients.producer.ProducerConfig
import org.apache.naming.factory.BeanFactory
import org.springframework.beans.factory.annotation.{Autowired, Configurable}
import org.springframework.context.annotation.{Bean, Configuration}
import org.springframework.kafka.annotation.EnableKafka
import org.apache.kafka.common.serialization.IntegerDeserializer
import org.springframework.kafka.config.{ConcurrentKafkaListenerContainerFactory, KafkaListenerContainerFactory}
import org.springframework.kafka.core._
import org.springframework.kafka.listener.config.ContainerProperties
import org.springframework.kafka.listener.{ConcurrentMessageListenerContainer, KafkaMessageListenerContainer, MessageListener}

import scala.beans.BeanProperty
import scala.collection.JavaConverters._
/**
  * Created by Apple on 22/01/2017.
  */
@Configuration
@EnableKafka
class KafkaConfig {

  @Autowired
  @BeanProperty var beanFactoryManage: BeanFactoryManage = _

  @Bean
  def producerFactory: ProducerFactory[Int, String] = {
    val props = Map[String, Object](
      ProducerConfig.BOOTSTRAP_SERVERS_CONFIG -> "localhost:9092",
      "group.id" -> "0",
      ProducerConfig.RETRIES_CONFIG -> Integer.valueOf(2),
      ProducerConfig.BATCH_SIZE_CONFIG -> Integer.valueOf(10000),
      ProducerConfig.BUFFER_MEMORY_CONFIG -> Integer.valueOf(3000000),
      ProducerConfig.LINGER_MS_CONFIG -> Integer.valueOf(1),
      ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG -> "org.apache.kafka.common.serialization.IntegerSerializer",
      ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG -> "org.apache.kafka.common.serialization.StringSerializer"
    )
    new DefaultKafkaProducerFactory[Int, String](mapAsJavaMap(props))
  }

  @Bean
  def kafkaTemplate: KafkaTemplate[Int, String] = {
    new KafkaTemplate[Int, String](producerFactory, true)
  }

  @Bean
  def consumerFactory: ConsumerFactory[Int, String] = {
    val props = Map[String, AnyRef](
      ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG -> "localhost:9092",
      "group.id" -> "0",
      "enable.auto.commit" -> Boolean.box(true),
      "auto.commit.interval.ms" -> Integer.valueOf(1000),
      "session.timeout.ms" -> Integer.valueOf(15000),
      "value.deserializer" -> "org.apache.kafka.common.serialization.StringDeserializer",
      "key.deserializer" -> "org.apache.kafka.common.serialization.IntegerDeserializer"
    )
    new DefaultKafkaConsumerFactory[Int, String](mapAsJavaMap(props))
  }

 /* @Bean
  def kafkaMessageListenerContainer: KafkaMessageListenerContainer[Int, String] = {
    val testTopic = "testTopic"
    val factory = new KafkaMessageListenerContainer[Int, String](consumerFactory, new ContainerProperties(testTopic))
    factory.setupMessageListener(beanFactoryManage.getBean[KafkaService]("kafkaService"))
    factory.start()
    factory
  }*/

  @Bean
  def kafkaListenerContainerFactory:
  KafkaListenerContainerFactory[ConcurrentMessageListenerContainer[Int, String]] = {
      val factory = new ConcurrentKafkaListenerContainerFactory[Int, String]()
      factory.setConsumerFactory(consumerFactory)
      factory.setConcurrency(3)
      factory.getContainerProperties.setPollTimeout(3000)
      factory
  }

}
