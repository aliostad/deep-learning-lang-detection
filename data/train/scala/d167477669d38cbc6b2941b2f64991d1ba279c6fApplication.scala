package controllers

import play.api.mvc._
import play.api.data._
import play.api.data.Forms._
import models.{Todo, Project, WorkStep}

class Application extends Controller {
  
  def index = Action {
    Redirect(routes.Application.projects)
  }

  val projectForm = Form (
  mapping (
    "label" -> nonEmptyText,
    "categories" -> text,
    "description" -> text,
    "contributors" -> text,
    "tags" -> text
  ) ((label, categories, description , contributors, tags) => Project(0,label,categories,description,contributors,tags))
    ((project: Project) => Some(project.label, project.categories, project.description, project.contributors, project.tags))
  )

  def projects = Action {
    Ok(views.html.index(Project.all(), projectForm))
  }

  def manageProjects = Action {
    Ok(views.html.manageProjects(Project.all(), projectForm))
  }

  def projectDetails(id: Long) = Action {
    Ok(views.html.projectDetails(Project.getById(id), workStepForm))
  }

  def addProject = Action { implicit request =>
    projectForm.bindFromRequest.fold(
      errors => BadRequest(views.html.manageProjects(Project.all(), errors)),
      project => {
        Project.create(project.label, project.categories, project.description, project.contributors, project.tags)
        Redirect(routes.Application.manageProjects)
      }
    )
  }

  def deleteProject(id: Long) = Action {
    Project.delete(id)
    Redirect(routes.Application.manageProjects)
  }

  val todoForm = Form (
    mapping (
      "priority" -> number,
      "name" -> nonEmptyText,
      "description" -> nonEmptyText
    ) ((priority, name, description) => Todo(0,priority,name,description,""))
      ((todo: Todo) => Some(todo.priority, todo.name, todo.description))
  )

  def addTodo(id: Long) = Action { implicit request =>
    Ok(views.html.addTodo(Project.getById(id), todoForm, request))
  }

  def addTodoToProject(id: Long) = Action(parse.tolerantFormUrlEncoded) { implicit request =>
    todoForm.bindFromRequest.fold(
      errors => BadRequest(views.html.addTodo(Project.getById(id), errors, request)),
      todo => {
        Project.addTodo(id, todo)
        goToPreviousPage(id, request)
      }
    )
  }

  def handleTodo(id: Long) = Action(parse.tolerantFormUrlEncoded) { implicit request =>
    val todoId: Long = toLong(request.body.get("todoId").map(_.head).getOrElse("")).getOrElse(0)
    request.body.get("action").map(_.head).getOrElse("") match {
      case "check" => {
        Todo.check(todoId)
        Redirect(routes.Application.projectDetails(id))
      }
      case "delete" => {
        Todo.delete(todoId)
        Redirect(routes.Application.projectDetails(id))
      }
      case _ => BadRequest("This action is not allowed")
    }
  }

  def deleteTodo(id: Long) = Action(parse.tolerantFormUrlEncoded) { implicit request =>
    val todoId: Long = toLong(request.body.get("todoId").map(_.head).getOrElse("")).getOrElse(0)
    Todo.delete(todoId)
    Redirect(routes.Application.projectDetails(id))
  }

  def checkTodo(id: Long) = Action(parse.tolerantFormUrlEncoded) { implicit request =>
    val todoId: Long = toLong(request.body.get("todoId").map(_.head).getOrElse("")).getOrElse(0)
    Todo.check(todoId)
    Redirect(routes.Application.projectDetails(id))
  }

  val workStepForm = Form (
    mapping (
      "header" -> nonEmptyText,
      "description" -> nonEmptyText,
      "progress" -> number,
      "pictures" -> text
    ) ((header, description, progress, pictures) => WorkStep(0,header,description,progress,pictures))
      ((workStep: WorkStep) => Some(workStep.header, workStep.description, workStep.progress, workStep.pictures))
  )

  def addWorkStep(id: Long) = Action { implicit request =>
    Ok(views.html.addWorkStep(Project.getById(id), workStepForm, request))
  }

  def addWorkStepToProject(id: Long) = Action(parse.tolerantFormUrlEncoded) { implicit request =>
    workStepForm.bindFromRequest.fold(
      errors => BadRequest(views.html.addWorkStep(Project.getById(id), errors, request)),
      workStep => {
        Project.addWorkStep(id, workStep)
        goToPreviousPage(id, request)
      }
    )
  }

  def deleteWorkStep(id: Long) = Action(parse.tolerantFormUrlEncoded) { implicit request =>
    val workStepId: Long = toLong(request.body.get("workStepId").map(_.head).getOrElse("")).getOrElse(0)
    WorkStep.delete(workStepId)
    Redirect(routes.Application.projectDetails(id))
  }

  def toLong(s: String): Option[Long] = {
    try {
      Some(s.toLong)
    } catch {
      case e: Exception => None
    }
  }

  def upload = Action(parse.multipartFormData) { request =>
    request.body.file("picture").map { picture =>
      import java.io.File
      val filename = picture.filename
      val contentType = picture.contentType
      picture.ref.moveTo(new File("E:\\Projekte\\project_book\\public\\images\\" + filename))
      Redirect(routes.Application.manageProjects)
    }.getOrElse {
      Redirect(routes.Application.projects).flashing(
        "error" -> "Missing file"
      )
    }
  }

  def goToPreviousPage(id: Long, request: Request[Map[String, Seq[String]]]): Result = {
    val referer = request.body.get("referer").map(_.head).getOrElse("")
    val manageProjectsPattern = "(.*manageProjects.*)".r
    val projectDetailsPattern = "(.*projectDetails.*)".r

    referer match {
      case manageProjectsPattern(_) => Redirect(routes.Application.manageProjects)
      case projectDetailsPattern(_) => Redirect(routes.Application.projectDetails(id))
      case _ => BadRequest("False Route")
    }
  }

}