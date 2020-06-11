package controllers

import play.api.mvc.{Action, Controller}
import play.api.libs.json._
import play.api.Routes

//import scala.slick.driver.H2Driver.simple._
//import database._

// TODO handle string in set* with spaces
// TODO find a better time class
// TODO use class instead of case class to test for correct values

object CourseController extends Controller {

  // day of the week (monday = 0), begin "1400" for 14:00
  case class Time(day: Int, begin: Int, end: Int) /*{
    require(0 <= day <= 6)
  }*/

  // kind course/exercice, repetition: once: 0, every week: 1, two week: 2, ...
  case class Period(kind: String, time: Time, repetition: Int, room: String)
  case class Schedule(times: List[Period])
  case class Professor(name: String)
  case class Course(name: String, professor: Professor, schedule: Schedule,
    description: String)

  implicit val timeWrites = Json.format[Time]
  implicit val periodWrites = Json.format[Period]
  implicit val scheduleWrites = Json.format[Schedule]
  implicit val professorWrites = Json.format[Professor]
  implicit val courseWrites = Json.format[Course]

  // main part
  var courses: Map[String,Course] =
    Map("Scala" -> Course("Scala",Professor("Martin Odersky"),Schedule(List(
      Period("course", Time(0, 1200, 1400), 1, "CO1"))), "Scala course"))

  def getData(course: String) = Action {
    courses.get(course) match {
      case Some(c) => Ok(Json.toJson(c))
      case _ => BadRequest("Not found in DB")
    }
  }

  // name
  def getName(course: String) = Action {
    courses.get(course) match {
      case Some(c) => Ok(Json.toJson(c.name))
      case _ => BadRequest("Not found in DB")
    }
  }

  def setName(course: String, name: String) = Action {
    courses.get(course) match {
      case Some(c) => {
        val old = courses(course)
        courses = courses - course
        courses = courses + (name -> new Course(name, old.professor,
                                                    old.schedule,
                                                    old.description))
        Ok
      } case _ => BadRequest("Not found in DB")
    }
  }

  // professor
  def getProfessor(course: String) = Action {
    courses.get(course) match {
      case Some(c) => Ok(Json.toJson(c.professor))
      case _ => BadRequest("Not found in DB")
    }
  }

  def setProfessor(course: String, name: String) = Action {
    courses.get(course) match {
      case Some(c) => {
        val old = courses(course)
        courses = courses - course
        courses = courses + (course -> new Course(old.name, Professor(name),
                                                    old.schedule,
                                                    old.description))
        Ok
      } case _ => BadRequest("Not found in DB")
    }
  }

  // schedule
  def getSchedule(course: String) = Action {
    courses.get(course) match {
      case Some(c) => Ok(Json.toJson(c.schedule))
      case _ => BadRequest("Not found in DB")
    }
  }

  def addPeriod(course: String, json: String) = Action {
    courses.get(course) match {
      case Some(c) => {
        val old = courses(course)
        //TODO unescape string
        val period: Period = Json.parse(json).as[Period]
        courses = courses - course
        courses = courses + (course -> new Course(old.name, old.professor,
                                                    Schedule(
                                                      period :: old.schedule.times
                                                    ), old.description))
        Ok
      } case _ => BadRequest("Not found in DB")
    }
  }
}
