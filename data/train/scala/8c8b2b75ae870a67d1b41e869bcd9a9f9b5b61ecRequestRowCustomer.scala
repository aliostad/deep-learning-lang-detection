package models

import play.api.libs.json._
/**
 * This class is to manage the relation of the product with the customer
 */
case class RequestRowCustomer(id: Long, requestRowId: Long, productId: Long, productName: String,
  customerId: Long, customerName: String, quantity: Int,
  price: Double, totalPrice: Double, paid: Double, credit: Double, status: String,
  measureId: Long, measureName: String, type_1: String, observation: String)

object RequestRowCustomer {
  implicit val RequestRowCustomerFormat = Json.format[RequestRowCustomer]
}