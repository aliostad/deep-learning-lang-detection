package ir.iais.learning.resourceManagement

import scala.util.control.NonFatal

/**
 * Created by yoones on 30/08/2015.
 */
object Manage {
  def apply[R <: {def close() : Unit}, T](resource: => R)(f: R => T) = {
    var res: Option[R] = None
    try {
      res = Some(resource) // Only reference "resource" once!!
      f(res.get)
    }
    catch {
      case NonFatal(ex) => println(s"Non fatal exception! $ex")
    } finally {
      if (res != None) {
        println(s"Closing resource...")
        res.get.close
      }
    }
  }
}

object TryCatchARM {
  /** Usage: scala rounding.TryCatch filename1 filename2 ... */
  def main(args: Array[String]) = {
    args foreach (arg => countLines(arg))
  }

  import scala.io.Source

  def countLines(fileName: String) = {
    println() // Add a blank line for legibility
    Manage(Source.fromFile(fileName)) {
      source =>
        val size = source.getLines.size
        println(s"file $fileName has $size lines")
        if (size > 20) throw new RuntimeException("Big file!")
    }
  }
}
