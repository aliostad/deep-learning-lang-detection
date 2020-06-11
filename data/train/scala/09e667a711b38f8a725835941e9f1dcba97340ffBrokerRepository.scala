package net.kemuridama.kafcon.repository

import scala.concurrent.Future

import net.kemuridama.kafcon.model.Broker

trait BrokerRepository {

  private var brokers = List.empty[Broker]

  def insert(brokers: List[Broker]): Future[Unit] = Future.successful {
    brokers.map { broker =>
      this.brokers = this.brokers.filterNot(b => b.id == broker.id && b.clusterId == broker.clusterId) :+ broker
    }
  }

  def all: Future[List[Broker]] = Future.successful(brokers)

  def findAll(clusterId: Int): Future[List[Broker]] = Future.successful(brokers.filter(_.clusterId == clusterId))

  def find(clusterId: Int, id: Int): Future[Option[Broker]] = Future.successful {
    brokers.find(b => b.clusterId == clusterId && b.id == id)
  }

}

private[repository] object BrokerRepository
  extends BrokerRepository

trait UsesBrokerRepository {
  val brokerRepository: BrokerRepository
}

trait MixinBrokerRepository {
  val brokerRepository = BrokerRepository
}
