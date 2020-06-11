package model

import com.mongodb.casbah.Imports._
import java.util.Date
import com.novus.salat._
import com.novus.salat.dao._
import play.api.Play.current
import se.radley.plugin.salat._

import customContext._
import com.mongodb.casbah.commons.MongoDBObject

abstract class Log(
                    val id: ObjectId = new ObjectId,
                    val title: String,
                    val content: String,
                    val date: Date = new Date()
                    )

trait LogDAO extends ModelCompanion[Log, ObjectId] {
  def collection = mongoCollection("Logs")

  val dao = new SalatDAO[Log, ObjectId](collection) {}
  def findLatestLog(): List[Log] =
    Log.find(MongoDBObject()).sort(orderBy = MongoDBObject("_id" -> -1)).toList

}

trait LogFunc{

  def collection = mongoCollection("Logs")

  val dao = new SalatDAO[Log, ObjectId](collection) {}
}

object Log extends LogDAO

case class ErrorLog(
                     override val id: ObjectId = new ObjectId,
                     override val title: String,
                     override val content: String,
                     override val date: Date = new Date()
                     ) extends Log(id, title, content)

trait ErrorLogDAO extends ModelCompanion[ErrorLog, ObjectId] {
  def collection = mongoCollection("Logs")

  val dao = new SalatDAO[ErrorLog, ObjectId](collection) {}

  def findLatestErrorLog(): List[Log] =
    Log.find(MongoDBObject()).sort(orderBy = MongoDBObject("_id" -> -1)).filter {
      case _: ErrorLog => true
      case _ => false
    }.toList
}

object ErrorLog extends ErrorLogDAO

case class EventLog(
                     override val id: ObjectId = new ObjectId,
                     override val title: String,
                     override val content: String,
                     override val date: Date = new Date()
                     ) extends Log(id, title, content)

trait EventLogDAO extends ModelCompanion[EventLog, ObjectId] {
  def collection = mongoCollection("Logs")

  val dao = new SalatDAO[EventLog, ObjectId](collection) {}

  def findLatestEventLog(): List[Log] =
    Log.find(MongoDBObject()).sort(orderBy = MongoDBObject("_id" -> -1)).filter {
      case _: EventLog => true
      case _ => false
    }.toList

}

object EventLog extends EventLogDAO

/*
case class ManageLog(
                      id: ObjectId = new ObjectId,
                      logs: List[Log]
                      )

trait ManageLogDAO extends ModelCompanion[ManageLog, ObjectId] {
  def collection = mongoCollection("Logs")

  val dao = new SalatDAO[ManageLog, ObjectId](collection) {}
}

object ManageLog extends ManageLogDAO
*/