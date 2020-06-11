package org.globalnames
package resolver
package api

import java.io.File
import java.nio.file.Paths

import akka.actor.ActorSystem
import akka.event.Logging
import akka.http.scaladsl.Http
import akka.stream.ActorMaterializer
import com.typesafe.config.ConfigFactory
import model.db.NameStrings
import slick.jdbc.PostgresProfile.api._

import scala.concurrent.duration._
import scalaz._
import Scalaz.{get => _, _}

object GnresolverMicroservice extends App with Service {
  override implicit val system = ActorSystem()
  override implicit val executor = system.dispatcher
  override implicit val materializer = ActorMaterializer()

  override val logger = Logging(system, getClass)
  override val config = {
    val loggerPath = for {
      prop <- util.Properties.propOrNone("config")
      path <- new File(prop).exists().option { prop }
    } yield path

    loggerPath match {
      case Some(lp) =>
        logger.info(s"Loading config from $lp")
        val customConfig = ConfigFactory.parseFile(new File(lp))
        ConfigFactory.load(customConfig)
      case None => logger.info("Loading default config"); ConfigFactory.load()
    }
  }
  override val database = Database.forConfig("postgresql")
  override val matcher = {
    val dumpPath = {
      val dumpFolder = {
        val folder = config.getString("gnresolver.gnmatcher.dump-folder")
        folder.isEmpty ? System.getProperty("java.io.tmpdir") | folder
      }
      val dumpFile = config.getString("gnresolver.gnmatcher.dump-file")
      Paths.get(dumpFolder, dumpFile).toString
    }
    val useDump = config.getBoolean("gnresolver.gnmatcher.use-dump")
    val useFuzzyMatcher = config.getBoolean("gnresolver.gnmatcher.use-fuzzy-matcher")
    logger.info(s"Matcher: dump file path -- $dumpPath")
    logger.info(s"Matcher: use dump file -- $useDump")
    logger.info(s"Matcher: use fuzzy matcher -- $useFuzzyMatcher")
    def createMatcher = {
      val nameStrings = scala.concurrent.Await.result(
        database.run(TableQuery[NameStrings].map { _.canonical }.result.map { _.flatten }),
        15.minutes
      )
      Matcher(nameStrings, maxDistance = 1)
    }
    val matcher = (useFuzzyMatcher, useDump, new File(dumpPath).exists()) match {
      case (false, _, _) =>
        logger.info("Matcher: using empty fuzzy matcher")
        Matcher(Seq(), maxDistance = 0)
      case (_, true, true) =>
        logger.info("Matcher: dump file is found. Restoring from dump...")
        Matcher.restore(dumpPath)
      case (_, true, false) =>
        logger.info("Matcher: dump file is not found. Creating dump...")
        val matcher = createMatcher
        matcher.dump(dumpPath)
        matcher
      case (_, false, _) => createMatcher
    }
    logger.info("Matcher: restored")
    matcher
  }

  Http().bindAndHandle(routes,
                       config.getString("http.interface"),
                       config.getInt("http.port"))
}
