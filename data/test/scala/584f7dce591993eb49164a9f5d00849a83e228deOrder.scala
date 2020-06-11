package models

/**
  * Created by lyc08 on 2017/6/18.
  */
import java.sql.Timestamp

import play.api.libs.json.{JsPath, Json, Writes}
import play.api.libs.functional.syntax._

case class Order(id: Long, timestamp: Timestamp, tradetype: String, price: Double, amount: Double, outstanding: Double,
                 status: String, uid: Long, ordertype: String)
case class OrderForm(tradetype: String, price: Double, amount: Double)

object Order{
  implicit val OrderWrites: Writes[Order] = (
    (JsPath \ "id").write[Long] and
      (JsPath \ "timestamp").write[Timestamp] and
      (JsPath \ "tradetype").write[String] and
      (JsPath \ "price").write[Double] and
      (JsPath \ "amount").write[Double] and
      (JsPath \ "outstanding").write[Double] and
      (JsPath \ "status").write[String] and
      (JsPath \ "uid").write[Long] and
      (JsPath \ "ordertype").write[String]
  )(unlift(Order.unapply))

}

object OrderForm{
  implicit val OrderFormWrites: Writes[OrderForm] = (
    (JsPath \ "tradeType").write[String] and
      (JsPath \ "price").write[Double] and
      (JsPath \ "amount").write[Double]
  )(unlift(OrderForm.unapply))
}



