package models

import anorm._
import anorm.SqlParser._
import play.api.db._
import play.api.Play.current
import java.util.Date
import scala.language.postfixOps
import org.joda.time.DateTime
import org.joda.time.DateTimeConstants
import org.joda.time.Days
import org.joda.time.format.DateTimeFormat
import anorm.NamedParameter.symbol
import anorm.SQL
import anorm.SqlParser.get
import anorm.sqlToSimple
import play.api.Play.current
import play.api.db.DB
import play.api.libs.json.Json
import play.api.libs.json.Json.toJsFieldJsValueWrapper
import play.api.libs.json.Writes
import utils.Joda.dateTimeOrdering
import java.io.File
import javax.inject.Inject

/**
 * @param pathInStorageDirectory The relative path of the dump file within the storage directory, e.g. `2015-04-27_21-33-00_424/somedmp.dmp`
 */
case class Dump(
    id: Long,
    bucket: Bucket,
    pathInStorageDirectory: String,
    content: String,
    timestamp: DateTime) extends Taggable {

  val filename = new File(pathInStorageDirectory).getName;

  val url = "dmp"
  def fullUrl = s"/dmpster/$url/$id/details"

  /**
   * Reference for 'now' instant in time.
   * The intention for this is to be able to provide a custom implementation in unit tests.
   */
  protected def now = DateTime.now

  private def firstDayOfNewness = {
    now.getDayOfWeek() match {
      case DateTimeConstants.MONDAY => now.minusDays(3).withTimeAtStartOfDay
      case _                        => now.minusDays(1).withTimeAtStartOfDay
    }
  }

  def isNew = firstDayOfNewness.isBefore(timestamp)

  def ageInDays = Days.daysBetween(timestamp, now).getDays

  private def isFromToday = now.withTimeAtStartOfDay.isBefore(timestamp)

  def dateFormatted = {
    if (isFromToday) "today " + timestamp.toString(DateTimeFormat.forPattern("HH:mm"))
    else timestamp.toString(DateTimeFormat.forPattern("YYYY-MM-dd HH:mm"))
  }

  def ageLabel = s"added $dateFormatted - $ageInDays day${if (ageInDays != 1) "s" else ""} old"
}

class DumpJsonWriter @Inject() (tagDb: TagDB) {
  val writeForIndex = Writes[Dump] { d =>
    implicit val tagFormat = Tag.nameOnlyFormat
    Json.obj(
      "id" -> d.id,
      "filename" -> d.filename,
      "isNew" -> d.isNew,
      "ageLabel" -> d.ageLabel,
      "dmpUrl" -> s"/dmps/${d.pathInStorageDirectory.replace("\\", "/")}",
      "tagging" -> Json.obj(
        "tags" -> Json.toJson(tagDb.forDump(d)),
        "addTagUrl" -> d.addTagUrl,
        "removeTagUrl" -> d.removeTagUrl))
  }

  val writeForDetails = Writes[Dump] { d =>
    implicit val tagFormat = Tag.nameOnlyFormat
    Json.obj(
      "id" -> d.id,
      "filename" -> d.filename,
      "dmpUrl" -> s"/dmps/${d.pathInStorageDirectory.replace("\\", "/")}",
      "content" -> d.content,
      "tagging" -> Json.obj(
        "tags" -> Json.toJson(tagDb.forDump(d)),
        "addTagUrl" -> d.addTagUrl,
        "removeTagUrl" -> d.removeTagUrl))
  }
}

case class DumpJsonWriterNoDb (tags: Map[Long, List[Tag]]) {
  val writeForIndex = Writes[Dump] { d =>
    implicit val tagFormat = Tag.nameOnlyFormat
    Json.obj(
      "id" -> d.id,
      "filename" -> d.filename,
      "isNew" -> d.isNew,
      "ageLabel" -> d.ageLabel,
      "dmpUrl" -> s"/dmps/${d.pathInStorageDirectory.replace("\\", "/")}",
      "tagging" -> Json.obj(
        "tags" -> Json.toJson(tags.get(d.id).getOrElse(List())),
        "addTagUrl" -> d.addTagUrl,
        "removeTagUrl" -> d.removeTagUrl))
  }

//  val writeForDetails = Writes[Dump] { d =>
//    implicit val tagFormat = Tag.nameOnlyFormat
//    Json.obj(
//      "id" -> d.id,
//      "filename" -> d.filename,
//      "dmpUrl" -> s"/dmps/${d.pathInStorageDirectory.replace("\\", "/")}",
//      "content" -> d.content,
//      "tagging" -> Json.obj(
//        "tags" -> Json.toJson(tagDb.forDump(d)),
//        "addTagUrl" -> d.addTagUrl,
//        "removeTagUrl" -> d.removeTagUrl))
//  }
}

