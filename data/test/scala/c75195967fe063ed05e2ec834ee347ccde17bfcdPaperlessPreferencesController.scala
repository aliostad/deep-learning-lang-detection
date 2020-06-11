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

import javax.inject.Inject

import config.ConfigDecorator
import connectors.{FrontEndDelegationConnector, PertaxAuditConnector, PertaxAuthConnector}
import controllers.auth.{AuthorisedActions, PertaxRegime}
import error.LocalErrorHandler
import models.ActiveTabYourAccount
import play.api.i18n.{Messages, MessagesApi}
import services.partials.PreferencesFrontendPartialService
import services.{CitizenDetailsService, PreferencesFrontendService, UserDetailsService}
import util.LocalPartialRetriever



class PaperlessPreferencesController @Inject() (
  val messagesApi: MessagesApi,
  val citizenDetailsService: CitizenDetailsService,
  val userDetailsService: UserDetailsService,
  val preferencesFrontendService: PreferencesFrontendService,
  val preferencesFrontendPartialService: PreferencesFrontendPartialService,
  val delegationConnector: FrontEndDelegationConnector,
  val auditConnector: PertaxAuditConnector,
  val authConnector: PertaxAuthConnector,
  val partialRetriever: LocalPartialRetriever,
  val configDecorator: ConfigDecorator,
  val pertaxRegime: PertaxRegime,
  val localErrorHandler: LocalErrorHandler
) extends PertaxBaseController with AuthorisedActions {

  def managePreferences = ProtectedAction(baseBreadcrumb, activeTab = Some(ActiveTabYourAccount)) {
    implicit pertaxContext =>
      showingWarningIfWelsh { implicit pertaxContext =>
        for {
          managePrefsPartial <- preferencesFrontendPartialService.getManagePreferencesPartial(configDecorator.pertaxFrontendHomeUrl, Messages("label.back_to_account_home"))
        } yield {
          Ok(views.html.preferences.managePrefs(managePrefsPartial.successfulContentOrEmpty))
        }
      }
  }
}
