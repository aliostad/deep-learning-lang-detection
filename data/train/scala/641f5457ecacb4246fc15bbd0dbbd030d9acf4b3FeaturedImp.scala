package conf
import play.api._
import play.api.mvc._
import play.api.libs.json._
import play.api.libs.functional.syntax._
import play.api.libs.json
import scala.util.Try
import scala.collection.mutable._
import models._

object FeaturedImp {
  implicit val coverWrite: Writes[Cover] = (
  (JsPath \ "songimageURL170").write[String] and
  (JsPath \ "songimageURL500").write[String]
  )(unlift(Cover.unapply))
  
  
  implicit val seedWrite: Writes[Seed] = (
  (JsPath \ "name").write[String] and
  (JsPath \ "seedtypeid").write[Int] and
  (JsPath \ "seedid").write[Int] and
  (JsPath \ "description").write[String] and
  (JsPath \ "cover").write[Cover] 
  )(unlift(Seed.unapply))
  
  
  
  implicit val bodyWrite: Writes[Body] = (
  (JsPath \ "count").write[Int] and
  (JsPath \ "seeds").write[MutableList[Seed]] 
  )(unlift(Body.unapply))
  
  
  implicit val resWrite: Writes[Response] = (
  (JsPath \ "status").write[Boolean] and
  (JsPath \ "message").write[String] and
  (JsPath \ "errorcode").write[Int] and
  (JsPath \ "body").write[Body]
  )(unlift(Response.unapply)) 

}