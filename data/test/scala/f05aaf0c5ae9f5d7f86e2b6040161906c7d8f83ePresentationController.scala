package reactiveSlides.controllers

import javax.inject.Inject

import play.api.http._
import play.api.mvc._
import reactiveSlides.views.{HomePageView, MainView}

import scalatags._

/**
  * Manage the interactive presentation
  */
class PresentationController @Inject()(implicit env: play.Environment) extends Controller {

  /**
    * Manage the interactive presentation parameters
    */
  def presentationTitle = "reactive-slides - The Interactive Presentations Framework"
  def description = "A web framework for building interactive presentations"
  def author = "Rahal Badr & Nicolas Vasseur"
  def theme = "black"

  /**
    * Defines the function rendering the scalatags views
    * @param view the view to render
    * @return
    */
  def ok(view: Seq[Text.TypedTag[String]]) = Action {
    implicit val codec = Codec.utf_8
    Ok(MainView(view).toString).withHeaders(CONTENT_TYPE -> ContentTypes.HTML)
  }

  /**
    * This result directly redirect to the example presentation home.
    */
  def index = {
    ok(HomePageView(presentationTitle, description, author, theme))
  }
}