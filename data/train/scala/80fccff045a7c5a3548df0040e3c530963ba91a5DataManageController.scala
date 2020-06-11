package controllers

import javax.inject._

import models.Job
import play.api._
import play.api.data._
import play.api.data.Forms._
import play.api.mvc._
import play.api.db._
import play.api.Play.current
//import anorm._
import anorm._

/**
  * Created by wangyuanyou on 5/21/17.
  */
class DataManageController @Inject() extends Controller {
  def dataManage= Action {
    Ok(views.html.dataManage())
  }
  def lookHDFS= Action{
    Ok(views.html.lookHDFS())
  }
  def dataManageIndex = Action{
    Ok(views.html.dataManageIndex())
  }
  def lookHive= Action{
    Ok(views.html.lookHive())
  }
}
