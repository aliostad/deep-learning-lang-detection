package proscala.chap03

import scala.language.reflectiveCalls
import scala.util.control.NonFatal

object manage {;import org.scalaide.worksheet.runtime.library.WorksheetSupport._; def main(args: Array[String])=$execute{;$skip(469); 
  def apply[R <: { def close(): Unit }, T](resource: => R)(f: R => T) = {
    var res: Option[R] = None
    try {
      res = Some(resource)
      f(res.get)
    } catch {
      case NonFatal(ex) => println(s"Non fatal exception! $ex")
    } finally {
      if (res != None) {
        println(s"close resource...")
        res.get.close
      }
    }
  };System.out.println("""apply: [R <: AnyRef{def close(): Unit}, T](resource: => R)(f: R => T)Any""")}

}

object TryCatchARM {

  import scala.io.Source
  
  def countLines(fileName: String) = {
    println()
    manage(Source.fromFile(fileName)) { source =>
    	val size = source.getLines.size
    	println(s"file $fileName has $size lines")
    	if(size > 20) throw new RuntimeException("Big file!")
    }
  }
  
  def main(args: Array[String]) = {
  	countLines("/Users/Justin/git/practice-in-scala/practice-in-scala/src/proscala/chap03/basic_for.sc");
  }
}
