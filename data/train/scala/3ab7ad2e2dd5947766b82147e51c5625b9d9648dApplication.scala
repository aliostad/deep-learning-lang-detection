package controllers

import play.api.mvc.{Action, Controller}
import play.api.data._
import play.api.data.Forms._
import anorm._
import play.api.db.DB
import play.api.Play.current
import play.Logger.debug

case class Recipe(id: Option[Long], name: String, ingredients: List[String])

object Application extends Controller {
  def recipes = {
    DB.withConnection { implicit conn =>
      SQL("select name from recipe order by name")().map(
        r => r[String]("name")
      ).toList
    }
  }
  def index = Action {
    Ok(views.html.index(recipes))
  }

  val newRecipeForm = Form(
    mapping(
      "recipe_id" -> ignored[Option[Long]](None),
      "name" -> nonEmptyText,
      "ingredients" -> list(text)
    )(Recipe.apply)(Recipe.unapply)
  )
  def manage = Action {
    Ok(views.html.manage(recipes, newRecipeForm))
  }

  def newRecipe = Action { implicit request =>
    newRecipeForm.bindFromRequest.fold(
      formWithErrors => BadRequest(views.html.manage(List(), formWithErrors)),
      successForm => {
        DB.withConnection { implicit conn =>
          val id: Option[Long] =
            SQL("insert into recipe (name) values ({name})")
            .on('name -> successForm.name)
            .executeInsert()
          id match {
            case Some(id) => {
              debug(s"Saving ${successForm.ingredients.size} ingredients")
              successForm.ingredients.foreach( ing => {
                if (ing != "") {
                  debug(s"saving $ing")
                  SQL("insert into recipe_ingredient (recipe_id, name) values ({id},{name})")
                    .on('id -> id, 'name -> ing)
                    .executeInsert()
                }
              })
            }
            case None => throw new Exception("Error saving recipe to the database")
          }
        }
        Ok(views.html.manage(List("Lamb", "Mashed Potatoes", "Baked Potatoes"), newRecipeForm))
      }
    )
  }
}