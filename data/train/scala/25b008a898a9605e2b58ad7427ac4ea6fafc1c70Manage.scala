package controllers

import play.api.mvc._
import play.api.data.Form
import models._
import play.api.data.Forms._
import com.mongodb.casbah.commons.MongoDBObject
import models.Region
import models.Environment
import models.Application

object Manage extends Controller with Access {

  val appForm: Form[models.Application] = Form(
    mapping(
      "name" -> text,
      "environment" -> text,
      "region" -> text
    )(
        (name, environment, region) =>
          Application(name = name, environment = environment, region = region, logList = List() )
      )(
        (application: Application) => Option(application.name, application.environment, application.region)
      )
  )

  val envForm: Form[models.Environment] = Form(
    mapping(
      "name" -> text
    )(
        (name) =>
          Environment(name = name)
      )(
        (environment: Environment) => Option(environment.name)
      )
  )

  val regionForm: Form[models.Region] = Form(
    mapping(
      "name" -> text
    )(
        (name) =>
          Region(name = name)
      )(
        (region: Region) => Option(region.name)
      )
  )

  def index = Action {  implicit request =>
        Ok(views.html.manage(loginForm, registerForm, appForm, envForm, regionForm, getApplications(), getEnvironments(), getRegions()))
  }

  def createApplication = Action { implicit request =>
    appForm.bindFromRequest.fold(
      errors => {    Redirect("/manage").flashing(
        "error" -> "There were errors in your form."
      )},
      app => {
        val application = MongoDBObject("name" -> app.name, "environment" -> app.environment,"region" -> app.region,"logList" -> app.logList)
        getCollection("applications").insert(application)
      }
    )

    Redirect("/manage").flashing(
      "success" -> "Your new app was created."
    )
  }

  def createEnvironment = Action { implicit request =>
    envForm.bindFromRequest.fold(
      errors => {    Redirect("/manage").flashing(
        "error" -> "There were errors in your form"
      )},
      env => {
        val environment = MongoDBObject("name" -> env.name)
        getCollection("environments").insert(environment)
      }
    )

    Redirect("/manage").flashing(
      "success" -> "A new environment has been added"
    )
  }

  def createRegion = Action { implicit request =>
    regionForm.bindFromRequest.fold(
      errors => {    Redirect("/manage").flashing(
        "error" -> "There were errors in your form."
      )},
      reg => {
        val region = MongoDBObject("name" -> reg.name)
        getCollection("regions").insert(region)
      }
    )

    Redirect("/manage").flashing(
      "success" -> "A new region has been added"
    )
  }

  def getApplications(): List[Application] = {
    ApplicationDAO.find(ref = MongoDBObject()).toList
  }

  def getEnvironments(): List[Environment] = {
    EnvironmentDAO.find(ref = MongoDBObject()).toList
  }

  def getRegions(): List[Region] = {
    RegionDAO.find(ref = MongoDBObject()).toList
  }

}
