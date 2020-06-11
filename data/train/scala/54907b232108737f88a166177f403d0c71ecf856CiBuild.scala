package models

import play.api.libs.json._
import play.api.libs.functional.syntax._

case class CiBuild(
    buildNumber: Int,
    status: String,
    description: Option[String],
    culprits: List[String],
    link: String,
    building: Boolean,
    timestamp: Long,
    estimatedDuration: Long) {

}

object CiBuild {
  val writes: Writes[CiBuild] = (
    (JsPath \ "buildNumber").write[Int] and
    (JsPath \ "status").write[String] and
    (JsPath \ "description").write[Option[String]] and
    (JsPath \ "culprits").write[List[String]] and
    (JsPath \ "link").write[String] and
    (JsPath \ "building").write[Boolean] and
    (JsPath \ "timestamp").write[Long] and
    (JsPath \ "estimatedDuration").write[Long]
  )(unlift(CiBuild.unapply))
}