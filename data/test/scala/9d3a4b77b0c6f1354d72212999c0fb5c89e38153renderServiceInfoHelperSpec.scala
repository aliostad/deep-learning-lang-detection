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

package views.helpers

import assets.Messages.{BtaServiceInfoHeader => messages}
import assets.TestConstants.{testMtdItUser, testMtdItUserNoUserDetails, testUserName}
import auth.MtdItUser
import config.FrontendAppConfig
import org.jsoup.Jsoup
import play.api.i18n.Messages.Implicits._
import play.twirl.api.Html
import utils.TestSupport
import views.html.helpers.renderServiceInfoHelper

class renderServiceInfoHelperSpec extends TestSupport {

  lazy val appConfig = app.injector.instanceOf[FrontendAppConfig]

  def html(user: Option[MtdItUser]): Html = renderServiceInfoHelper(user)(
    applicationMessages,
    appConfig
  )

  "The renderServiceInfoHelper" when {

    "user details are passed to it" should {

      lazy val document = Jsoup.parse(html(Some(testMtdItUser)).body)

      "render the user name" in {
        document.getElementById("service-info-user-name").text() shouldBe testUserName
      }

      "have a link to BTA home" which {

        lazy val homeLink = document.getElementById("service-info-home-link")

        s"should have the text '${messages.btaHome}'" in {
          homeLink.text() shouldBe messages.btaHome
        }

        s"should have a link to '${appConfig.businessTaxAccount}'" in {
          homeLink.attr("href") shouldBe appConfig.businessTaxAccount
        }

      }

      "have a link to Manage Account" which {

        lazy val manageAccountLink = document.getElementById("service-info-manage-account-link")

        s"should have the text '${messages.btaManageAccount}'" in {
          manageAccountLink.text() shouldBe messages.btaManageAccount
        }

        s"should have a link to '${appConfig.businessTaxAccount}'" in {
          manageAccountLink.attr("href") shouldBe appConfig.btaManageAccountUrl
        }

      }

      "have a link to Messages" which {

        lazy val messagesLink = document.getElementById("service-info-messages-link")

        s"should have the text '${messages.btaMessages}'" in {
          messagesLink.text() shouldBe messages.btaMessages
        }

        s"should have a link to '${appConfig.btaMessagesUrl}'" in {
          messagesLink.attr("href") shouldBe appConfig.btaMessagesUrl
        }

      }
    }

    "no user details are passed to it" should {

      lazy val document = Jsoup.parse(html(Some(testMtdItUserNoUserDetails)).body)

      "Not render the service-info-user-name" in {
        document.getElementById("service-info-user-name") shouldBe null
      }
    }
  }
}
