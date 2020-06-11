package com.simulation.weather.utils

import scala.util.control.NonFatal
import scala.language.reflectiveCalls

/**
  * Created by abajpai on 9/3/16.
  */
trait ResourceManager {
  def manage[R <: { def close():Unit }, T](resource: => R)(f: R => T) = {
    var res: Option[R] = None

    try {
      res = Some(resource) // Only reference "resource" once!!
      f(res.get)
    }
    catch {
      case NonFatal(ex) => println(s"Non fatal exception! $ex")
      case ex:Throwable => println(ex.getMessage)
    }
    finally {
      res match {
        case Some(resource) =>
          println(s"Closing resource...")
          res.get.close
        case None =>
      }
    }
  }
}
