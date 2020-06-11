package controllers.admin

import play.api.mvc.{Controller, Action}
import views._

/**
 * Manage an administration home section
 */
object Administration extends Controller {

  val Technology = Ok(html.administration.technology.list())

  val Questionnaire = Ok(html.administration.questionnaire.list())

  val Test = Ok(html.administration.test.list())

  val Quiz = Ok(html.administration.quiz.list())

  // -- Actions

  /**
   * Handle default path requests, redirect to admin home
   */
  def home = Action { Technology }

  /**
   * Forwards to admin technology section
   */
  def techList = Action { Technology }

  /**
   * Forwards to admin quiz section
   */
  def quizList = Action { Quiz }

  /**
   * Forwards to admin questionnaires section
   */
  def questList = Action { Questionnaire }

  /**
   * Forwards to admin tests section
   */
  def testList = Action { Test }

}