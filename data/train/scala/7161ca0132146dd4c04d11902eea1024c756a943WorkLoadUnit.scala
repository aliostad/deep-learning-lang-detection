package models

import play.api.data.Forms._
import play.api.data.Mapping
import play.api.libs.json._

import scala.util.{Failure, Success, Try}

/**
  * WorkLoadUnit gives a representation of how the workloads should be represented for a project
  */
sealed trait WorkLoadUnit

object WorkLoadUnit{

  /**
    * Will represent the values as person days
    */
  case object JourHomme extends WorkLoadUnit

  /**
    * Will represent the values as person months
    */
  case object MoisHomme extends WorkLoadUnit

  /**
    * Map of all the workload units
    */
  val AllWorkLoadUnits  : Map[String, WorkLoadUnit] = Map(
    JourHomme.toString -> JourHomme,
    MoisHomme.toString -> MoisHomme
  )

  val StringMapping = nonEmptyText.verifying("Invalid Work load unit submitted", wluString => AllWorkLoadUnits contains wluString)

  val Mapping: Mapping[WorkLoadUnit] = StringMapping.transform(apply, wlu => wlu.toString)


  def apply(s:String): WorkLoadUnit = fromString(s).get

  /**
    * Tries to convert a String object to a WorkLoadUnit object.
    *
    * @param s String to convert to a WorkLoadUnit object
    * @return Success(WorkLoadUnit) object if the String was correct, exception otherwise
    */
  def fromString(s:String): Try[WorkLoadUnit] =
    if (AllWorkLoadUnits contains s) Success(AllWorkLoadUnits(s))
    else Failure(new IllegalArgumentException(s"Invalid value submitted for WorkLoadUnit. Allowed values are those in [${AllWorkLoadUnits.keys.mkString(",")}]"))

  /** Json serializer for type WorkLoadUnit */
  implicit object Writer extends Writes[WorkLoadUnit] {
    override def writes(wlu: WorkLoadUnit): JsValue = JsString(wlu.toString)
  }

  /** Json de-serializer for type WorkLoadUnit */
  implicit object Reader extends Reads[WorkLoadUnit] {
    override def reads(json: JsValue): JsResult[WorkLoadUnit] = json match {
      case JsString(r)  => WorkLoadUnit.fromString(r) match {
        case Success(wlu) => JsSuccess(wlu)
        case Failure(exception) => JsError(exception.getMessage)
      }
      case _  => JsError(s"Invalid value submitted for WorkLoadUnit. Allowed values are those in [${AllWorkLoadUnits.keys.mkString(",")}]")
    }
  }
}