// src/main/scala/progscala2/rounding/TryCatchArm.scala
package progscala2.rounding
import scala.language.reflectiveCalls
import scala.util.control.NonFatal

object manage {
  def apply[R <: { def close():Unit }, T](resource: => R)(f: R => T) = {
    var res: Option[R] = None
    try {
      res = Some(resource) // '자원'에 대한 유일한 참조
      f(res.get)
    } catch {
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
  /** 사용법: scala.rounding.Trycatch filename1 filename2 ... */
  def main(args: Array[String]) = {
    args foreach (arg => countLines(arg))
  }

  import scala.io.Source

  def countLines(fileName: String) = {
    println() // 가독성을 위해 빈 줄을 넣는다.
      manage(Source.fromFile(fileName)) { source =>
        val size = source.getLines.size
        println(s"file $fileName has $size lines")
        if (size > 20) throw new RuntimeException("Big file!")
      }
  }
}
