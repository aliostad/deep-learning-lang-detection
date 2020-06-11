package net.kemuridama.kafcon.repository

import scala.concurrent.Future

import net.kemuridama.kafcon.model.BrokerMetricsLog
import net.kemuridama.kafcon.util.{UsesApplicationConfig, MixinApplicationConfig}

trait BrokerMetricsLogRepository
  extends UsesApplicationConfig {

  private lazy val maxLogSize = applicationConfig.cluster.getInt("metricsMaxLogSize")

  private var logs = List.empty[BrokerMetricsLog]

  def insert(log: BrokerMetricsLog): Unit = {
    val brokerLogs = log +: logs.filter(l => l.clusterId == log.clusterId && l.brokerId == log.brokerId)
    logs = logs.filterNot(l => l.clusterId == log.clusterId && l.brokerId == log.brokerId) ++ (if (brokerLogs.size >= maxLogSize) brokerLogs.init else brokerLogs)
  }

  def findByBrokerId(clusterId: Int, brokerId: Int): Future[List[BrokerMetricsLog]] = Future.successful {
    logs.filter(l => l.clusterId == clusterId && l.brokerId == brokerId)
  }

}

private[repository] object BrokerMetricsLogRepository
  extends BrokerMetricsLogRepository
  with MixinApplicationConfig

trait UsesBrokerMetricsLogRepository {
  val brokerMetricsLogRepository: BrokerMetricsLogRepository
}

trait MixinBrokerMetricsLogRepository {
  val brokerMetricsLogRepository = BrokerMetricsLogRepository
}
