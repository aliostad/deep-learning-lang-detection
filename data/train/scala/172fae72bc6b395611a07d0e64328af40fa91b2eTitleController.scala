/*
 * Copyright (C) 2016  Department for Business, Energy and Industrial Strategy
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package controllers.manage

import javax.inject.Inject

import actions.OpportunityAction
import controllers.FieldCheckHelpers
import controllers.FieldCheckHelpers.hinting
import eu.timepit.refined.auto._
import forms.TextField
import forms.validation.FieldError
import models.{Opportunity, OpportunityId, Question}
import play.api.libs.json._
import play.api.mvc._
import play.twirl.api.Html
import services.OpportunityOps

import scala.concurrent.ExecutionContext

class TitleController @Inject()(
                                 val opportunities: OpportunityOps,
                                 val OpportunityAction: OpportunityAction)
                               (implicit val ec: ExecutionContext)
  extends Controller with SummarySave[Option[String], String] {

  override implicit def inReads: Reads[Option[String]] = OptionReads[String]

  override val fieldName: String = "title"
  val field = TextField(None, name = fieldName, isEnabled = true, isMandatory = false, isNumeric = false, maxWords = 200)
  val questions = Map(fieldName -> Question("What is your opportunity called ?"))
  override val validator = field.validator

  def edit(id: OpportunityId) = OpportunityAction(id) { request =>
    val answers = JsObject(Seq(fieldName -> Json.toJson(request.opportunity.title)))
    val hints = hinting(answers, Map(field.name -> field.check))
    Ok(views.html.manage.editTitleForm(field, request.opportunity, questions, answers, Seq(), hints, request.uri))
  }

  def view(id: OpportunityId) = OpportunityAction(id) { request =>
    request.opportunity.publishedAt match {
      case Some(dateval) => Ok(views.html.manage.viewTitle(request.opportunity))
      case None => Redirect(controllers.manage.routes.TitleController.edit(id))
    }
  }

  def preview(id: OpportunityId) = OpportunityAction(id) { request =>
    Ok(views.html.manage.previewTitle(request.opportunity, request.flash.get(PREVIEW_BACK_URL_FLASH)))
  }

  def updateSummary(opportunity: Opportunity, v: String) = opportunity.summary.copy(title = v)

  override def editPage(id: OpportunityId): Call =
    controllers.manage.routes.TitleController.edit(id)

  override def doEdit(opp: Opportunity, values: JsObject, errs: Seq[FieldError]): Html = {
    val hints = FieldCheckHelpers.hinting(values, Map(fieldName -> field.check))
    views.html.manage.editTitleForm(field, opp, questions, values, errs, hints, "")
  }
}