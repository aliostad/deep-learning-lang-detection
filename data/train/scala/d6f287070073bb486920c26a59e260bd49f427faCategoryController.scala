package controllers

import play.api.mvc._
import play.api.data._
import play.api.data.Forms._
import play.api.libs.json._

import model._
import se.radley.plugin.salat.Binders._

object CategoryController extends Controller with Secured {

  val categoryForm = Form(mapping(
    "id" -> optional(text),
    "name" -> nonEmptyText,
    "displayName" -> nonEmptyText,
    "parentId"->optional(text),
    "properties" -> Forms.list(nonEmptyText)
  )(toCategory)(fromCategory))

  def toCategory(id: Option[String], name: String, displayName: String, parentId:Option[String], properties: List[String]) = {

    id match {
      case Some(id) => Category(new ObjectId(id), name, displayName, parentId.map(new ObjectId(_)), properties.map(new ObjectId(_)))
      case None => Category(name = name, displayName = displayName, propertyIds = properties.map(new ObjectId(_)))
    }
  }

  def fromCategory(category: Category) = {

    Some((Some(category.id.toString()), category.name, category.displayName, category.parentId.map(_.toString), category.propertyIds.map(_.toString)))
  }

  def propertyOptions = {
    Property.findAll().map(property => property.id.toString -> property.displayName).toSeq
  }

  def list = SecuredAction(WithRoles("ROLE_ADMIN")) {
    implicit request =>

      val categories = Category.findRoots()
      Ok(views.html.category.listCategories(categories))
  }

  def create(parentId:Option[String]) = SecuredAction(WithRoles("ROLE_ADMIN")) {
    implicit request =>
      parentId match {
        case Some(id)=>
          val cat=Category(name="",displayName = "",parentId=Some(new ObjectId(id)),propertyIds = List.empty)
          Ok(views.html.category.manageCategory(categoryForm.fill(cat), propertyOptions))
        case None =>
          Ok(views.html.category.manageCategory(categoryForm, propertyOptions))
      }
  }

  def update(id: String) = SecuredAction(WithRoles("ROLE_ADMIN")) {
    implicit request =>

      Category.findOneById(new ObjectId(id)) match {
        case Some(category) =>
          Ok(views.html.category.manageCategory(categoryForm.fill(category), propertyOptions))
        case None =>
          BadRequest("Specified category doesn't exist")
      }
  }

  def save = SecuredAction(WithRoles("ROLE_ADMIN")) {
    implicit request =>

      categoryForm.bindFromRequest().fold(
        formWithErrors => BadRequest(views.html.category.manageCategory(formWithErrors, propertyOptions)),
        category => {
          try {
            Category.save(category)
            Redirect(routes.CategoryController.list())
          } catch {
            case e: NonUniqueException => Ok("Error: " + e.message)
          }
        }
      )
  }

  def getAsJson(id: String) = Action {
    implicit request =>

      Ok(Json.toJson(Category.findOneById(new ObjectId(id))));
  }
}