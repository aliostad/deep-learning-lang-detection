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

package controllers

import config.ApplicationConfig
import connectors.{Authenticated, DraftCases}
import models._
import org.jsoup.Jsoup
import org.jsoup.nodes.Document
import org.scalacheck.Arbitrary.arbitrary
import play.api.inject.guice.GuiceApplicationBuilder
import play.api.test.FakeRequest
import play.api.test.Helpers._
import resources._
import utils._

import scala.collection.JavaConverters._

class ManagePropertiesSpec extends ControllerSpec {

  override val additionalAppConfig = Seq("featureFlags.searchSortEnabled" -> "false")

  //Make the tests run significantly faster by only loading and parsing the default case, of 15 property links, once
  lazy val defaultHtml = {
    setup()

    val res = TestDashboardController.manageProperties(1, 15)(FakeRequest())
    status(res) mustBe OK

    Jsoup.parse(contentAsString(res))
  }

  "The manage properties page" must "display the address for each of the user's first 15 properties" in {
    val html = defaultHtml
    val addresses = StubPropertyLinkConnector.stubbedLinks.map(_.address)

    checkTableColumn(html, 0, "Address", addresses)
  }

  it must "display the BA reference for each of the user's first 15 properties" in {
    val html = defaultHtml
    val baRefs = StubPropertyLinkConnector.stubbedLinks.map(_.assessments.head.billingAuthorityReference)

    checkTableColumn(html, 1, "Local authority reference", baRefs)
  }

  it must "display the link status, and the submission ID if the link is pending, for each of the user's first 15 properties" in {
    val html = defaultHtml
    val statuses = StubPropertyLinkConnector.stubbedLinks.map {
      case l if l.pending => s"Pending submission ID: ${l.submissionId}"
      case _ => "Approved"
    }

    checkTableColumn(html, 2, "Status", statuses)
  }

  it must "display the appointed agents for each of the user's first 15 properties" in {
    val html = defaultHtml
    val agents = StubPropertyLinkConnector.stubbedLinks.map {
      case l if l.agents.nonEmpty => l.agents.map(_.organisationName) mkString " "
      case _ => "None"
    }

    checkTableColumn(html, 3, "Appointed Agents", agents)
  }

  it must "display the available actions for each of the user's first 15 properties" in {
    val html = defaultHtml
    val actions = StubPropertyLinkConnector.stubbedLinks.map { l =>
      s"View valuations for ${l.address}"
    }

    checkTableColumn(html, 4, "Actions", actions)
  }

  it must "display the current page number" in {
    val html = defaultHtml

    html.select("ul.pagination li.active").text mustBe "1"
  }

  it must "include a 'next' link if there are more results" in {
    setup(numberOfLinks = 16)

    val res = TestDashboardController.manageProperties(1, 15)(FakeRequest())
    status(res) mustBe OK

    val html = Jsoup.parse(contentAsString(res))

    val nextLink = html.select("ul.pagination li.next")

    nextLink.hasClass("disabled") mustBe false withClue "'Next' link is incorrectly disabled"
    nextLink.select("a").attr("href") mustBe routes.Dashboard.manageProperties(2).url
  }

  it must "include an inactive 'next' link if there are no further results" in {
    setup(numberOfLinks = 16)

    val res = TestDashboardController.manageProperties(2, 15)(FakeRequest())
    status(res) mustBe OK

    val html = Jsoup.parse(contentAsString(res))

    val nextLink = html.select("ul.pagination li.next")

    nextLink.hasClass("disabled") mustBe true withClue "'Next' link is not disabled"
  }

  it must "include an inactive 'previous' link when on page 1" in {
    setup(numberOfLinks = 16)

    val res = TestDashboardController.manageProperties(1, 15)(FakeRequest())
    status(res) mustBe OK

    val html = Jsoup.parse(contentAsString(res))

    val previousLink = html.select("ul.pagination li.previous")

    previousLink.hasClass("disabled") mustBe true withClue "'Previous' link is not disabled"
  }

