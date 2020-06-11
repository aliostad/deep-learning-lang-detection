package play.api.libs.context.json

import play.api.libs.context.functional.Show
import play.api.libs.json.{JsObject, Writes, Json, JsValue}

import scala.language.implicitConversions

object ShowJson {

  def asPrettyString[V: Writes]: Show[V] = Show.show(o => Json.prettyPrint(Json.toJson(o)))
}

trait ShowJsonSyntax {

  implicit def showWithJson(show: Show.type): ShowJson.type = ShowJson

  implicit def showJson[J <: JsValue]: Show[J] = {
    Show.show(Json.prettyPrint)
  }

  implicit def showMap[K: Show, V: Writes]: Show[Map[K, V]] = Show.show { m =>
    val json = JsObject(m.map {
      case (k, v) => (Show.asString(k), Json.toJson(v))
    })
    Json.prettyPrint(json)
  }
}
