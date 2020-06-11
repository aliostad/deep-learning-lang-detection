/**
 *
 */
package ru.kfu.itis.issst.nfcrawler
import ru.kfu.itis.issst.nfcrawler.parser.ParserConfig
import Messages._
import parser.ParsedFeed
import org.apache.commons.io.FileUtils
import parser.FeedParser
import java.io.File
import ParsingManager._
import ru.kfu.itis.issst.nfcrawler.util.ErrorDumping
import akka.actor.Actor
import akka.event.LoggingReceive
import ru.kfu.itis.issst.nfcrawler.util.ActorLogging

/**
 * @author Rinat Gareev (Kazan Federal University)
 *
 */
class ParsingManager(config: ParserConfig) extends Actor with ActorLogging with ErrorDumping {

  override protected val dumpFileNamePattern = DumpFilePattern
  val feedParser = FeedParser.get(config)

  override val toString = "ParsingManager"

  override def receive = LoggingReceive {
    case msg @ FeedParsingRequest(feedContent) =>
      sender ! FeedParsingResponse(parseFeed(feedContent), msg)
  }

  override def postStop() {
    log.info("Shutting down...")
  }

  private def parseFeed(feedContent: String): ParsedFeed =
    try {
      feedParser.parseFeed(feedContent)
    } catch {
      case ex: Exception => {
        val dumpFile = dumpErrorContent(feedContent)
        log.error(ex, "Feed parsing error. Check content dump in file {}", dumpFile)
        null
      }
    }

}

object ParsingManager {
  private val DumpFilePattern = "parsing-error-dump-%s.txt"
}