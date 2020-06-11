package lib.argo.model

import java.net.URI

import lib.argo.WriteHelpers
import play.api.libs.functional.syntax._
import play.api.libs.json._


case class CollectionResponse[T](
  uri: Option[URI] = None,
  offset: Option[Long] = None,
  length: Option[Long],
  total: Option[Long] = None,
  data: Seq[T],
  links: List[Link] = List()
)

object CollectionResponse extends WriteHelpers {

  implicit def collectionResponseWrites[T: Writes]: Writes[CollectionResponse[T]] = (
    (__ \ "uri").writeNullable[String].contramap((_: Option[URI]).map(_.toString)) ~
      (__ \ "offset").writeNullable[Long] ~
      (__ \ "length").writeNullable[Long] ~
      (__ \ "total").writeNullable[Long] ~
      (__ \ "data").write[Seq[T]] ~
      (__ \ "links").writeNullable[List[Link]].contramap(someListOrNone[Link])
    )(unlift(CollectionResponse.unapply[T]))
}
