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
import actions.AgentRequest
import controllers.{AgentInfo, ControllerSpec, ManageAgentsVM, routes}
import org.jsoup.Jsoup
import org.jsoup.nodes.Document
import play.api.i18n.Messages.Implicits._
import play.api.mvc.AnyContentAsEmpty
import play.api.test.FakeRequest
import resources._
import utils.HtmlPage

import scala.collection.JavaConverters._

class ManageAgentsPageSpec extends ControllerSpec {

  override val additionalAppConfig = Seq("featureFlags.searchSortEnabled" -> "false")


  "The manage agents page" must "show a message stating that no agents have been appointed if the user has no agents" in  {
    val html = views.html.dashboard.manageAgents(noAgents)
    val page = HtmlPage(html)
    page.mustContain1("#noAgents")
  }

  it must "not show this message when agent have been appointed" in {
    HtmlPage(manageAgentsPage).mustContain("#noAgents", 0)
  }

  it must "show each of the user's agent's name and code, and possible actions" in {
    val page = HtmlPage(manageAgentsPage)
    
    page.mustContain1("#agentsTable")
    page.mustContainTableHeader("Agent name", "Agent code", "Actions")
    twoAgents.agents map { x =>
      page.mustContainDataInRow(x.organisationName, x.agentCode.toString, "View managed properties")
      page.mustContainLink(".viewManagedProperties", routes.Dashboard.viewManagedProperties(x.agentCode).url)
    }
  }

  it must "show the dashboard navigation tabs at the top of the screen" in {
    val tabs = manageAgentsPage.select(".section-tabs ul[role=tablist] li").asScala
    tabs must have size 5
    tabs.init.map(_.select("a").attr("href")) must contain theSameElementsAs Seq(routes.Dashboard.manageProperties().url, routes.Dashboard.manageAgents().url, routes.Dashboard.viewDraftCases().url, controllers.manageDetails.routes.ViewDetails.show().url)
  }

  implicit lazy val request: AgentRequest[_] = AgentRequest(groupAccountGen.copy(isAgent = false), individualGen, positiveLong, FakeRequest("GET", "/business-rates-property-linking/properties"))
  lazy val noAgents = ManageAgentsVM(Nil)
  lazy val twoAgents = ManageAgentsVM(List(AgentInfo("name1", 111), AgentInfo("name2", 222)))

  lazy val manageAgentsPage: Document = {
    val html = views.html.dashboard.manageAgents(twoAgents)
    Jsoup.parse(html.toString)
  }
}
