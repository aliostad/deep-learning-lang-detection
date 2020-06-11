package oldModel

import play.api.libs.json._
import play.api.libs.functional.syntax._
import reactivemongo.bson._
import services.dao.UtilBson

case class OldColumn(
  title: String,
  unifiedRequests: Seq[OldUnifiedRequest],
  index: Int,
  width: Int,
  height: Int) {

  override def equals(other: Any) = other match {
    case that: OldColumn => that.title == title
    case _ => false
  }
}

object OldColumn {

  def fromBSON(c: BSONDocument) = {
    val unifiedRequests = UtilBson.tableTo[OldUnifiedRequest](c, "unifiedRequests", { r =>
      val requestArgs = r.getAs[BSONDocument]("args").get
      val args = requestArgs.elements.toList.map(n => (n._1, requestArgs.getAs[String](n._1).get)).toMap
      OldUnifiedRequest(r.getAs[String]("service").get, if (args.nonEmpty) Some(args) else None)
    })
    OldColumn(c.getAs[String]("title").get, unifiedRequests,
      c.getAs[Int]("index").get, c.getAs[Int]("width").get, c.getAs[Int]("height").get)
  }
  
}