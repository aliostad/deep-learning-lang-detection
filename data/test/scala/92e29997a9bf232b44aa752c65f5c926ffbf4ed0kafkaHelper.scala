package me.jie.ksrdd

import kafka.api.TopicMetadataRequest
import kafka.common.{ErrorMapping, TopicAndPartition}
import kafka.consumer.SimpleConsumer

/**
  * Created by jie on 4/28/16.
  */
class kafkaHelper(config: kafkaConfig) {
    private val brokers = config.metadataBrokerList.split(",").map(kafkaBroker(_))
    private val socketTimeoutMs = config.socketTimeoutMs
    private val socketReceiveBufferBytes = config.socketReceiveBufferBytes
    private val consumerId = config.consumerId
    private val retries = config.retries
    private val refreshLeaderBackoffMs = config.refreshLeaderBackoffMs

    def findLeader(topicAndPartition: TopicAndPartition): kafkaBroker =
      Stream(1 to retries: _*).map { _ =>
          brokers.toStream.map { broker =>
            val consumer = new SimpleConsumer(broker.host, broker.port, socketTimeoutMs, socketReceiveBufferBytes, consumerId)
            try {
              consumer.send(new TopicMetadataRequest(Seq(topicAndPartition.topic), 0)).topicsMetadata.toStream.flatMap {
                case topicMeta if (topicMeta.errorCode == ErrorMapping.NoError && topicMeta.topic == topicAndPartition.topic) =>
                  topicMeta.partitionsMetadata
              }.map {
                case partitionMetadata if (partitionMetadata.errorCode == ErrorMapping.NoError &&
                  partitionMetadata.partitionId == topicAndPartition.partition) =>
                  partitionMetadata.leader
              } collectFirst {
                case Some(broker) => kafkaBroker(broker.host, broker.port)
              }
            } catch {
              case _: Throwable => None
            } finally {
              consumer.close()
            }
          } collectFirst {
            case Some(broker) => broker
          }
      } filter{
        case Some(_) => true
        case None    => Thread.sleep(refreshLeaderBackoffMs); false
      } collectFirst { case Some(broker) => broker} match {
        case Some(broker) => broker
        case None         => throw new Exception("Find leader failed!")
      }

    def buildConsumer(broker: kafkaBroker): SimpleConsumer = {
      val kafkaBroker(leaderHost, leaderPort) = broker
      new SimpleConsumer(leaderHost, leaderPort, socketTimeoutMs, socketReceiveBufferBytes, consumerId)
    }
}
