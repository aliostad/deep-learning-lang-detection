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

package services

import assets.TestConstants.ServiceInfoPartial._
import config.FrontendAppConfig
import mocks.connectors.MockServiceInfoPartialConnector
import org.jsoup.Jsoup
import play.api.i18n.MessagesApi
import play.twirl.api.Html
import utils.TestSupport

class ServiceInfoPartialServiceSpec extends TestSupport with MockServiceInfoPartialConnector{

  object TestServiceInfoPartialService
    extends ServiceInfoPartialService()(
      app.injector.instanceOf[FrontendAppConfig],
      app.injector.instanceOf[MessagesApi],
      mockServiceInfoPartialConnector
    )

  "The ServiceInfoPartialService.serviceInfoPartial" when {
    "valid HTML is retrieved from the connector" should {
      "return the expected HMTL" in {
        setupMockGetServiceInfoPartial()(serviceInfoPartialSuccess)
        await(TestServiceInfoPartialService.serviceInfoPartial()) shouldBe serviceInfoPartialSuccess
      }
    }
    "no HTML is retrieved from the connector" should {

      setupMockGetServiceInfoPartial()(Html(""))

      val result = await(TestServiceInfoPartialService.serviceInfoPartial()).toString()
      val document = Jsoup.parse(result.toString)

      "return the fallback HTML" which {

        "has the 'Business taxnhome' link" in {
          val link = document.getElementById("service-info-home-link")
          link.text shouldBe "Business tax home"
          link.attr("href") should endWith ("/business-account")
        }

        "displays the user's name" in {
          document.getElementById("service-info-user-name").text shouldBe "Test User"
        }

        "has the 'Manage Account' link" in {
          val link = document.getElementById("service-info-manage-account-link")
          link.text shouldBe "Manage account"
          link.attr("href") should endWith ("business-account/manage-account")
        }

        "has the 'Messages' link" in {
          val link = document.getElementById("service-info-messages-link")
          link.text shouldBe "Messages"
          link.attr("href") should endWith ("business-account/messages")
        }
      }
    }
  }
}
