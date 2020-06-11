package services

import play.api.db._
import play.api.mvc._
import play.api.libs.json._

import models.Process

class ProcessService() {
  val incProc: Process = new Process(1, "INC-", "Incident Service")
  def get(id: Long): Process = {
    if(id == 1) {
      incProc
    } else {
      null
    }
  }
  def getAll(): List[Process] = {
    val processList: List[Process] = List(incProc)
    processList
  }
  def getAllJson(request: RequestHeader): JsArray = {
    var jsonArray: JsArray = Json.arr()
    val processList: List[Process] = getAll()
    for(process <- processList) {
      jsonArray = jsonArray ++ Json.arr(Json.obj("id" -> process.id, "title" -> process.title, "desc" -> process.desc))
    }
    jsonArray
  }

}
