package business.rating

import common.MyWriteable
import play.api.libs.json.{Format, Json}

/**
  * Created by klaus on 01.06.17.
  */
case class RatingModel(
    id: Long,
    liked: Boolean,
    testimonial: Option[String]
) {
    def toWriteModel: RatingWriteModel = RatingWriteModel(id = Some(id), liked = liked, testimonial = testimonial)
}

object RatingModel extends MyWriteable[RatingModel] {

    implicit val formatter: Format[RatingModel] = Json.format[RatingModel]

}

case class RatingWriteModel(
    id: Option[Long] = None,
    liked: Boolean = false,
    testimonial: Option[String] = None
)

object RatingWriteModel extends MyWriteable[RatingWriteModel] {

    implicit val formatter: Format[RatingWriteModel] = Json.format[RatingWriteModel]

}
