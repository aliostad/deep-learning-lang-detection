package org.github.mq.namessrv.routeinfo

import java.util.concurrent.locks.ReentrantReadWriteLock

import org.github.mq.common.constant.LoggerName
import org.github.mq.common.protocol.route.{BrokerData, QueueData, TopicRouteData}
import org.slf4j.LoggerFactory

import scala.collection.mutable
import scala.collection.mutable.ArrayBuffer


/**
  * Created by error on 2016/12/28.
  */
object RouteInfoManager {
  private val logger = LoggerFactory.getLogger(LoggerName.NamesrvLoggerName)
}

class RouteInfoManager {
  val lock = new ReentrantReadWriteLock

  //topic与队列，queueData对应一个broker
  val topicQueueTable = new mutable.HashMap[String/*topic*/, ArrayBuffer[QueueData]]
  val brokerAddrTable = new mutable.HashMap[String/*broker name*/, BrokerData]
  val filterServerTable = new mutable.HashMap[String/*broker address*/, ArrayBuffer[String]]()

  def pickupTopicRouteData(topic : String) : TopicRouteData = {
    var topicRouteData : TopicRouteData = new TopicRouteData
    var foundQueueData = false
    var foundBrokerData = false
    val brokerNameSet = new mutable.HashSet[String]
    val brokerDataList = new ArrayBuffer[BrokerData]

    topicRouteData.brokerDatas = brokerDataList
    val filterServerMap = new mutable.HashMap[String, ArrayBuffer[String]]

    try {
      try {
        this.lock.readLock.lockInterruptibly
        val element = this.topicQueueTable.get(topic)
        if (!(element eq None)) {
          val queueDataList = element.get
          topicRouteData.queueDatas = queueDataList
          foundQueueData = true

          //遍历将broker名放入到HashSet
          val it = queueDataList.iterator
          while (it.hasNext) {
            val qd = it.next
            brokerNameSet += (qd.brokerName)
          }

          for (brokerName <- brokerNameSet) {
            val brokerAddrElement = this.brokerAddrTable.get(brokerName)
            if (!brokerAddrElement.equals(None)) {
              val brokerData = brokerAddrElement.get
              val brokerDataClone = new BrokerData
              brokerDataClone.brokerName = brokerData.brokerName
              brokerDataClone.brokerAddrs = brokerData.brokerAddrs.clone
              brokerDataList += brokerDataClone
              foundBrokerData = true

              for (brokerAddr <- brokerDataClone.brokerAddrs.values) {
                val filterServerList = this.filterServerTable.get(brokerAddr).get
                filterServerMap.put(brokerAddr, filterServerList)
              }
            }
          }
        }

      } catch {
        case e: Exception => e.printStackTrace
      } finally {
        this.lock.readLock.unlock
      }
    } catch {
      case e : Exception => e.printStackTrace
    }
    topicRouteData = if(foundBrokerData && foundQueueData) topicRouteData else null
    topicRouteData
  }
  def scanNotActiveBroker : Unit = {
    RouteInfoManager.logger.debug("scan not active broker, {}", this.brokerAddrTable)
  }
}
