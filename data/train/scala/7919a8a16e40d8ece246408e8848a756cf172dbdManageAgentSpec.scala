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
import connectors._
import models._
import org.scalacheck.Arbitrary.arbitrary
import play.api.test.FakeRequest
import play.api.test.Helpers._
import resources._
import utils._

class ManageAgentSpec extends ControllerSpec {
  implicit val request = FakeRequest()

  object TestDashboardController extends Dashboard(app.injector.instanceOf[ApplicationConfig], mock[DraftCases],
    StubPropertyLinkConnector, StubAuthentication)

  "Manage Agents page" must "return Ok" in {
    val link = arbitrary[PropertyLink].sample.get
    val organisation = arbitrary[GroupAccount].sample.get
    val person = arbitrary[DetailedIndividualAccount].sample.get

    StubAuthentication.stubAuthenticationResult(Authenticated(Accounts(organisation, person)))
    StubPropertyLinkConnector.stubLink(link)

    val res = TestDashboardController.manageAgents()(FakeRequest())
    status(res) mustBe OK
  }

}
