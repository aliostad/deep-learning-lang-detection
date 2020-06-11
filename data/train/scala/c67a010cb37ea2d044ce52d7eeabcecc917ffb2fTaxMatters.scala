/*
 * Copyright 2017 HM Revenue & Customs
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package models.fe.businessactivities

import models.des.businessactivities.MlrAdvisorDetails
import play.api.libs.json.{JsSuccess, Writes, _}

case class TaxMatters(manageYourTaxAffairs: Boolean)

object TaxMatters {

  implicit val formats = Json.format[TaxMatters]

  implicit val jsonReads: Reads[TaxMatters] =
    (__ \ "manageYourTaxAffairs").read[Boolean] flatMap {
      case bool => Reads(_ => JsSuccess(TaxMatters(bool)))
    }

  implicit val jsonWrites = Writes[TaxMatters] {
    case TaxMatters(bool) => Json.obj("manageYourTaxAffairs" -> bool)
  }

  implicit def conv(advisor : Option[MlrAdvisorDetails]) : Option[TaxMatters] = {
    advisor match {
      case Some(data) => Some(TaxMatters(data.agentDealsWithHmrc))
      case None => None
    }

  }
}
