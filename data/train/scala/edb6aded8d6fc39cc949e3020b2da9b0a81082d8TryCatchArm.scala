package progscala2.rounding

import scala.io.Source
import scala.util.control.NonFatal
import scala.language.reflectiveCalls

object manage {
  def apply[R <: {def close() : Unit}, T](resource: => R)(f: R => T) = {
    var res: Option[R] = None
    try {
      res = Some(resource)
      f(res.get)
    } catch {
      case NonFatal(ex) => println(s"Non fatal exception! $ex")
    } finally {
      if (res.isDefined) {
        println(s"Closing resource...")
        res.get.close
      }
    }
  }
}

object TryCatchArm {
  def main(args: Array[String]) = {
    args foreach (arg => countLines(arg))
  }

  def countLines(fileName: String) = {
    println() // Add a blank line for legibility
    manage(Source.fromFile(fileName)) { source =>
      val size = source.getLines.size
      println(s"filename $fileName has $size lines")
      if (size > 20) throw new RuntimeException("Big file!")
    }
  }
}
