package tests.tca

import scala.util.control.Breaks._
import ca.uwaterloo.scalacg.annotation.invocations

/**
 * The simplest version of Breakable2  
 *
 * June, 6th, 2013.
 *
 * @author Karim Ali
 */
object Constructor1 {

  @invocations("17: <unannotated> tests.tca.Constructor1.DumpCollector: <init>(p: String)")
  def main(args: Array[String]) {
    val dc = new DumpCollector("path")
  }

  @invocations("21: <unannotated> java.lang.Object: <init>()")
  class DumpCollector(i: Int) {
    var lineNr = 3
    var path: String = ""
    var files: List[String] = Nil
    lineNr += files.size + 1 // Note this line
    
    def this(p: String) = {
      this(1)
      path = p
    }
  }
}