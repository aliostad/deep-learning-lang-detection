package lth.rounding

import scala.util.control.NonFatal
import scala.language.reflectiveCalls

/**
  * Created by lth on 17-4-20.
  */
object manage {
  def apply[R <: {def close(): Unit}, T](resource: => R)(f: R => T) = {
    var res: Option[R] = None
    try {
      res = Some(resource)
      f(res.get)
    } catch {
      case NonFatal(ex) => println(s"Non fatal exception! $ex")
    } finally {
      if (res != None) {
        println(s"Closing resource...")
        res.get.close()
      }
    }
  }
}

object TryCatchArm {
  def main(args: Array[String]) = {
    args foreach (arg => countLines(arg))
  }

  import scala.io.Source

  def countLines(fileName: String) = {
    println()
    manage(Source.fromFile(fileName)) { source =>
      val size = source.getLines.size
      println(s"file $fileName has $size lines")
      if (size > 20) throw new RuntimeException("Big file!")
    }
  }
}
