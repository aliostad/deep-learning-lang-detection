package net.kemuridama.kafcon.service

import scala.concurrent.Future
import scala.concurrent.ExecutionContext.Implicits.global
import javax.management._

import net.kemuridama.kafcon.model.{Broker, BrokerMetrics, CombinedBrokerMetrics, BrokerMetricsLog, CombinedBrokerMetricsLog, SystemMetrics, MeterMetric, MetricsType}
import net.kemuridama.kafcon.repository.{UsesBrokerMetricsLogRepository, MixinBrokerMetricsLogRepository}
import net.kemuridama.kafcon.util.{UsesApplicationConfig, MixinApplicationConfig}

trait BrokerMetricsService
  extends UsesBrokerMetricsLogRepository
  with UsesBrokerService {

  import collection.JavaConverters._

  def update(broker: Broker): Unit = {
    broker.withMBeanServerConnection { mbsc =>
      BrokerMetricsLog(
        clusterId       = broker.clusterId,
        brokerId        = broker.id,
        messageInPerSec = getMeterMetric(mbsc, MetricsType.MessagesInPerSec.toObjectName),
        bytesInPerSec   = getMeterMetric(mbsc, MetricsType.BytesInPerSec.toObjectName),
        bytesOutPerSec  = getMeterMetric(mbsc, MetricsType.BytesOutPerSec.toObjectName),
        system          = getSystemMetrics(mbsc)
      )
    } map { log =>
      brokerMetricsLogRepository.insert(log)
    }
  }

  def findByClusterId(clusterId: Int): Future[List[BrokerMetrics]] = {
    for {
      brokers        <- brokerService.findAll(clusterId)
      brokersMetrics <- Future.sequence(brokers.map { broker =>
        brokerMetricsLogRepository.findByBrokerId(clusterId, broker.id).map { brokerMetricsLogs =>
          BrokerMetrics(
            brokerId = broker.id,
            latest   = brokerMetricsLogs.headOption,
            logs     = brokerMetricsLogs
          )
        }
      })
    } yield brokersMetrics
  }

  def findByBrokerId(clusterId: Int, brokerId: Int): Future[Option[BrokerMetrics]] = {
    (for {
      Some(broker)      <- brokerService.find(clusterId, brokerId)
      brokerMetricsLogs <- brokerMetricsLogRepository.findByBrokerId(clusterId, brokerId)
    } yield {
      Some(BrokerMetrics(
        brokerId = brokerId,
        latest   = brokerMetricsLogs.headOption,
        logs     = brokerMetricsLogs
      ))
    }).recoverWith {
      case _: Throwable => Future.successful(None)
    }
  }

  private def getMeterMetric(mbsc: MBeanServerConnection, objectName: ObjectName): MeterMetric = {
    val attrList = Array("Count", "MeanRate", "OneMinuteRate", "FiveMinuteRate", "FifteenMinuteRate")
    val attrs = mbsc.getAttributes(objectName, attrList).asList.asScala.toList
    MeterMetric(
      getAttributeLongValue(attrs, "Count"),
      getAttributeDoubleValue(attrs, "MeanRate"),
      getAttributeDoubleValue(attrs, "OneMinuteRate"),
      getAttributeDoubleValue(attrs, "FiveMinuteRate"),
      getAttributeDoubleValue(attrs, "FifteenMinuteRate")
    )
  }

  private def getSystemMetrics(mbsc: MBeanServerConnection): SystemMetrics = {
    val attrList = Array("SystemLoadAverage", "SystemCpuLoad", "ProcessCpuLoad", "TotalPhysicalMemorySize", "FreePhysicalMemorySize", "TotalSwapSpaceSize", "FreeSwapSpaceSize", "CommittedVirtualMemorySize")
    val attrs = mbsc.getAttributes(MetricsType.OperatingSystem.toObjectName, attrList).asList.asScala.toList
    SystemMetrics(
      getAttributeDoubleValue(attrs, "SystemLoadAverage"),
      getAttributeDoubleValue(attrs, "SystemCpuLoad"),
      getAttributeDoubleValue(attrs, "ProcessCpuLoad"),
      getAttributeLongValue(attrs, "TotalPhysicalMemorySize"),
      getAttributeLongValue(attrs, "FreePhysicalMemorySize"),
      getAttributeLongValue(attrs, "TotalSwapSpaceSize"),
      getAttributeLongValue(attrs, "FreeSwapSpaceSize"),
      getAttributeLongValue(attrs, "CommittedVirtualMemorySize")
    )
  }

  private def getAttributeLongValue(attrs: List[Attribute], name: String): Long = attrs.find(_.getName == name).map(_.getValue.asInstanceOf[Long]).getOrElse(0L)
  private def getAttributeDoubleValue(attrs: List[Attribute], name: String): Double = attrs.find(_.getName == name).map(_.getValue.asInstanceOf[Double]).getOrElse(0D)

}

private[service] object BrokerMetricsService
  extends BrokerMetricsService
  with MixinBrokerMetricsLogRepository
  with MixinBrokerService

trait UsesBrokerMetricsService {
  val brokerMetricsService: BrokerMetricsService
}

trait MixinBrokerMetricsService {
  val brokerMetricsService = BrokerMetricsService
}