  it must "include a 'previous' link when not on page 1" in {
    setup(numberOfLinks = 16)

    val res = TestDashboardController.manageProperties(2, 15)(FakeRequest())
    status(res) mustBe OK

    val html = Jsoup.parse(contentAsString(res))

    val previousLink = html.select("ul.pagination li.previous")

    previousLink.hasClass("disabled") mustBe false withClue "'Previous' link is incorrectly disabled"
    previousLink.select("a").attr("href") mustBe routes.Dashboard.manageProperties(1).url
  }

  it must "include a link to add another property" in {
    val html = defaultHtml

    html.select("a#addAnotherProperty").attr("href") mustBe propertyLinking.routes.ClaimProperty.show.url
  }

  it must "tell the user they have no properties, if they have no properties to display" in {
    StubAuthentication.stubAuthenticationResult(Authenticated(Accounts(arbitrary[GroupAccount], arbitrary[DetailedIndividualAccount])))

    val res = TestDashboardController.manageProperties(1, 15)(FakeRequest())
    status(res) mustBe OK

    val html = Jsoup.parse(contentAsString(res))

    html.select("h2.heading-secondary").text mustBe "There are no properties to display."
    html.select("table") mustBe empty
  }

  it must "not display the 'Appoint agent' action if the user is acting as an agent on the property link" in {
    val groupAccount: GroupAccount = arbitrary[GroupAccount]
    val individualAccount: DetailedIndividualAccount = arbitrary[DetailedIndividualAccount]

    StubAuthentication.stubAuthenticationResult(Authenticated(Accounts(groupAccount, individualAccount)))

    val indirectLink = arbitrary[PropertyLink].retryUntil(_.organisationId != groupAccount.id).copy(agents = Seq(arbitrary[Party].copy(organisationId = groupAccount.id)))
    StubPropertyLinkConnector.stubLink(indirectLink)

    val res = TestDashboardController.manageProperties(1, 15)(FakeRequest())
    status(res) mustBe OK

    val html = Jsoup.parse(contentAsString(res))
    val actions = html.select("table#nojsManageProperties").select("tr").asScala.drop(1).map(_.select("td").last.text.toUpperCase)

    actions must contain theSameElementsAs Seq(s"View valuations for ${indirectLink.address}".toUpperCase)
  }

  it must "include pagination controls" in {
    pending
    val html = defaultHtml

    val pageSizeControls = html.select("ul.pageLength li").asScala

    pageSizeControls must have size 4
    pageSizeControls.head.text mustBe "15"

    val managePropertiesLink: Int => String = n => routes.Dashboard.manageProperties(pageSize = n).url

    pageSizeControls.tail.map(_.select("a").attr("href")) must contain theSameElementsAs Seq(managePropertiesLink(25), managePropertiesLink(50), managePropertiesLink(100))
  }

  private def setup(numberOfLinks: Int = 15) = {
    val groupAccount: GroupAccount = arbitrary[GroupAccount]
    val individualAccount: DetailedIndividualAccount = arbitrary[DetailedIndividualAccount]

    StubAuthentication.stubAuthenticationResult(Authenticated(Accounts(groupAccount, individualAccount)))
    val links = (1 to numberOfLinks) map { _ =>
      arbitrary[PropertyLink].copy(organisationId = groupAccount.id)
    }

    StubPropertyLinkConnector.stubLinks(links)
  }

  private def checkTableColumn(html: Document, index: Int, heading: String, values: Seq[String]) = {
    html.select("table#nojsManageProperties").select("th").get(index).text mustBe heading

    val data = html.select("table#nojsManageProperties").select("tr").asScala.drop(1).map(_.select("td").get(index).text.toUpperCase)

    values foreach { v => data must contain (v.toUpperCase) }
  }

  private object TestDashboardController extends Dashboard(app.injector.instanceOf[ApplicationConfig], mock[DraftCases],
    StubPropertyLinkConnector, StubAuthentication)
}
