package ru.fediq.scrapingkit.scraper

import akka.http.scaladsl.model.{HttpMethod, HttpMethods, Uri}
import ru.fediq.scrapingkit.util.Implicits._
import spray.json._

sealed trait Scraped

case class DownloadRequest(
  uri: Uri,
  scraperName: String,
  context: Map[String, String] = Map.empty,
  method: HttpMethod = HttpMethods.GET,
  depthInc: Double = 1.0
) extends Scraped

trait ScrapedEntity extends Scraped {
  def dump: String
}

case class MapScrapedEntity(map: Map[String, Any]) extends ScrapedEntity with DefaultJsonProtocol {
  override def dump = map.mapToJson.compactPrint
}

abstract class JsonScrapedEntity[T](format: JsonFormat[T]) extends ScrapedEntity {
  self: T =>
  override def dump = {
    self.asInstanceOf[T].toJson(format).compactPrint
  }
}

trait PrintableScrapedEntity extends ScrapedEntity {
  override def dump = toString
}
