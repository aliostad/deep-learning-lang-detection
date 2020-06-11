package org.beachape.actors
import akka.actor.Actor
import akka.event.Logging
import com.redis._
import org.beachape.analyze.FileMorphemesToRedis
import akka.actor.Props
import akka.pattern.ask
import akka.routing.RoundRobinRouter
import scala.io.Source
import scala.concurrent.{Await, Future}
import akka.util.Timeout
import scala.concurrent.duration._

class FileToRedisActor(redisPool: RedisClientPool, dropBlacklisted: Boolean, onlyWhitelisted: Boolean) extends Actor {

  import context.dispatcher
  implicit val timeout = Timeout(600 seconds)

  val morphemeAnalyzerRoundRobin = context.actorOf(Props(new MorphemesAnalyzerActor(redisPool)).withRouter(RoundRobinRouter(10)), "morphemesAnalyzerRoundRobin")

  def receive = {

    case FilePath(filePath: String) => {
      val redisKey = redisKeyForPath(filePath)
      val zender = sender

      //Not sure if theres a better way, but for now, store everything in memory...
      val linesInFile = Source.fromFile(filePath).getLines.toList
      val listOfAnalyzeAndDumpFutures = for (line <- linesInFile) yield {
        ask(morphemeAnalyzerRoundRobin, List('dumpMorphemesToRedis, RedisKey(redisKey), line, dropBlacklisted, onlyWhitelisted)).mapTo[Boolean]
      }

      val futureListOfAnalyzeAndDumpResults = Future.sequence(listOfAnalyzeAndDumpFutures)

      futureListOfAnalyzeAndDumpResults map {analyzeAndDumpResultsList =>
        analyzeAndDumpResultsList match {
          case x:List[Boolean] if x.forall(_ == true) => {
            zender ! RedisKey(redisKey)
          }
          case _ => exit(1)
        }
      }
    }

    case _ => println("FiletoRedisActor says 'huh?'")
  }

  def redisKeyForPath(path: String) = f"trends:$path%s"
}