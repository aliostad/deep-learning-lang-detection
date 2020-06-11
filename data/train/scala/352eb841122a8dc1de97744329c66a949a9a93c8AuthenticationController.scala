package controllers

import connectors.CryptoPhotoConnector
import models.Crypto
import play.api._
import play.api.mvc._
import play.api.data._
import play.api.data.Forms._
import views._

object AuthenticationController extends AuthenticationController

class AuthenticationController extends Controller {

  val cryptoPhotoConnector : CryptoPhotoConnector  = CryptoPhotoConnector
  val loginForm = Form(
    tuple(
      "email" -> text,
      "password" -> text
    )
  )

  val cryptoForm = Form(
    mapping(
      "email" -> nonEmptyText,
      "token_selector" -> nonEmptyText,
      "cp_phc" -> text,
      "token_response_field_col" -> text,
      "token_response_field_row" -> text
    )(Crypto.apply)(Crypto.unapply)
  )

  /**
    * Login page.
    */
  def login = Action { implicit request =>
    Ok(views.html.login(loginForm))
  }

  /**
    * Logout and clean the session.
    */
  def logout = Action {
    Redirect(routes.AuthenticationController.login).withNewSession.flashing(
      "success" -> "You've been logged out"
    )
  }

  /**
    * Handle login form submission.
    */
  def authenticate = Action { implicit request =>
    loginForm.bindFromRequest.fold(
      formWithErrors => BadRequest(views.html.login(formWithErrors)),
      user => {
        val cryptoSession = cryptoPhotoConnector.session(user._1)

        if (cryptoSession._2)
          Ok(views.html.crypto_authentication(user._1, cryptoSession._1.getOrElse("")))
        else
          Ok(views.html.crypto_manage_token(cryptoSession._1, user._1, cryptoSession._3))
      }
    )
  }


  def manage_crypto(userId: String) = Action { implicit request =>
      val cryptoSession = cryptoPhotoConnector.session(userId)
      Ok(views.html.crypto_manage_token(cryptoSession._1, userId, cryptoSession._3))
  }

  /**
    * Handle crypto form submission.
    */
  def authenticate_crypto = Action { implicit request =>

    cryptoForm.bindFromRequest.fold(
      formWithErrors => {
        val email = formWithErrors.get.email
        val cryptoSession = cryptoPhotoConnector.session(email)
        BadRequest(views.html.crypto_authentication(email, cryptoSession._1.getOrElse("")))
      },
      crypto => {
          cryptoPhotoConnector.verify(crypto) match {
            case Some(error) => {
              val cryptoSession = cryptoPhotoConnector.session(crypto.email)
              BadRequest(views.html.crypto_authentication(crypto.email, cryptoSession._1.getOrElse("")))
            }
            case None => Ok(views.html.restricted(crypto.email))
          }

      }
    )
  }
}