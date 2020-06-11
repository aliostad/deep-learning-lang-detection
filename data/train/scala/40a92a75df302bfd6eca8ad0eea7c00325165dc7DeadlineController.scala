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
import eu.timepit.refined.auto._
import forms.validation.{DateTimeRange, DateTimeRangeValues, FieldError}
import forms.{DateTimeRangeField, DateValues}
import models.{Opportunity, OpportunityId, Question}
import org.joda.time.LocalDate
import play.api.libs.json._
import play.api.mvc._
import play.twirl.api.Html
import services.OpportunityOps

import scala.concurrent.ExecutionContext

class DeadlineController @Inject()(
                                    val opportunities: OpportunityOps,
                                    val OpportunityAction: OpportunityAction)
                                  (implicit val ec: ExecutionContext)
  extends Controller with SummarySave[DateTimeRangeValues, DateTimeRange]  {

  override implicit val inReads: Reads[DateTimeRangeValues] = Json.reads[DateTimeRangeValues]

  override val fieldName = "deadlines"
  val field = DateTimeRangeField(fieldName, allowPast = false, isEndDateMandatory = false)
  val questions = Map(
    s"$fieldName.startDate" -> Question("When does the opportunity open?"),
    s"$fieldName.endDate" -> Question("What is the closing date?")
  )
  override val validator = field.validator

  private def dateTimeRangeValuesFor(opp: Opportunity) = {
    val sdv = dateValuesFor(opp.startDate)
    val edv = opp.endDate.map(dateValuesFor)
    DateTimeRangeValues(Some(sdv), edv, edv.map(_ => "yes").orElse(Some("no")))
  }

  private def dateValuesFor(ld: LocalDate) =
    DateValues(Some(ld.getDayOfMonth.toString), Some(ld.getMonthOfYear.toString), Some(ld.getYear.toString))


  def view(id: OpportunityId) = OpportunityAction(id) { request =>
    val answers = JsObject(Seq(fieldName -> Json.toJson(dateTimeRangeValuesFor(request.opportunity))))
    if (request.opportunity.isPublished)
      Ok(views.html.manage.viewDeadlines(field, request.opportunity, questions, answers))
    else
      Redirect(editPage(id))
  }

  def edit(id: OpportunityId) = OpportunityAction(id) { request =>
    val answers = JsObject(Seq(fieldName -> Json.toJson(dateTimeRangeValuesFor(request.opportunity))))
    Ok(views.html.manage.editDeadlinesForm(field, request.opportunity, questions, answers, Seq(), Seq()))
  }

  def preview(id: OpportunityId) = OpportunityAction(id) { request =>
      val answers = JsObject(Seq(fieldName -> Json.toJson(dateTimeRangeValuesFor(request.opportunity))))
      Ok(views.html.manage.previewDeadlines(field, request.opportunity, questions, answers, request.flash.get(PREVIEW_BACK_URL_FLASH)))
  }

  override def doEdit(opportunity: Opportunity, values: JsObject, errors: Seq[FieldError]): Html = {
    val hints = FieldCheckHelpers.hinting(values, Map(fieldName -> field.check))
    views.html.manage.editDeadlinesForm(field, opportunity, questions, values, errors.toList, hints)
  }

  def updateSummary(opportunity: Opportunity, v: DateTimeRange) =
    opportunity.summary.copy(startDate = v.startDate, endDate = v.endDate)

  override def editPage(id: OpportunityId): Call =
    controllers.manage.routes.DeadlineController.edit(id)
}
