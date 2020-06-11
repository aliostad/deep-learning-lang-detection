package models
import play.api.libs.json._
import play.api.libs.functional.syntax._
/**
 *
 * @author Eric on 2016/8/1 17:34
 */
object JsonWriteImplicit {

  implicit val grayServerWrites: Writes[GrayServer] = (
    (JsPath \ "id").write[Long] and
      (JsPath \ "name").write[String] and
      (JsPath \ "description").write[String] and
      (JsPath \ "entrance").write[String] and
      (JsPath \ "serverType").write[Int] and
      (JsPath \ "subSystemId").write[Long] and
      (JsPath \ "status").write[Int]
    )(unlift(GrayServer.unapply))

//  implicit val grayServerDtoWrites: Writes[GrayServerDto] = (
//    (JsPath \ "id").write[Long] and
//      (JsPath \ "name").write[String] and
//      (JsPath \ "description").write[String] and
//      (JsPath \ "entrance").write[String] and
//      (JsPath \ "serverType").write[Int] and
//      (JsPath \ "subSystemName").write[String] and
//      (JsPath \ "status").write[String]
//    )(unlift(GrayServerDto.unapply))
}
