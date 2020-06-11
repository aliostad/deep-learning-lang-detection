package com.example

import akka.actor.{Actor, ActorLogging, Props}
import com.typesafe.scalalogging.LazyLogging

class DatabaseDumpActor extends Actor with ActorLogging with AutoMarshaller with LazyLogging {
  def receive = {
  	case statistic: StatisticData =>
      try {
        new MongoDBHelper().statisticsCollection.insert(statistic.toMongoDBObject)
      } catch {
        case ex =>{
          logger.error("There was an error trying to save the statistic",ex)
          Thread.sleep(5000)
          self ! statistic
        }
      }
  }
}

object DatabaseDumpActor {
  val props = Props[DatabaseDumpActor]
}







