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

package views.details

import actions.BasicAuthenticatedRequest
import controllers.ControllerSpec
import models.{Address, DetailedIndividualAccount, GroupAccount}
import org.jsoup.Jsoup
import org.jsoup.nodes.{Document, Element}
import play.api.i18n.Messages.Implicits._
import play.api.test.FakeRequest
import resources._
import utils.Formatters

import scala.collection.JavaConverters._

class DetailsPageSpec extends ControllerSpec {

  behavior of "DetailsPage"

  it should "display, and allow the user to edit, their name, email, address, phone, or mobile number" in {
    val individualAccount: DetailedIndividualAccount = individualGen.retryUntil(_.details.phone2.isDefined)
    val groupAccount: GroupAccount = groupAccountGen
    val address: Address = addressGen
    implicit val request = BasicAuthenticatedRequest(groupAccount, individualAccount, FakeRequest())

    val html = Jsoup.parse(views.html.details.viewDetails(individualAccount, groupAccount, address, address).toString)
    val details = individualAccount.details

    val expectedRows: Seq[(String, String, String)] = Seq(
      ("Name", s"${details.firstName} ${details.lastName}", controllers.manageDetails.routes.UpdatePersonalDetails.viewName().url),
      ("Address", Formatters.capitalizedAddress(address), controllers.manageDetails.routes.UpdatePersonalDetails.viewAddress().url),
      ("Telephone", details.phone1, controllers.manageDetails.routes.UpdatePersonalDetails.viewPhone().url),
      ("Mobile number", details.phone2.get, controllers.manageDetails.routes.UpdatePersonalDetails.viewMobile().url),
      ("Email", details.email, controllers.manageDetails.routes.UpdatePersonalDetails.viewEmail().url)
    )

    val rows = getRows(html, "personalDetailsTable")

    expectedRows.foreach { r =>
      rows must contain (r)
    }
  }

  it should "display a placeholder value if the user's mobile number is not set" in {
    val individualAccount: DetailedIndividualAccount = individualGen.retryUntil(_.details.phone2.isEmpty)
    val groupAccount: GroupAccount = groupAccountGen
    val address: Address = addressGen
    implicit val request = BasicAuthenticatedRequest(groupAccount, individualAccount, FakeRequest())

    val html = Jsoup.parse(views.html.details.viewDetails(individualAccount, groupAccount, address, address).toString)

    val rows = getRows(html, "personalDetailsTable")
    rows must contain (("Mobile number", "Not set", controllers.manageDetails.routes.UpdatePersonalDetails.viewMobile().url))
  }

  it should "display the business's agent code if they are an agent" in {
    val individualAccount: DetailedIndividualAccount = individualGen
    val groupAccount: GroupAccount = groupAccountGen.retryUntil(_.isAgent)
    val address: Address = addressGen
    implicit val request = BasicAuthenticatedRequest(groupAccount, individualAccount, FakeRequest())

    val html = Jsoup.parse(views.html.details.viewDetails(individualAccount, groupAccount, address, address).toString)

    val rows = getRows(html, "businessDetailsTable")
    rows must contain (("Agent code", groupAccount.agentCode.toString, ""))
  }

  it should "not display the business's agent code if they are not an agent" in {
    val individualAccount: DetailedIndividualAccount = individualGen
    val groupAccount: GroupAccount = groupAccountGen.retryUntil(!_.isAgent)
    val address: Address = addressGen
    implicit val request = BasicAuthenticatedRequest(groupAccount, individualAccount, FakeRequest())

    val html = Jsoup.parse(views.html.details.viewDetails(individualAccount, groupAccount, address, address).toString)

    val rows = getRows(html, "businessDetailsTable")
    rows must not contain (("Agent code", groupAccount.agentCode.toString, ""))
  }

  it should "display, and allow the user to edit, the business's name, address, email, and phone number" in {
    val individualAccount: DetailedIndividualAccount = individualGen
    val groupAccount: GroupAccount = groupAccountGen
    val address: Address = addressGen
    implicit val request = BasicAuthenticatedRequest(groupAccount, individualAccount, FakeRequest())

    val html = Jsoup.parse(views.html.details.viewDetails(individualAccount, groupAccount, address, address).toString)

    val expectedRows = Seq(
      ("Business name", groupAccount.companyName, controllers.manageDetails.routes.UpdateOrganisationDetails.viewBusinessName().url),
      ("Business address", Formatters.capitalizedAddress(address), controllers.manageDetails.routes.UpdateOrganisationDetails.viewBusinessAddress().url),
      ("Business telephone", groupAccount.phone, controllers.manageDetails.routes.UpdateOrganisationDetails.viewBusinessPhone().url),
      ("Business email", groupAccount.email, controllers.manageDetails.routes.UpdateOrganisationDetails.viewBusinessEmail().url)
    )
    val rows = getRows(html, "businessDetailsTable")

    expectedRows foreach { r =>
      rows must contain (r)
    }
  }

  private def getRows(html: Document, tableId: String) = {
    html.select(s"#$tableId tr").asScala.map { e => (e.select("td").get(0).text, e.select("td").get(1).text, getUpdateUrl(e)) }
  }

  private def getUpdateUrl(e: Element) = {
    Option(e.select("td a")).fold("")(_.attr("href"))
  }

}
