package models.jajascript

import play.api.libs.json._
import scala.collection.mutable
import play.api.Logger


case class Solution(endTime: Int, price: Int, oldSolution: Option[Solution], lastFlight: Flight) {


  def flights: Seq[Flight] = {

    var allSolutions = mutable.DoubleLinkedList[Solution]()
    allSolutions = allSolutions.append(mutable.DoubleLinkedList(this))
    var currentSolution = oldSolution
    while (currentSolution.isDefined) {
      allSolutions = allSolutions.append(mutable.DoubleLinkedList(currentSolution.get))
      currentSolution = currentSolution.get.oldSolution
    }


    allSolutions.reverse.map(solution => solution.lastFlight).toSeq
  }

  def toJson(): JsObject = {

    Json.obj(
      "gain" -> JsNumber(price),
      "path" -> JsArray(flights.map(flight => JsString(flight.name)))
    )
  }
}
