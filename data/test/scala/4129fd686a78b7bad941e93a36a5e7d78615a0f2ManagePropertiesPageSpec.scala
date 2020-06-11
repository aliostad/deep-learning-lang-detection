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

package views.dashboard

import actions.{AuthenticatedRequest, BasicAuthenticatedRequest}
import controllers.{ControllerSpec, ManagePropertiesVM, Pagination, routes}
import models.{DetailedIndividualAccount, GroupAccount, PropertyLink}
import org.jsoup.Jsoup
import play.api.test.FakeRequest
import org.scalacheck.Arbitrary.arbitrary
import org.scalacheck.Gen
import resources._
import utils.HtmlPage
import play.api.i18n.Messages.Implicits._
import views.html.dashboard.manageProperties

import scala.collection.JavaConverters._

class ManagePropertiesPageSpec extends ControllerSpec {

  override val additionalAppConfig = Seq("featureFlags.searchSortEnabled" -> "false")

  "Manage properties page" must "show the submissionId if the property link is pending" in {
    val pendingProp = arbitrary[PropertyLink].sample.get.copy(
      organisationId = organisationAccount.id,
      pending = true
    )
    val approvedProp = arbitrary[PropertyLink].sample.get.copy(
      organisationId = organisationAccount.id,
      pending = false
    )

    val html = manageProperties(ManagePropertiesVM(organisationAccount.id, Seq(pendingProp, approvedProp), Pagination(1, 25, 25)))
    val page = HtmlPage(html)
    page.mustContain1(".submission-id")
  }

  it must "show the dashboard navigation tabs at the top of the screen" in {
    val page = Jsoup.parse(manageProperties(ManagePropertiesVM(organisationAccount.id, Nil, Pagination(1, 25, 25))).toString)
    val tabs = page.select(".section-tabs ul[role=tablist] li").asScala
    tabs must have size 5
    tabs.init.map(_.select("a").attr("href")) must contain theSameElementsAs Seq(routes.Dashboard.manageProperties().url, routes.Dashboard.manageAgents().url, routes.Dashboard.viewDraftCases().url, controllers.manageDetails.routes.ViewDetails.show().url)
  }

  implicit lazy val request = FakeRequest("GET", "/business-rates-property-linking/properties")
  lazy val organisationAccount: Gen[GroupAccount] = arbitrary[GroupAccount]
  lazy val individualAccount: Gen[DetailedIndividualAccount] = arbitrary[DetailedIndividualAccount]
  implicit lazy val basicAuthenticatedRequest: AuthenticatedRequest[_] = BasicAuthenticatedRequest(organisationAccount.copy(isAgent = false), individualAccount, request)
}
