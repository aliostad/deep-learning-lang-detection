package models

import scala.reflect.io.{Directory, File}
import play.api.libs.json.{JsArray, JsValue, JsObject, Json}
import scalax.io.Resource
import java.util.UUID
import scala.io.Source
import java.io

/**
 * Created with IntelliJ IDEA.
 * @author <a href="mailto:wstarcev@gmail.com">Vasilii Startsev</a>
 *         Date: 25.08.13
 *         Time: 19:10
 */

case class Lot(
                id:String,
                title:String,
                location : Location,
                rooms : Int,
                level : Int,
                square: Int,
                spaces:List[Space],
                pets:String,
                manageCo:String,
                communications:String,
                counters:String,
                phone:String, //owner phone
                sub_conditions:String,
                price:String
              )

object Lot {
  def fromJson(obj:JsValue) : Lot =
    Lot(
      (obj \ "id").as[String],
      (obj \ "title").as[String],
      Location.fromJson(obj \ "location"),
      (obj \ "rooms").as[Int],
      (obj \ "level").as[Int],
      (obj \ "square").as[Int],
      (obj \ "spaces").as[Seq[JsObject]].collect{
        case s : JsObject => Space.fromJson(s)
      }.toList,
      (obj \ "pets").as[String],
      (obj \ "manageCo").as[String],
      (obj \ "communications").as[String],
      (obj \ "counters").as[String],
      (obj \ "phone").as[String],
      (obj \ "sub_conditions").as[String],
      (obj \ "price").as[String]
    )

  def toJson(obj:Lot) : JsValue =
    JsObject(Seq(
      "id" -> Json.toJson(obj.id),
      "title" -> Json.toJson(obj.title),
      "location" -> Location.toJson(obj.location),
      "rooms" -> Json.toJson(obj.rooms),
      "level" -> Json.toJson(obj.level),
      "square" -> Json.toJson(obj.square),
      "spaces" -> JsArray(obj.spaces.collect {
        case space: Space => Space.toJson(space)
      }.toSeq),
      "pets" -> Json.toJson(obj.pets),
      "manageCo" -> Json.toJson(obj.manageCo),
      "communications" -> Json.toJson(obj.communications),
      "counters" -> Json.toJson(obj.counters),
      "phone" -> Json.toJson(obj.phone),
      "sub_conditions" -> Json.toJson(obj.sub_conditions),
      "price" -> Json.toJson(obj.price)
    ))

  def empty: Lot =
    Lot(
      UUID.randomUUID().toString, "Untitled",
      Location("59.95", "30.30", Address("", "", "", "")),
      1, 2, 3,
      List(Space("main", "30"), Space("entry", "10"), Space("coock", "12")),
      "true",
      "", "", "", "", "", ""
    )

  def store(obj:Lot) = {
    val path = "./lot/" + obj.id + "/info.json"
    val jsonObject = toJson(obj)
    val text = Json.stringify(jsonObject)
    if (new java.io.File(path).exists)
      new java.io.File(path).delete
    Resource.fromFile(path).write(text)
  }

  def all : List[Lot] = {
    val list : List[Lot] = new File(new java.io.File("./lot")).toDirectory.dirs.collect[String] {
      case d: Directory => d.name
    }.toList.collect{
      case id: String =>
        val path = "./lot/" + id + "/info.json"
        if (new io.File(path).exists()) fromJson(
          Json.parse(Source.fromFile(path).mkString)
        ) else
          empty.copy(id = id)
    }.toList
    if (list.isEmpty) List[Lot](empty)
    else list
  }

  def byId(id:String) : Lot = {
    val path = "./lot/" + id + "/info.json"
    if (new io.File(path).exists()) fromJson(Json.parse(Source.fromFile(path).mkString))
    else empty.copy(id = id)
  }
}
