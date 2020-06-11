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

package models.businessactivities

import org.scalatestplus.play.PlaySpec
import jto.validation.{Invalid, Path, Valid, ValidationError}
import jto.validation.ValidationError
import play.api.libs.json.{JsPath, Json, JsSuccess}

class TaxMattersSpec extends PlaySpec {

  "Json reads and writes" must {
    "successfully complete a round trip json conversion" in {
      TaxMatters.formats.reads(
        TaxMatters.formats.writes(TaxMatters(false))
      ) must be(JsSuccess(TaxMatters(false), JsPath \ "manageYourTaxAffairs"))
    }

    "Serialise TaxMatters as expected" in {
      Json.toJson(TaxMatters(false)) must be(Json.obj("manageYourTaxAffairs" -> false))
    }

    "Deserialise TaxMatters as expected" in {
      val json = Json.obj("manageYourTaxAffairs" -> false)
      json.as[TaxMatters] must be(TaxMatters(false))
    }
  }

  "Form Validation" must {
    "pass" when {
      "yes option is picked" in {
        TaxMatters.formRule.validate(Map("manageYourTaxAffairs" -> Seq("true"))) must be(Valid(TaxMatters(true)))
      }
      "no option is picked" in {
        TaxMatters.formRule.validate(Map("manageYourTaxAffairs" -> Seq("false"))) must be(Valid(TaxMatters(false)))
      }
    }
    "fail" when {
      "neither option is picked, represented by an empty map" in {
        TaxMatters.formRule.validate(Map.empty) must be(Invalid(Seq(
          (Path \ "manageYourTaxAffairs") -> Seq(ValidationError("error.required.ba.tax.matters")))))
      }
      "neither option is picked, represented by an empty string" in {
        TaxMatters.formRule.validate(Map("manageYourTaxAffairs" -> Seq(""))) must be(Invalid(Seq(
          (Path \ "manageYourTaxAffairs") -> Seq(ValidationError("error.required.ba.tax.matters")))))
      }
      "an invalid value is passed" in {
        TaxMatters.formRule.validate(Map("manageYourTaxAffairs" -> Seq("random"))) must be(Invalid(Seq(
          (Path \ "manageYourTaxAffairs") -> Seq(ValidationError("error.required.ba.tax.matters")))))
      }
    }
  }

  "Form Writes" must {
    "Write true into form" in {
      TaxMatters.formWrites.writes(TaxMatters(true)) must be(Map("manageYourTaxAffairs" -> Seq("true")))
    }
    "Write false into form" in {
      TaxMatters.formWrites.writes(TaxMatters(false)) must be(Map("manageYourTaxAffairs" -> Seq("false")))
    }
  }

}
