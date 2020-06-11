package net.zhenglai.arm

import scala.language.reflectiveCalls
import scala.util.control.NonFatal

/**
 * Created by zhenglai on 8/14/16.
 */
object manage {

  // trait Closable {
  //  def close(): Unit
  // }
  // def apply[R <: Closable, T]
  def apply[R <: { def close(): Unit }, T](resource: => R)(use: R => T) = {
    var res: Option[R] = None
    try {
      res = Some(resource)
      use(res.get)
    } catch {
      case NonFatal(ex) => println(s"Non fatal exception: $ex")
    } finally res.foreach { r =>
      println("Closing resource...")
      r.close()
    }
  }

}

object TryCatchARM {

  import scala.io.Source

  def main(args: Array[String]) = {
    args foreach countLines
  }

  def countLines(fileName: String) = {
    println()

    manage(Source.fromFile(fileName)) { source =>
      val sz = source.getLines().size
      println(s"file $fileName has $sz lines")
      if (sz > 20)
        throw new RuntimeException("Big file!")
    }
  }
}
