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

package mocks.services

import auth.MtdItUser
import config.FrontendAppConfig
import models.UserDetailsModel
import org.mockito.Mockito._
import org.scalatest.BeforeAndAfterEach
import org.scalatest.mockito.MockitoSugar
import play.api.i18n.Messages
import play.twirl.api.Html
import services.ServiceInfoPartialService
import uk.gov.hmrc.play.http.HeaderCarrier
import uk.gov.hmrc.play.partials.HeaderCarrierForPartials
import uk.gov.hmrc.play.test.UnitSpec


trait MockServiceInfoPartialService extends UnitSpec with MockitoSugar with BeforeAndAfterEach {

  implicit val hcwc = HeaderCarrierForPartials(HeaderCarrier(), "")
  implicit val appConfig: FrontendAppConfig = mock[FrontendAppConfig]
  implicit val user: MtdItUser = MtdItUser(
    mtditid = "12341234",
    nino = "AA123456A",
    userDetails =
      Some(
        UserDetailsModel(
          name = "Test User",
          email = None,
          affinityGroup = "",
          credentialRole = ""
        )
      )
  )
  implicit val messages: Messages = mock[Messages]

  val mockServiceInfoPartialService: ServiceInfoPartialService = mock[ServiceInfoPartialService]

  override def beforeEach(): Unit = {
    super.beforeEach()
    reset(mockServiceInfoPartialService)
  }

  def setupMockServiceInfoPartial()(response: Html): Unit =
    when(mockServiceInfoPartialService.serviceInfoPartial())
    .thenReturn(response)

  def mockServiceInfoPartialSuccess(): Unit = setupMockServiceInfoPartial()(
    Html("""
    <a id="service-info-home-link"
       class="service-info__item service-info__left font-xsmall button button--link button--link-table button--small soft-half--sides"
       data-journey-click="Header:Click:Home"
       href="/business-account">
      Business tax home
      </a>
  <ul id="service-info-list"
      class="service-info__item service-info__right list--collapse">

    <li class="list__item">
      <span id="service-info-user-name" class="bold-xsmall">TestUser</span>
    </li>

    <li class="list__item soft--left">
      <a id="service-info-manage-account-link"
         href="/business-account/manage-account"
        data-journey-click="Header:Click:ManageAccount">
        Manage account
      </a>
    </li>
    <li class="list__item soft--left">
      <a id="service-info-messages-link"
         href="/business-account/messages"
        data-journey-click="Header:Click:Messages">
        Messages
      </a>
    </li>
  </ul>
  """)
  )

  def mockServiceInfoPartialError(): Unit = setupMockServiceInfoPartial()(Html(""))

}
