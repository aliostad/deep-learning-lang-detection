package controllers

import play.api._
import play.api.mvc._
import play.api.data._
import play.api.data.Forms._
import models.Show
import models.ShowObject
import models.ShowObject
import java.util.UUID

object Shows extends Controller {
	val form = Form(
		tuple(
			"date" -> text,
			"location" -> text,
			"hour" -> text,
			"price" -> text
		)
	)
  
	def index = Action {
		Ok(views.html.show())
	}

	def newShow = Action {
		Ok(views.html.Admin.show())
	}

	def add = Action { implicit request =>
		val (date, location, hour, price) = form.bindFromRequest.get
		val show = Show(Some(UUID.randomUUID().toString), date, location, hour, price.toFloat)
		ShowObject.save(show)
		Ok("%s".format(show))
	}
}