class DumpDB @Inject() (
    db: Database,
    bucketDb: BucketDB) {
  
  def all: List[Dump] = db.withConnection { implicit c =>
    SQL("select * from dump")
      .as(dump *)
  }

  def allNoContent: List[Dump] = db.withConnection { implicit c =>
    SQL"select id, bucketId, filename, timestamp from dump"
      .as(dumpNoContent *)
  }

  def newerThan(time: DateTime): List[Dump] = db.withConnection { implicit c =>
    SQL"select * from dump where timestamp > ${time.toDate}"
      .as(dump *)
  }

  def olderThan(time: DateTime): List[Dump] = db.withConnection { implicit c =>
    SQL"select * from dump where timestamp < ${time.toDate}"
      .as(dump *)
  }

  def byId(id: Long) = db.withConnection { implicit c =>
    SQL"select * from dump where id = ${id}"
      .as(dump.singleOpt)
  }

  def byBucket(bucket: Bucket) = db.withConnection { implicit c =>
    SQL"select * from dump where bucketId = ${bucket.id}"
      .as(dump *)
  }

  def forBuckets(buckets: List[Bucket]): List[(Bucket, List[Dump])] = db.withConnection { implicit c =>
    buckets.map(bucket => {
      (bucket,
        SQL"select * from dump where bucketId = ${bucket.id}"
        .as(dump *).toList)
    })
  }

  def forBucketsNoContent(buckets: List[Bucket]): List[(Bucket, List[Dump])] = db.withConnection { implicit c =>
    buckets.map(bucket => {
      (bucket,
        SQL"select id, bucketId, filename, timestamp from dump where bucketId = ${bucket.id}"
        .as(dumpNoContent *).toList)
    })
  }

  def byTag(tag: Tag) = db.withConnection { implicit c =>
    SQL"""select * from dumpToTag dtt 
          inner join dump d 
          on d.id = dtt.dumpId 
          where dtt.tagId = ${tag.id}"""
      .as(dump *)
  }

  def create(bucket: Bucket, relFilePath: String, content: String): Dump = {
    val timestamp = DateTime.now
    db.withTransaction { implicit c =>
      val dump = SQL"""
        insert into dump (bucketId, filename, content, timestamp) 
          values (${bucket.id}, $relFilePath, $content, ${timestamp.toDate})
        """
        .executeInsert() match {
          case Some(id) => Dump(id, bucket, relFilePath, content, timestamp)
          case None     => throw new Exception("unable to insert dump into db")
        }
      SQL"""
          insert into bucket_hits (dumpId, bucketId, timestamp)
          values (${dump.id}, ${bucket.id}, ${timestamp.toDate})
          """
        .executeInsert() match {
          case Some(id) => id
          case None     => throw new Exception("unable to insert bucket hit into db")
        }
      dump
    }
  }

  def addTag(dump: Dump, tag: Tag) =
    db.withConnection { implicit c =>
      SQL"insert into dumpToTag (dumpId, tagId) values (${dump.id}, ${tag.id})"
        .executeUpdate
    }

  def removeTag(dump: Dump, tag: Tag) =
    db.withConnection { implicit c =>
      SQL"delete from dumpToTag where dumpId = ${dump.id} and tagId = ${tag.id}"
        .executeUpdate
    }

  def delete(id: Long) = {
    db.withConnection { implicit c =>
      SQL"delete from dump where id = $id".executeUpdate
    }
  }

  def groupDumpsByBucket(dumps: List[Dump]) = {
    import utils.Joda._

    val dumpsByBucket = dumps.groupBy(_.bucket)
    val sortedDumpsByBucket = dumpsByBucket.toList.map {
      case (bucket, dumps) => {
        val sortedDumps = dumps.sortBy(_.timestamp)
        (bucket, sortedDumps)
      }
    }
    val allSorted = sortedDumpsByBucket.sortBy {
      case (bucket, List(newest, _*)) => newest.timestamp
    }
    allSorted
  }

  val dump = {
    get[Long]("id") ~
      get[Long]("bucketId") ~
      get[String]("filename") ~
      get[String]("content") ~
      get[Date]("timestamp") map {
        case id ~ bucketId ~ filename ~ content ~ timestamp =>
          Dump(id, bucketDb.byId(bucketId).get, filename, content, new DateTime(timestamp))
      }
  }

  val dumpNoContent = {
    get[Long]("id") ~
      get[Long]("bucketId") ~
      get[String]("filename") ~
      get[Date]("timestamp") map {
        case id ~ bucketId ~ filename ~ timestamp =>
          Dump(id, bucketDb.byId(bucketId).get, filename, "", new DateTime(timestamp))
      }
  }
}