package writes

import java.sql.Timestamp

import models.{GameBetBonusCell, GameBetBonusRow, GameBetBuyCell, GameBetBuyRow}
import play.api.libs.functional.syntax._
import play.api.libs.json.{JsPath, Writes}

/**
  * Created by Damon on 16/6/15.
  */
trait BonusWrites {

  implicit val gameBetBonusCellWrites: Writes[GameBetBonusCell] = (
      (JsPath \ "gameWay").write[Int] and
      (JsPath \ "campName").write[String] and
      (JsPath \ "raceName").write[String] and
      (JsPath \ "userName").write[String] and
      (JsPath \ "price").write[Int] and
      (JsPath \ "quantity").write[Int] and
      (JsPath \ "bonus").write[Int] and
      (JsPath \ "limitedAppoint").write[String] and
      (JsPath \ "homingSection").write[String] and
      (JsPath \ "featherColor").write[String] and
      (JsPath \ "oddOrEven").write[String] and
      (JsPath \ "createdAt").write[Timestamp]
    )(unlift(GameBetBonusCell.unapply))

  implicit val gameBetBonusRowWrites: Writes[GameBetBonusRow] = (
    (JsPath \ "total").write[Int] and
      (JsPath \ "rows").write[Seq[GameBetBonusCell]]
    )(unlift(GameBetBonusRow.unapply))

  implicit val gameBetBuyCellWrites: Writes[GameBetBuyCell] = (
    (JsPath \ "gameWay").write[Int] and
      (JsPath \ "campName").write[String] and
      (JsPath \ "raceName").write[String] and
      (JsPath \ "userName").write[String] and
      (JsPath \ "price").write[Int] and
      (JsPath \ "quantity").write[Int] and
      (JsPath \ "limitedAppoint").write[String] and
      (JsPath \ "homingSection").write[String] and
      (JsPath \ "featherColor").write[String] and
      (JsPath \ "oddOrEven").write[String] and
      (JsPath \ "createdAt").write[Timestamp]
    )(unlift(GameBetBuyCell.unapply))

  implicit val gameBetBuyRowWrites: Writes[GameBetBuyRow] = (
    (JsPath \ "total").write[Int] and
      (JsPath \ "rows").write[Seq[GameBetBuyCell]]
    )(unlift(GameBetBuyRow.unapply))

}
