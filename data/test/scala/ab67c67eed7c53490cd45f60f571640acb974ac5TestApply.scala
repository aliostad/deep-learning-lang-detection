package main.scala.test

import scala.io.Source
import scala.util.control.NonFatal

/**
  * Created by Administrator on 2016/4/11.
  */
object TestApply {
  def main(args: Array[String]) {
    val path = "D:\\develop\\idea_projects\\test_scala\\src\\main\\scala\\test\\Test.scala"
    countLines(path)
    println(Breed.doberman)
  }

  def countLines(fileName: String) = {
    println()
    manage(Source.fromFile(fileName)) { source =>
      val size = source.getLines().size
      println(s"file $fileName has $size lines")
      if (size > 200) {
        throw new RuntimeException("big file!")
      }
    }
  }
}

object manage {
  def apply[R <: {def close() : Unit}, T](resource: => R)(f: R => T) = {
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

object Breed extends Enumeration {
  type Breed = Value
  val doberman = Value("Doberman Pinscher")
  val yorkie = Value("Yorkshire Terrier")
}
