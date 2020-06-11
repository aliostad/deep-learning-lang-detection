package net.kemuridama.kafcon.service

import scala.concurrent.Future
import scala.concurrent.ExecutionContext.Implicits.global

import net.kemuridama.kafcon.model.{Cluster, Broker}
import net.kemuridama.kafcon.repository.{UsesBrokerRepository, MixinBrokerRepository}

trait BrokerService
  extends UsesBrokerRepository
  with UsesClusterService
  with UsesBrokerMetricsService {

  def update(cluster: Cluster): Unit = {
    cluster.getAllBrokers.foreach { brokers =>
      brokerRepository.insert(brokers)
      brokers.foreach { broker =>
        brokerMetricsService.update(broker)
      }
    }
  }

  def all: Future[List[Broker]] = brokerRepository.all
  def find(clusterId: Int, id: Int): Future[Option[Broker]] = brokerRepository.find(clusterId, id)
  def findAll(clusterId: Int): Future[List[Broker]] = brokerRepository.findAll(clusterId)

}

object BrokerService
  extends BrokerService
  with MixinBrokerRepository
  with MixinClusterService
  with MixinBrokerMetricsService

trait UsesBrokerService {
  val brokerService: BrokerService
}

trait MixinBrokerService {
  val brokerService = BrokerService
}
