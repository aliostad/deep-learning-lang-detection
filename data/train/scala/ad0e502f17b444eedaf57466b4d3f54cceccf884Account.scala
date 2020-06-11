package controllers

import play.api._
import play.api.mvc._
import play.api.data._
import play.api.data.Forms._
import play.api.data.validation.Constraints._

import anorm._

import views._
import models._

object Account extends Controller with Secured {

  val accountForm = Form(
    tuple(
      "newEmail" -> email,
	  "newFirstName" -> nonEmptyText,
	  "newLastName" -> nonEmptyText,
	  "newPassword" -> tuple(
	    "password1" -> text(minLength = 6),
	    "password2" -> text
	  ).verifying(
	    "Passwords don't match", passwords => passwords._1 == passwords._2
	  )
	)
  )

  def manage = IsAuthenticated { username => implicit request =>
    User.findByEmail(username).map { user =>
      val existingUser: (String, String, String, (String, String)) = (user.email, user.firstName, user.lastName, (user.password, user.password))
      Ok(
        html.account.manage(
          accountForm.fill(existingUser),
          user
        )
      )
    }.getOrElse(Forbidden)
  }

  def update = IsAuthenticated { username => implicit request =>
    User.findByEmail(username).map { user =>
      val existingUser: (String, String, String, (String, String)) = (user.email, user.firstName, user.lastName, (user.password, user.password))
      accountForm.bindFromRequest.fold(
        errors => BadRequest(html.account.manage(errors, user)),
        {case(newEmail, newFirstName, newLastName, (password1, password2)) =>
          val userUpdate = User.update(
            User(user.id, newEmail, newFirstName, newLastName, password1)
          )
          Ok.flashing("success" -> "User %s has been updated".format(user.id))
          
          Redirect(routes.Account.manage).withSession("email" -> newEmail)
        }
      )
    }.getOrElse(Forbidden)
  }



}
