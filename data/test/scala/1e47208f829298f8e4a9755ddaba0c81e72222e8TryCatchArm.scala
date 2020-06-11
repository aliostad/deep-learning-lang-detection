package com.malsolo.scala.rounding

import scala.language.reflectiveCalls
import scala.util.control.NonFatal

object manage {
  def apply[R <: {def close(): Unit}, T](resource: => R)(f: R => T) = {
    var res: Option[R] = None
    try {
      res = Some(resource)
      f(res.get)
    }
    catch {
      case NonFatal(ex) => println(s"Non fatal exception: $ex")
    }
    finally {
      if (res != None) {
        println("Closing resource...")
        res.get.close
      }
    }
  }
}

object TryCatchArm {

  def main(args: Array[String]): Unit = {
    args foreach (arg => countLines(arg))
  }

  import scala.io.Source

  def countLines(fileName: String) = {
    println()
    manage(Source.fromFile(fileName)) { source =>
      val size = source.getLines().size
      println(s"file $fileName has $size lines")
      if (size > 40) throw new RuntimeException("Big File!")
    }
  }
}