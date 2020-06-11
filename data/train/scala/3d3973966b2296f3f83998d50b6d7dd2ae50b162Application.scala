package controllers

import java.io.File
import scala.Array.canBuildFrom
import scala.concurrent.Await
import scala.concurrent.Future
import scala.concurrent.duration.Duration
import scala.concurrent.duration.DurationInt
import scala.language.postfixOps
import org.joda.time.DateTime
import org.joda.time.format.DateTimeFormat
import akka.pattern.ask
import akka.util.Timeout
import models.Bucket
import models.Dump
import models.Tag
import models.TagParser
import play.Logger
import play.api.Play
import play.api.libs.Files.TemporaryFile
import play.api.libs.concurrent.Akka
import play.api.libs.concurrent.Execution.Implicits.defaultContext
import play.api.libs.json.JsObject
import play.api.libs.json.Json
import play.api.libs.json.Json.toJsFieldJsValueWrapper
import play.api.libs.json.Json.toJson
import play.api.mvc.Action
import play.api.mvc.Controller
import play.api.mvc.MultipartFormData
import play.api.mvc.Request
import utils.Work
import utils.BucketsCacheAccess
import models.BucketHit
import javax.inject.Inject
import play.api.cache.CacheApi
import utils.BucketsCacheAccess
import akka.actor.ActorSystem
import javax.inject.Named
import akka.actor.ActorRef
import play.api.libs.json.JsValue
import models.BucketDB
import models.DumpDB
import models.BucketHitDb
import models.TagDB
import models.BucketJsonWriter
import models.DumpJsonWriter
import models.DumpJsonWriterNoDb
import models.BucketJsonWriterNoDb

