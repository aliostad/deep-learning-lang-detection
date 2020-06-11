package services

import kafka.utils.ZkUtils
import utils.Zookeeper
import scala.collection._
import models.brokers.Broker
import models.brokers.Brokers

object BrokerService {
  
  val brokerTopicsZPath = "/brokers/ids"
    
  def getBrokers = {
    
    val zkClient = Zookeeper.getInstance()
    val brokerIds = ZkUtils.getChildrenParentMayNotExist(zkClient, brokerTopicsZPath)
    val brokers = new Brokers

    // Get all the broker identifiers and bring their personal information.
//    val manyBrokers = brokerIds.map((bid: String) => {
//      val brokerInformation = ZkUtils.readData(zkClient, brokerTopicsZPath + "/" + bid)
//      val brokenBrokerInformation = brokerInformation.split(":")
//      val broker: Broker = Broker(bid, brokenBrokerInformation(1),brokenBrokerInformation(2))
//      broker
//    })
    
    for(brokerId <- brokerIds){
    	val brokerInformation = ZkUtils.readData(zkClient, brokerTopicsZPath + "/" + brokerId)
    	val brokenBrokerInformation = brokerInformation.split(":")
        val broker: Broker = Broker(brokerId, brokenBrokerInformation(1),brokenBrokerInformation(2))
        brokers.add(broker)
    }
    brokers
  }
  
  
  def getBrokerById(id: String) : Broker = {
    val zkClient = Zookeeper.getInstance()
    val brokerInformation = ZkUtils.readData(zkClient, brokerTopicsZPath + "/" + id)
    val brokenBrokerInformation = brokerInformation.split(":")
    val broker: Broker = Broker(id, brokenBrokerInformation(1),brokenBrokerInformation(2))
    broker
  }
  
}