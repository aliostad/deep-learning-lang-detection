package oldModel

import play.api.libs.json._
import play.api.libs.functional.syntax._
import reactivemongo.bson._
import services.dao.UtilBson

case class OldProviderUser(
  id: String,
  socialType: String,
  token:Option[OldSkimboToken],
  username: Option[String] = None,
  name: Option[String] = None,
  description: Option[String] = None,
  avatar: Option[String] = None)

object OldProviderUser {

  def fromBSON(d: BSONDocument) = {
    OldProviderUser(
          d.getAs[String]("id").get,
          d.getAs[String]("social").get,
          OldSkimboToken.fromBSON(d.getAs[BSONDocument]("token").get)
        )
  }
  
}