package models

import play.api.db._
import play.api.Play.current
import anorm._
import anorm.SqlParser._
import language.postfixOps
import java.net.URLEncoder
import play.api.libs.json.Json
import play.api.libs.json.Writes
import javax.inject.Inject

trait Taggable {
  val url: String
  val id: Long
  //  def tags: List[Tag]

  def addTagUrl = s"/dmpster/$url/$id/addTag/"
  def removeTagUrl = s"/dmpster/$url/$id/removeTag/"
  def fullUrl: String
}

case class Tag(id: Long, name: String) {
  val nameUrlEncoded = URLEncoder.encode(name, "UTF-8").replace("+", "%20")
}

object Tag {
  val nameOnlyFormat = Writes[Tag](t => Json.obj("name" -> t.name))
}

class TagDB @Inject() (db: Database) {
  def all: List[Tag] = db.withConnection {
    implicit c =>
      SQL"select * from tag".as(tag *)
  }

  def forDump(dump: Dump) = db.withConnection { implicit c =>
    {
      SQL"""select * from dumpToTag dtt 
            inner join tag t 
            on t.id = dtt.tagId 
            where dtt.dumpId = ${dump.id}"""
        .as(tag *)
    }
  }

  def byIds(ids: Seq[Long]) = db.withConnection { implicit c =>
    SQL"""select * from tag where id in (${ids})""".as(tag*)
  }

  def idsForDumps(dumps: Seq[Dump]) = db.withConnection { implicit c =>
    SQL"""select dumpId, tagId from dumpToTag dtt
          where dtt.dumpId in (${dumps.map(_.id)})
      """.as(dumpAndTagId *)
      .groupBy { case (dumpId, tagId) => dumpId }
      .map { case (dumpId, ids) => (dumpId, ids.map { case (_, tagId) => tagId }) }
  }

  def forBucket(bucket: Bucket) = db.withConnection { implicit c =>
    {
      SQL"""select * from bucketToTag btt 
            inner join tag t 
            on t.id = btt.tagId 
            where btt.bucketId = ${bucket.id}"""
        .as(tag *)
    }
  }

  def idsForBuckets(buckets: Seq[Bucket]) = db.withConnection { implicit c =>
    SQL"""select bucketId, tagId from bucketToTag btt
          where btt.bucketId in (${buckets.map(_.id)})
      """.as(bucketIdAndTagId *)
      .groupBy { case (bucketId, tagId) => bucketId }
      .map { case (bucketId, ids) => (bucketId, ids.map { case (_, tagId) => tagId }) }
  }

  def create(name: String) = {
    db.withConnection { implicit c =>
      SQL"""insert into tag (name) 
            select (${name}) 
            where not exists 
              (select * from tag 
                where name = ${name})"""
        .executeInsert()
    }
  }

  def findByName(name: String) = {
    db.withConnection { implicit c =>
      SQL"select * from tag where name = ${name}"
        .as(tag.singleOpt)
    }
  }

  def findOrCreate(name: String): Tag = {
    findByName(name)
      .getOrElse(create(name)
        .map(id => Tag(id, name))
        .getOrElse(findByName(name).get)) // concurrent insert, just re-query 
  }

  def tag = {
    get[Long]("id") ~
      get[String]("name") map {
        case id ~ name => Tag(id, name)
      }
  }

  def dumpAndTagId = {
    get[Long]("dumpId") ~
      get[Long]("tagId") map
      { case dumpId ~ tagId => (dumpId, tagId) }
  }
  
  def bucketIdAndTagId = {
    get[Long]("bucketId") ~
      get[Long]("tagId") map
      { case bucketId ~ tagId => (bucketId, tagId) }
  }
}

class TagParser @Inject() (tagDb: TagDB) {
  object Result {
    def unapply(tagName: String) = {
      val trimmed = tagName.trim
      if (!trimmed.isEmpty) Some(tagDb.findOrCreate(trimmed))
      else None
    }
  }
}