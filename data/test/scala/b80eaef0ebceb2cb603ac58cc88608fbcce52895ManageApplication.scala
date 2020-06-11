package controllers

import play.api._
import play.api.mvc._

import models._
import models.DBTableForms._

object ManageApplication extends Controller {
  
  def top = Action { implicit req =>
    Ok(views.html.manage.top())
  }
  
  def subjects = Action { implicit req =>
    Ok(views.html.manage.subjects(KamokuForm, Subjects.readAll))
  }
  
  def sbjCreate = Action { implicit req =>
    KamokuForm.bindFromRequest.fold(
      errors => {
        Ok(views.html.manage.subjects(errors, Subjects.readAll))
      },
      success => {
        Subjects.create(KamokuForm.bindFromRequest.get.kamoku_mei)
        Redirect(routes.ManageApplication.subjects)
      })
  }
  
  def textbooks = Action { implicit req =>
    Ok(views.html.manage.textbooks())
  }
  
}