class Application @Inject() (
  cache: BucketsCacheAccess,
  bucketDb: BucketDB,
  bucketHitDb: BucketHitDb,
  dumpDb: DumpDB,
  tagDb: TagDB,
  bucketJsonWriter: BucketJsonWriter,
  dumpJsonWriter: DumpJsonWriter,
  @Named("analyze-master") analyzeMaster: ActorRef) extends Controller {

  def index = Action {
    Redirect(routes.Application.dmpster)
  }

  def dmpster = Action {
    Ok(views.html.index(tagDb.all))
  }
  
  def bucketsNewestJson = {
    Action {
      Ok(bucketHitDb.newest.toString)
    }
  }

  private def bucketsToJson(buckets: Bucket.GroupedBuckets) = {
    val bucketsOnly = buckets.map { case (bucket, _) => bucket }
    val tagIdsForBuckets = tagDb.idsForBuckets(bucketsOnly)
    
    val allTagIdsForBuckets = tagIdsForBuckets.flatMap { case (_, tagIds) => tagIds }.toList.distinct
    
    val dumpsOnly = buckets.flatMap { case (_, dumps) => dumps }
    val tagsForDumps = tagDb.idsForDumps(dumpsOnly)
    val allTagIdsForDumps = tagsForDumps.flatMap { case (_, tagIds) => tagIds }.toList.distinct
    val allTags = tagDb.byIds(allTagIdsForDumps ++ allTagIdsForBuckets).groupBy(_.id)
    
    val tagsByBucketId = tagIdsForBuckets.map { case (bucketId, tagIds) => (bucketId, tagIds.flatMap(allTags.get(_)).flatten) }
    val tagsByDumpId = tagsForDumps.map { case (dumpId, tagIds) => (dumpId, tagIds.flatMap(allTags.get(_)).flatten) }
    
    val bucketHits = bucketHitDb.forBuckets(bucketsOnly)

    implicit val bucketWrites = BucketJsonWriterNoDb(tagsByBucketId, bucketHits).jsonWriter
    implicit val dumpWrites = DumpJsonWriterNoDb(tagsByDumpId).writeForIndex
    implicit val bucketHitWrites = BucketHit

    toJson(buckets.map {
      case (bucket, dumps) =>
        Seq(toJson(bucket), toJson(dumps))
    })
  }
  
  private def analyzingToJson(analyzing: List[File]): JsValue = {
    toJson(analyzing.map(_.getName))
  }
  
  private def fetchGroupedBuckets = dumpDb.forBucketsNoContent(bucketDb.bucketsSortedByDate2())

  def bucketsJson = {
    def generateResponse() = {
      Json.obj(
      "analyzing" -> analyzingToJson(analyzing),
      //"buckets" -> bucketsToJson(cache.getBucketsOrElse(fetchGroupedBuckets)))
      "buckets" -> bucketsToJson(fetchGroupedBuckets))
    }
    
    Action {
      //Ok(cache.getOrElse(generateResponse))
      Ok(generateResponse)
    }
  }

  def updateBucketNotes(id: Long) = Action { request =>
    request.body.asFormUrlEncoded.map(m => {
      val notes = m("notes")
      Logger.info(notes.toString)
      bucketDb.updateNotes(id, notes.headOption.getOrElse(""))
      cache.invalidate()
      Ok("")
    }).getOrElse {
      BadRequest("no notes specified")
    }
  }

  def detailsJson(id: Long) = Action {
    implicit val dumpWrites = dumpJsonWriter.writeForDetails
    val optResult = for {
      dump <- dumpDb.byId(id)
    } yield Ok(toJson(dump))
    optResult.getOrElse(BadRequest(s"Dump ${id} not found"))
  }

  def viewDetails(id: Long) = Action {
    val optResult = for {
      dump <- dumpDb.byId(id)
    } yield Ok(views.html.details(dump.bucket, dump))
    optResult.getOrElse(BadRequest(s"Dump ${id} not found"))
  }

  def viewBucket(id: Long) = Action {
    val result = for {
      bucket <- bucketDb.byId(id)
      dumps = dumpDb.byBucket(bucket)
    } yield Ok(views.html.viewBucket(bucket, dumps, List()))

    result.getOrElse(NotFound(s"Bucket ${id} not found"))
  }

  def bucketJson(id: Long) = Action {
    implicit val bucketWrites = bucketJsonWriter.jsonWriter
    implicit val dumpWrites = dumpJsonWriter.writeForIndex

    val result = for {
      bucket <- bucketDb.byId(id)
      dumps = dumpDb.byBucket(bucket)
    } yield Ok(Json.obj("bucket" -> toJson(bucket), "dumps" -> toJson(dumps)))

    result.getOrElse(NotFound(s"Bucket ${id} not found"))
  }

  def bucketHitsJson(id: Long) = Action {
    Ok(toJson(bucketHitDb.byBucket(id).foldLeft(Json.obj()) {
      case (json, (time, count)) => json + (time.toString, toJson(count))
    }))
  }

  def analyzing: List[File] = {
    implicit val timeout = Timeout(15 seconds)
    val jobs = analyzeMaster ? utils.QueryRunningJobs
    val files = Await.result(jobs.mapTo[utils.RunningJobs], Duration.Inf).jobs
    files
  }

  def addTagToDmp(id: Long, tagName: String) = Action {
    val tag = tagDb.findOrCreate(tagName)

    dumpDb.byId(id).map(dump => {
      if (!tagDb.forDump(dump).exists(_.name == tagName)) dumpDb.addTag(dump, tag)
      invalidateCache()
      Ok("tag added")
    }).getOrElse(NotFound(s"Invalid dump id ${id}"))
  }

  def removeTagFromDmp(id: Long, tagName: String) = Action {
    tagDb.findByName(tagName).flatMap(tag => {
      dumpDb.byId(id).map(dump => {
        dumpDb.removeTag(dump, tag)
        invalidateCache()
        Ok("tag removed")
      })
    }).getOrElse(NotFound("Invalid dump id or tag"))
  }

  def addTagToBucket(id: Long, tagName: String) = Action {
    val tag = tagDb.findOrCreate(tagName)
    val result = for { bucket <- bucketDb.byId(id) } yield {
      if (!tagDb.forBucket(bucket).exists(_.name == tagName)) {
        bucketDb.addTag(bucket, tag)
        cache.updateBucketOrElse(bucket)(fetchGroupedBuckets)
      }
      Ok("tag added")
    }
    result.getOrElse(NotFound(s"Bucket ${id} not found"))
  }

  def removeTagFromBucket(id: Long, tagName: String) = Action {
    val tag = tagDb.findOrCreate(tagName)
    val result = for (bucket <- bucketDb.byId(id)) yield {
      bucketDb.removeTag(bucket, tag)
      cache.updateBucketOrElse(bucket)(fetchGroupedBuckets)
      Ok("tag removed")
    }
    result.getOrElse(NotFound(s"Bucket ${id} not found"))
  }

  def invalidateCache() = cache.invalidate()
}
