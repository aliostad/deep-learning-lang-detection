package models

import play.api.libs.json.Writes
import play.api.libs.json._
import org.squeryl.{Schema, KeyedEntity}

case class OldFund (id: Long, name: String, quantity: Long, value: Long, buyValue: Long) extends KeyedEntity[Long]

object OldFund {

  var funds = Set(
    OldFund(1, "Water Total Refund", 1210L, 100L, 78L),
    OldFund(2, "Best Ever Invest", 67L, 534L, 800L)
  )

  def findAll = this.funds.toList

  /*
  implicit object FundWrites extends Writes[Fund] {
    def writes (f: Fund) = Json.obj (
       "id" -> Json.toJson(f.id),
       "name" -> Json.toJson(f.name),
       "quantity" -> Json.toJson(f.quantity),
       "value" -> Json.toJson(f.value),
       "buyValue" -> Json.toJson(f.buyValue)
    )


  }
   */

}



