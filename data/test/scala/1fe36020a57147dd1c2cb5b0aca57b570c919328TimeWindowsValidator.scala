package telemachus.services

import telemachus.models._
import telemachus.util._

class TimeWindowsValidator(locationRules: Map[Int, LocationRule]) {

  def check(load: Load) = {
    checkTravelTime(load) &&
      checkRequestedDates(load) &&
      checkStopDates(load)
  }

  def checkTravelTime(load: Load) = {
    load.travelTime.nonEmpty
  }

  def checkRequestedDates(load: Load) = {
    load.stops.forall{ stop => stop.requestedDates.distinct.size == 1 }
  }

  def checkStopDates(load: Load) = {
    load.travelTime match {
      case Some(travelTime) => StopsTravelTimeChecker.check(load.stops, travelTime)
      case None => false
    }
  }

}
