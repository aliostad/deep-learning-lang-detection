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
package helpers.servicemocks

import helpers.{ComponentSpecBase, WiremockHelper}
import play.api.http.Status

object BtaPartialStub extends ComponentSpecBase {

  def stubGetServiceInfoPartial(): Unit = {
    WiremockHelper.stubGet(btaPartialUrl, Status.OK,
      s"""
         |    <a id="service-info-home-link"
         |       class="service-info__item service-info__left font-xsmall button button--link button--link-table button--small soft-half--sides"
         |       data-journey-click="Header:Click:Home"
         |       href="/business-account">
         |      Business tax home
         |      </a>
         |  <ul id="service-info-list"
         |      class="service-info__item service-info__right list--collapse">
         |
         |    <li class="list__item">
         |      <span id="service-info-user-name" class="bold-xsmall">Albert Einstein</span>
         |    </li>
         |
         |    <li class="list__item soft--left">
         |      <a id="service-info-manage-account-link"
         |         href="/business-account/manage-account"
         |        data-journey-click="Header:Click:ManageAccount">
         |        Manage account
         |      </a>
         |    </li>
         |    <li class="list__item soft--left">
         |      <a id="service-info-messages-link"
         |         href="/business-account/messages"
         |        data-journey-click="Header:Click:Messages">
         |        Messages
         |      </a>
         |    </li>
         |  </ul>
       """.stripMargin)
  }
}
