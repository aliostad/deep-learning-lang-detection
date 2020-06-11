package views.utils

import play.api.libs.json._
import play.api.libs.functional.syntax._

import models._

object JSONConverter {
  
  /**
   * Item JSON mapping
   */
  implicit val itemWrites: Writes[Item] = (
    (JsPath \ "id").write[Long] and
    (JsPath \ "userId").write[Long] and
		(JsPath \ "parentItemId").write[Option[Long]] and
		(JsPath \ "name").write[String] and
    (JsPath \ "model").write[String]
  )(unlift(Item.unapply))

//  implicit val itemReads: Reads[Item] = (
//    (JsPath \ "id").write[Long] and
//    (JsPath \ "userId").write[Long] and
//		(JsPath \ "parentItemId").write[Option[Long]] and
//		(JsPath \ "name").write[String] and
//    (JsPath \ "model").write[String]
//  )(Item.apply _)  
  
  /**
   * Tag JSON mapping
   */
  implicit val tagWrites: Writes[Tag] = (
    (JsPath \ "id").write[Long] and
    (JsPath \ "name").write[String] 
  )(unlift(Tag.unapply))

//  implicit val tagReads: Reads[Tag] = (
//    (JsPath \ "id").write[Long] and
//    (JsPath \ "name").write[String] 
//  )(Tag.apply _)
  
  /**
   * User JSON mapping
   */
  implicit val userWrites: Writes[User] = (
    (JsPath \ "id").write[Long] and
    (JsPath \ "login").write[String] and
    (JsPath \ "security").write[String]
  )(unlift(User.unapply))

//  implicit val locationReads: Reads[User] = (
//    (JsPath \ "id").write[Long] and
//    (JsPath \ "login").write[String] and
//    (JsPath \ "security").write[String]
//  )(User.apply _)
  
  /**
   * Value JSON mapping
   */ 
  implicit val valueWrites: Writes[Value] = (
    (JsPath \ "id").write[Long] and
    (JsPath \ "itemId").write[Long] and
    (JsPath \ "tagId").write[Long] and 
		(JsPath \ "value").write[String] and
	  (JsPath \ "model").write[String] 
  )(unlift(Value.unapply))

//  implicit val valueReads: Reads[Value] = (
//    (JsPath \ "id").write[Long] and
//    (JsPath \ "itemId").write[Long] and
//    (JsPath \ "tagId").write[Long] and 
//		(JsPath \ "value").write[String] and
//	  (JsPath \ "model").write[String] 
//  )(Value.apply _)
}