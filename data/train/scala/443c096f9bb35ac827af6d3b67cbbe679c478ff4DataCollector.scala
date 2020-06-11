package com.example

import akka.actor.ActorSystem
import scala.concurrent.Future
import scala.concurrent.ExecutionContext.Implicits.global

class DataCollector(
                     kafkaSocket: Socket,
                     zooKeeperSocket: Socket,
                     groupId: String,
                     topic: String
                   )(implicit system: ActorSystem) {
  val databaseDumpActor = system.actorOf(DatabaseDumpActor.props, "databaseDumpActor")

  def collect(): Future[Unit] = Future {
    // create consumer
    val consumer = new SimpleKafkaConsumer(kafkaSocket, zooKeeperSocket, groupId, topic)
    val iterator = consumer.read[StatisticData]()
    iterator foreach { data =>
      databaseDumpActor ! data
    }
  }
}
