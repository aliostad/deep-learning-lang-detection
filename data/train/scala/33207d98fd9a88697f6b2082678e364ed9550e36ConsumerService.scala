package services

import utils.Zookeeper
import kafka.utils.ZkUtils
import scala.collection._
import models.consumer.ConsumerGroups
import models.consumer.ConsumerTopicOffset
import models.topics.Topics
import models.consumer.ConsumerOffsets
import models.consumer.DetailedConsumerTopicOffset
import kafka.consumer.SimpleConsumer
import models.brokers.Broker
import models.consumer.ConsumerBrokerOffset
import models.consumer.ConsumerBrokerOffset
import models.consumer.ConsumerOffset

object ConsumerService {
  
  val consumersZPath = "/consumers"   
  
  def getConsumerGroups : ConsumerGroups = {
    val zkClient = Zookeeper.getInstance()
    val zkConsumerGroups = ZkUtils.getChildrenParentMayNotExist(zkClient, consumersZPath)
    val consumerGroups = new ConsumerGroups
    for(consumers <- zkConsumerGroups){
      consumerGroups.add(consumers)
    }
    consumerGroups
  }
  
  def getConsumerGroupTopics(consumerGroup: String) : Topics = {
    val zkClient = Zookeeper.getInstance()
    val zkTopics = ZkUtils.getChildrenParentMayNotExist(zkClient, consumersZPath + "/" + consumerGroup + "/offsets")
    val topics = new Topics()
    for (topic : String <- zkTopics){
      topics.add(topic)
    }
    topics
  } 
  
  def getConsumerGroupTopicsOffset(consumerGroup: String, topic: String) : ConsumerOffsets = {
    val zkClient = Zookeeper.getInstance()
    val brokerPartitions = ZkUtils.getChildrenParentMayNotExist(zkClient, consumersZPath + "/" + consumerGroup + "/offsets/" + topic)
    val consumerGroups = new ConsumerOffsets()
    for (brokerPartition <- brokerPartitions){
      val offset = getConsumerGroupOffset(consumerGroup, topic, brokerPartition)
      val brokerPartitionSplit = brokerPartition.split("-")
      val consumer = ConsumerTopicOffset(topic, brokerPartitionSplit(0), brokerPartitionSplit(1),offset)
      consumerGroups.add(consumer)
    }
    consumerGroups
  }
  
  def getDetailedConsumerGroupAndTopicsOffsetByBrokerId(consumerGroup: String, topic: String, brokerId: String, partition: String) : ConsumerBrokerOffset = {
      // Get the simple consumer: 
      val brokerInfo : Broker = BrokerService.getBrokerById(brokerId)
      val consumer = new SimpleConsumer(brokerInfo.ip, brokerInfo.port.toInt, 10000, 100000)
              
      val offset = consumer.getOffsetsBefore(topic, partition.toInt, -1, 1).last
      consumer.close();
      ConsumerBrokerOffset(brokerId, partition, offset.toString)
  }
  
  
  def updateBrokerOffset(consumerGroup: String, topic: String, brokerId: String, partition: String) : ConsumerOffset = {
      // Get the simple consumer: 
      val brokerInfo : Broker = BrokerService.getBrokerById(brokerId)
      val consumer = new SimpleConsumer(brokerInfo.ip, brokerInfo.port.toInt, 10000, 100000)
              
      val lastOffset = consumer.getOffsetsBefore(topic, partition.toInt, -1, 1).last
      
      val zkClient = Zookeeper.getInstance()
      val node = brokerId + "-" + partition
      val path = consumersZPath + "/" + consumerGroup + "/offsets/" + topic + "/" + node 
      zkClient.writeData(path,lastOffset.toString())
      
      consumer.close();
      
      ConsumerOffset(brokerId, partition, lastOffset.toString, lastOffset.toString)

  }
  
  def getDetailedConsumerGroupTopicsOffset(consumerGroup: String, topic: String) : List[DetailedConsumerTopicOffset] = {
    val zookeeperOffsets = getConsumerGroupTopicsOffset(consumerGroup, topic)
    val sortedOffsets : mutable.ListBuffer[ConsumerTopicOffset] = zookeeperOffsets.getSortedTopicOffsets

    // build in the return map to the user:
    sortedOffsets.map ((offset: ConsumerTopicOffset) => {
      // Get the simple consumer: 
      val brokerInfo : Broker = BrokerService.getBrokerById(offset.brokerId)
      val consumer = new SimpleConsumer(brokerInfo.ip, brokerInfo.port.toInt, 10000, 100000)
      val brokerOffset = consumer.getOffsetsBefore(offset.topic, offset.partition.toInt, -1, 1).last
      consumer.close
      DetailedConsumerTopicOffset(brokerOffset.toString, offset)
      
    }).toList
  }
  
  def getConsumerGroupOffset(consumerGroup: String, topic: String, brokerPartition: String) : String = {
    val zkClient = Zookeeper.getInstance()
    ZkUtils.readData(zkClient, consumersZPath + "/" + consumerGroup + "/offsets/" + topic + "/" + brokerPartition)	
  }
  
}