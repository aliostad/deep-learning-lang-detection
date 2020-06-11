package controllers

import javax.inject.Singleton

import models.Process
import services.ProcessStateService
import play.api.Logger
import play.api.libs.json._
import play.api.mvc._

/**
  * Created by jclavero on 18/08/2016.
  */
@Singleton
class ProcessController extends AbstractController {

  import play.api.data.Forms._
  import play.api.data._

  val processForm = Form(
    mapping(
      "name" -> text,
      "department" -> text,
      "description" -> text
    )(Process.apply)(Process.unapply)
  )


  /* def createProcess = Action(parse.form(processForm)) { implicit request =>
     Logger.info("************************ createProcess ***************************************")

     val processData: Process = request.body

     Logger.info(s"createProcess process: $processData")

     val flagCorrect: Boolean = ProcessStateService.createProcess(processData)

     Logger.info(s"correct user? $flagCorrect")

     if (flagCorrect)
       Ok(views.html.Process("Administracion de los procesos."))
     else
       Ok("No está dado de alta")
   }
 */

  def retrieveAllProcess = Authenticated {
    Ok(Json.toJson(ProcessStateService.retrieveAllProcess));
  }

  val processCreate = Form(
    mapping(
      "name" -> text,
      "department" -> text,
      "description" -> text
    )(Process.apply)(Process.unapply)
  )

  def create = Authenticated {
    implicit request =>
      Logger.info("************************ create Process ***************************************")

      request.body.asJson match {
        case Some(value) => {
          if (ProcessStateService.createProcess(value.as[Process]))
            Ok(Json.parse("true"))
          else
            InternalServerError(Json.parse("false"))
        }
        case None => InternalServerError(Json.parse("Nada de datos."))
      }

  }


  /**
    * Redirect to Process Page.
    *
    * @return
    */
  def redirectToProcess = Authenticated { implicit request =>
    Ok(views.html.Process("Admin de los procesos."))
  }
}
