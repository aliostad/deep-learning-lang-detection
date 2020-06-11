package models

import play.api.libs.json._
/**
	This class is to manage the relation of the product with the productor
*/
case class RequestRowProductor(id: Long, requestRowId: Long, productId: Long, productName: String,
								productorId: Long, productorName: String, quantity: Int,
								price: Double, totalPrice: Double, paid: Double, credit: Double, status: String,
								measureId: Long, measureName: String, type_1: String, observation: String)

object RequestRowProductor {
  implicit val RequestRowProductorFormat = Json.format[RequestRowProductor]
}