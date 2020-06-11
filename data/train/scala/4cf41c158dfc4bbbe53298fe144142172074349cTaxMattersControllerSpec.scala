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

package controllers.businessactivities

import connectors.DataCacheConnector
import models.businessactivities.{BusinessActivities, TaxMatters}
import org.jsoup.Jsoup
import org.jsoup.nodes.Document
import org.mockito.Matchers._
import org.mockito.Mockito._
import org.scalatest.concurrent.ScalaFutures
import org.scalatest.mock.MockitoSugar
import  utils.GenericTestHelper
import play.api.i18n.Messages
import play.api.libs.json.Json
import play.api.test.Helpers._
import uk.gov.hmrc.http.cache.client.CacheMap
import utils.AuthorisedFixture

import scala.concurrent.Future

class TaxMattersControllerSpec extends GenericTestHelper with MockitoSugar with ScalaFutures{

  trait Fixture extends AuthorisedFixture {
    self => val request = addToken(authRequest)

    val controller = new TaxMattersController {
      override val dataCacheConnector: DataCacheConnector = mock[DataCacheConnector]
      override val authConnector = self.authConnector
    }
  }

  "TaxMattersController" when {

    "get is called" must {
      "display the 'Manage Your Tax Affairs?' page with an empty form" in new Fixture {

        when(controller.dataCacheConnector.fetch[BusinessActivities](any())(any(), any(), any()))
          .thenReturn(Future.successful(None))

        val result = controller.get()(request)
        status(result) must be(OK)

        val page = Jsoup.parse(contentAsString(result))

        page.getElementById("manageYourTaxAffairs-true").hasAttr("checked") must be(false)
        page.getElementById("manageYourTaxAffairs-false").hasAttr("checked") must be(false)
      }

      "display the 'Manage Your Tax Affairs?' page with pre populated data if found in cache" in new Fixture {

        when(controller.dataCacheConnector.fetch[BusinessActivities](any())(any(), any(), any()))
          .thenReturn(Future.successful(Some(BusinessActivities(taxMatters = Some(TaxMatters(true))))))

        val result = controller.get()(request)
        status(result) must be(OK)

        val page = Jsoup.parse(contentAsString(result))

        page.getElementById("manageYourTaxAffairs-true").hasAttr("checked") must be(true)
        page.getElementById("manageYourTaxAffairs-false").hasAttr("checked") must be(false)
      }
    }

    "post is called" must {
      "redirect to Check Your Answers on post with valid data" in new Fixture {
        val newRequest = request.withFormUrlEncodedBody(
          "manageYourTaxAffairs" -> "true"
        )

        when(
          controller.dataCacheConnector.fetch[BusinessActivities](any())(any(), any(), any())
        ).thenReturn(Future.successful(None))
        when(
          controller.dataCacheConnector.save[BusinessActivities](any(), any())(any(), any(), any())
        ).thenReturn(
          Future.successful(CacheMap(BusinessActivities.key, Map("" -> Json.obj())))
        )

        val result = controller.post()(newRequest)
        status(result) must be(SEE_OTHER)
        redirectLocation(result) must be(Some(routes.SummaryController.get().url))
      }

      "respond with Bad Request on post with invalid data" in new Fixture {
        val newRequest = request.withFormUrlEncodedBody(
          "manageYourTaxAffairs" -> "grrrrr"
        )

        val result = controller.post()(newRequest)
        status(result) must be(BAD_REQUEST)
        val document: Document = Jsoup.parse(contentAsString(result))
        document.select("span").html() must include(Messages("error.required.ba.tax.matters"))
      }

      "redirect to Check Your Answers on post with valid data in edit mode" in new Fixture {

        val newRequest = request.withFormUrlEncodedBody(
          "manageYourTaxAffairs" -> "true"
        )

        when(
          controller.dataCacheConnector.fetch[BusinessActivities](any())(any(), any(), any())
        ).thenReturn(Future.successful(None))

        when(
          controller.dataCacheConnector.save[BusinessActivities](any(), any())(any(), any(), any())
        ).thenReturn(
          Future.successful(CacheMap(BusinessActivities.key, Map("" -> Json.obj())))
        )

        val result = controller.post(true)(newRequest)
        status(result) must be(SEE_OTHER)
        redirectLocation(result) must be(Some(routes.SummaryController.get().url))
      }
    }
  }

  it must {
    "use correct services" in new Fixture {
      TaxMattersController.dataCacheConnector must be(DataCacheConnector)
    }
  }
}
