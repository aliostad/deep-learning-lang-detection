package model.jsonTransformers

import model.Account

/**
 * Created by MICHAEL on 23/03/2015.
 */
object AccountWrites {

  import play.api.libs.json._
  import play.api.libs.functional.syntax._

  implicit val accountWrites: Writes[Account] = (
    (JsPath \ "accountId").writeNullable[String] and
      (JsPath \ "email").write[String] and
      (JsPath \ "title").writeNullable[String] and
      (JsPath \ "foreName").writeNullable[String] and
      (JsPath \ "familyName").writeNullable[String] and
      (JsPath \ "address").writeNullable[String] and
      (JsPath \ "country").write[String] and
      (JsPath \ "bmaNumber").writeNullable[String] and
      (JsPath \ "province").writeNullable[String] and
      (JsPath \ "organisation").writeNullable[String] and
      (JsPath \ "postalCode").writeNullable[String] and
      (JsPath \ "city").writeNullable[String] and
      (JsPath \ "telephone").writeNullable[String] and
      (JsPath \ "graduationYear").writeNullable[String] and
      (JsPath \ "specialties").writeNullable[List[String]] and
      (JsPath \ "professions").writeNullable[List[String]]
    )(unlift(Account.unapply))

}
