package revealJsDemoPresentation.controllers

import javax.inject.Inject

import reactiveSlides.controllers.PresentationController
import revealJsDemoPresentation.views.RevealJsDemoPresentationView

/**
  * Manage the interactive presentation
  */
class revealJsPresentationController @Inject()(implicit env: play.Environment) extends PresentationController {

  /**
    * Display the revel.js Demo Presentation
    */
  def displayRevealJsDemo = {
    ok(RevealJsDemoPresentationView(presentationTitle, description, author, theme))
  }
}