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
import controllers.{FieldCheckHelpers, JsonForm, Preview}
import forms.TextAreaField
import models.{AppSectionNumber, OppSectionNumber, OppSectionType, Opportunity, OpportunityId, Question}
import play.api.libs.json._
import play.api.mvc._
import services.{ApplicationFormOps, OpportunityOps}

import scala.concurrent.{ExecutionContext, Future}

class OppSectionController @Inject()(appForms: ApplicationFormOps,opportunities: OpportunityOps, OpportunityAction: OpportunityAction)(implicit ec: ExecutionContext) extends Controller {
  val sectionFieldName = "section"
  val sectionField = TextAreaField(None, sectionFieldName, 500)

  def doEdit(opp: Opportunity, sectionNum: OppSectionNumber, initial: JsObject, errs: Seq[forms.validation.FieldError] = Nil) = {
    val hints = FieldCheckHelpers.hinting(initial, Map(sectionFieldName -> sectionField.check))
    opp.description.find(_.sectionNumber == sectionNum) match {
      case Some(section) =>
        val q = Question(section.description, None, section.helpText)
        Ok(views.html.manage.editOppSectionForm(sectionField, opp, section,
          routes.OppSectionController.edit(opp.id, sectionNum).url, Map(sectionFieldName -> q), initial, errs, hints))
      case None => NotFound
    }
  }

  def edit(id: OpportunityId, sectionNum: OppSectionNumber) = OpportunityAction(id).async { request =>
    appForms.byOpportunityId(id).map {
      case Some(appForm) =>
        request.opportunity.description.find(_.sectionNumber == sectionNum) match {
          case Some(sect) if sect.sectionType == OppSectionType.Text =>
            val answers = JsObject(Seq(sectionFieldName -> Json.toJson(sect.text.map(_.value))))
            doEdit(request.opportunity, sectionNum, answers)
          case Some(sect) => Ok(views.html.manage.whatWeWillAskPreview(request.uri, request.opportunity, sectionNum, appForm))
          case None => NotFound
        }
      case None => NotFound
    }
  }

  def save(id: OpportunityId, sectionNum: OppSectionNumber) = OpportunityAction(id).async(JsonForm.parser) { implicit request =>
    (request.body.values \ sectionFieldName).toOption.map { fValue =>
      sectionField.check(sectionFieldName, fValue) match {
        case Nil =>
          opportunities.saveDescriptionSectionText(id, sectionNum, Some(fValue.as[String])).map { _ =>
            request.body.action match {
              case Preview =>
                Redirect(controllers.manage.routes.OppSectionController.preview(id, sectionNum))
                  .flashing(PREVIEW_BACK_URL_FLASH ->
                    controllers.manage.routes.OppSectionController.edit(id, sectionNum).url)
              case _ =>
                Redirect(controllers.manage.routes.OpportunityController.showOverviewPage(id))
            }
          }
        case errors => Future.successful(doEdit(request.opportunity, sectionNum, request.body.values, errors))
      }
    }.getOrElse(Future.successful(BadRequest))
  }

  def view(id: OpportunityId, sectionNum: OppSectionNumber) = OpportunityAction(id).async { request =>
    appForms.byOpportunityId(id).map {
      case Some(appForm) => request.opportunity.publishedAt match {
        case Some(_) => Ok(views.html.manage.viewOppSection(request.opportunity, appForm, sectionNum, request.flash.get(PREVIEW_BACK_URL_FLASH)))
        case None => Redirect(controllers.manage.routes.OppSectionController.edit(id, sectionNum))
      }
      case None => NotFound
    }
  }
  def preview(id: OpportunityId, sectionNum: OppSectionNumber) = OpportunityAction(id) { request =>
      Ok(views.html.manage.previewOppSection(request.opportunity, sectionNum, request.flash.get(PREVIEW_BACK_URL_FLASH)))
  }
}
