/**
 *
 */
package ru.kfu.itis.issst.nfcrawler

import extraction.ExtractionConfig
import Messages._
import extraction.TextExtractor
import util.ErrorDumping
import akka.actor.Actor
import akka.event.LoggingReceive
import ru.kfu.itis.issst.nfcrawler.util.ActorLogging

/**
 * @author Rinat Gareev (Kazan Federal University)
 *
 */
class ExtractionManager(config: ExtractionConfig) extends Actor with ActorLogging with ErrorDumping {

  override protected val dumpFileNamePattern = "dump-extraction-%s.txt"
  private val textExtractor = TextExtractor.get(config)

  override val toString = "ExtractionManager"

  override def receive = LoggingReceive {
    case msg @ ExtractTextRequest(pageContent, _, _) =>
      sender ! ExtractTextResponse(extractText(pageContent), msg)
  }

  override def postStop() {
    log.info("Shutting down...")
  }

  private def extractText(htmlSrc: String): String =
    try {
      textExtractor.extractFromHtml(htmlSrc)
    } catch {
      case ex: Exception => {
        val dumpFile = dumpErrorContent(htmlSrc)
        log.error(ex, "Text extraction error. Check dump file {}", dumpFile)
        null
      }
    }
}