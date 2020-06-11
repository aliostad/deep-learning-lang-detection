package ch.bsisa.hyperbird.controllers

import play.api.mvc.SimpleResult
import play.api.Logger
import play.api.libs.json.Json
import play.api.mvc.Results.InternalServerError
import scala.concurrent.Future

import play.api.libs.concurrent.Execution.Implicits._

object ExceptionsManager {
  
  /**
   * Utility method to return exception, error message in a generic JSON error message.
   */
  def manageException(exception: Option[Throwable] = None, errorMsg: Option[String] = None): SimpleResult = {
    Logger.warn("Api exception: " + exception.getOrElse("").toString + " - " + errorMsg.getOrElse(""))
    val jsonExceptionMsg = Json.obj(
      "ERROR" -> exception.getOrElse("application.validation.failure").toString,
      "DESCRIPTION" -> errorMsg.getOrElse(exception.getOrElse("None").toString).toString // TODO: review
      )
    InternalServerError(jsonExceptionMsg)
  }  
  
  
    /**
   * Encapsulate `manageException` in a asynchronous call for use in Action.async context.
   * @see manageException
   */
  def manageFutureException(exception: Option[Throwable] = None, errorMsg: Option[String] = None): Future[SimpleResult] =
    scala.concurrent.Future { manageException(exception, errorMsg) }
  
}