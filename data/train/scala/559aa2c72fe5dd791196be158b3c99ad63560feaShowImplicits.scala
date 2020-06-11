package vep.model.show

import spray.json.RootJsonFormat
import vep.model.company.CompanyImplicits._

object ShowImplicits {
  implicit val impShowFormBody: RootJsonFormat[ShowFormBody] = jsonFormat(ShowFormBody.apply, "title", "author", "director", "company", "duration", "content")

  implicit val impShowSearchResult: RootJsonFormat[ShowSearchResult] = jsonFormat(ShowSearchResult, "canonical", "title", "author", "director", "company")

  implicit val impShowSearchResponse: RootJsonFormat[ShowSearchResponse] = jsonFormat(ShowSearchResponse, "shows", "pageMax")

  implicit val impShowDetail: RootJsonFormat[ShowDetail] = jsonFormat(ShowDetail.apply, "canonical", "title", "author", "director", "company", "duration", "content")
}
