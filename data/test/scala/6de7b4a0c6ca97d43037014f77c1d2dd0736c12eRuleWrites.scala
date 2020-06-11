package models.writes

import models.{Action, Condition, Rule}
import play.api.libs.json._
import play.api.libs.functional.syntax._

trait RuleWrites {

  implicit val conditionWrites: Writes[Condition] = (
    (JsPath \ "type").write[String] and
    (JsPath \ "attribute").write[String] and
    (JsPath \ "value").writeNullable[String]
   )(unlift(Condition.unapply))

  implicit val actionWrites: Writes[Action] = (
    (JsPath \ "function").write[String] and
    (JsPath \ "attribute").write[String] and
    (JsPath \ "value").write[String]
   )(unlift(Action.unapply))

  implicit val ruleWrites: Writes[Rule] = (
    (JsPath \ "id").write[Long] and
    (JsPath \ "conditions").write[List[Condition]] and
    (JsPath \ "actions").write[List[Action]] and
    (JsPath \ "rulesToExclude").write[List[Long]]
   )(unlift(Rule.unapply))

}
