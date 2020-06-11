package utils

import akka.actor.Actor
import akka.actor.ActorLogging
import org.joda.time.DateTime
import play.api._
import models.Dump
import models.Tag
import models.Bucket
import javax.inject.Inject
import akka.actor.ActorRef
import javax.inject.Named
import akka.actor.ActorSystem
import javax.inject.Singleton
import models.BucketDB
import models.DumpDB
import models.TagDB

case class CleanUp()

trait CleanUpActorScheduler {}

class CleanupActorSchedulerImpl @Inject() @Singleton() (
  @Named("clean-up-actor") cleanUpActor: ActorRef,
  actorSystem: ActorSystem,
  env: Environment) extends CleanUpActorScheduler {
  
  import concurrent.duration._
  def interval = env.mode match {
    case Mode.Dev  => 1.minutes
    case Mode.Prod => 3.hours
    case _         => 3.hours
  }

  import play.api.libs.concurrent.Execution.Implicits._
  actorSystem.scheduler.schedule(5.seconds, interval, cleanUpActor, CleanUp)
}

class CleanUpActor @Inject() (
  configuration: Configuration,
  environment: Environment,
  bucketDb: BucketDB,
  dumpDb: DumpDB,
  tagDb: TagDB,
  cache: BucketsCacheAccess) extends Actor {

  lazy val maxNumberOfDumpsPerBucket = configuration.getInt("dmpster.max.number.of.dmps.per.bucket").getOrElse(5)
  lazy val daysLifetime = configuration.getInt("dmpster.dmp.days.lifetime").getOrElse(14)

  lazy val oldTag = tagDb.findOrCreate("marked for deletion")
  lazy val keepForeverTag = tagDb.findOrCreate("keep forever")

  def receive = {
    case CleanUp => {
      Logger.debug("starting clean up")

      deleteMarkedDumps
      markOldDumps
      limitNumberOfDumpsPerBucket
      cache.invalidate()
    }
  }

  def dateForOldness = environment.mode match {
    case Mode.Dev  => DateTime.now.minusDays(daysLifetime)
    case Mode.Prod => DateTime.now.minusDays(daysLifetime)
  }

  def deleteSingleDump(dmpPath: String, dump: Dump) {
    import java.io.File
    import java.nio.file.Paths

    new File(dmpPath, dump.pathInStorageDirectory).delete
    var currentRelDir = Paths.get(dump.pathInStorageDirectory).getParent()
    while (currentRelDir != null) {
      new File(dmpPath, currentRelDir.toString()).delete
      currentRelDir = currentRelDir.getParent()
    }
  }

  def limitNumberOfDumpsPerBucket = {
    import Joda._

    val dumpsByBucket = for {
      bucket <- bucketDb.all
      dumps = dumpDb.byBucket(bucket)
      if (dumps.length > maxNumberOfDumpsPerBucket)
    } yield (bucket, dumps.sortBy(_.timestamp).reverse)

    dumpsByBucket.foreach {
      case (bucket, dumps) => {
        val dumpsToDeleteCount = dumps.length - maxNumberOfDumpsPerBucket
        val dumpsToDelete = dumps.filterNot(dump => tagDb.forDump(dump).contains(keepForeverTag)).take(dumpsToDeleteCount)

        if (!dumpsToDelete.isEmpty) Logger.info(s"marking ${dumpsToDelete.length} Dmps from Bucket '${bucket.name}' for deletion")

        markForDeletion(dumpsToDelete)
      }
    }
  }

  def markForDeletion(dump: Dump): Unit = {
    if (!tagDb.forDump(dump).contains(oldTag))
      dumpDb.addTag(dump, oldTag)
  }

  def markForDeletion(dumps: List[Dump]): Unit = dumps.foreach(markForDeletion)

  def deleteMarkedDumps = {
    val dumpsToKeepForever = dumpDb.byTag(keepForeverTag)
    val oldDumpsToDelete = dumpDb.byTag(oldTag).filterNot(dumpsToKeepForever.contains(_))

    if (!oldDumpsToDelete.isEmpty) Logger.info(s"deleting ${oldDumpsToDelete.size} dumps")

    val dmpPath = configuration.getString("dmpster.dmp.path")
    oldDumpsToDelete.foreach(dump => {
      dmpPath.map(deleteSingleDump(_, dump))
        .getOrElse(Logger.warn("dmpster.dmp.path not set - unable to delete dmp file"))
      dumpDb.delete(dump.id)
    })
  }

  def markOldDumps = {
    val oldDumps = dumpDb.olderThan(dateForOldness)

    val dumpsToMark = oldDumps.filterNot(dump => {
      val tags = tagDb.forDump(dump)
      tags.contains(oldTag) || tags.contains(keepForeverTag)
    })

    if (!dumpsToMark.isEmpty) Logger.info(s"marking ${dumpsToMark.size} as old")
    markForDeletion(dumpsToMark)
  }
}