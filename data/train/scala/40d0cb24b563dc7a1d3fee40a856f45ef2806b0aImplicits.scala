package json

import play.api.libs.json._
import models.Currency
import play.api.libs.functional.syntax._
import models.Rate
import java.util.Date

object Implicits {

  implicit val currencyWrites: Writes[Currency] = (
    (JsPath \ "id").write[Int] and
    (JsPath \ "number").write[String] and
    (JsPath \ "code").write[String] and
    (JsPath \ "scale").write[Int] and
    (JsPath \ "name").write[String]
  )(unlift(Currency.unapply))
  
  implicit val rateWrites: Writes[Rate] = (
    (JsPath \ "date").write[String] and
    (JsPath \ "rate").write[Double]
  )(unlift(Rate.unapply))
  
}