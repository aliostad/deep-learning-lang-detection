package Models

import play.api.libs.json.{JsPath, Writes}
import play.api.libs.functional.syntax._

/**
  * Created by adeyemi on 1/30/17.
  */
case class Edge (id: String, source: String, target: String)
case class Node (id: String, label: String, x: Int, y: Int, size: Int)

object Edge{
  implicit val edgeWrites: Writes[Edge] = (
    (JsPath \ "id").write[String] and
      (JsPath \ "source").write[String] and
      (JsPath \ "target").write[String]
    )(unlift(Edge.unapply))
}

object Node{
  implicit val nodeWrites: Writes[Node] = (
    (JsPath \ "id").write[String] and
      (JsPath \ "label").write[String] and
      (JsPath \ "x").write[Int] and
      (JsPath \ "y").write[Int] and
      (JsPath \ "size").write[Int]
    )(unlift(Node.unapply))
}