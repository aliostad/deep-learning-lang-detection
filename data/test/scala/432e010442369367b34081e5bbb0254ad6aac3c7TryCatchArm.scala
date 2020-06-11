package com.kevin
import scala.io.Source
import scala.util.control.NonFatal
/**
  * Created by kevinmonster on 16/12/16.
  */

object manage {
  def apply[R <: { def close():Unit}, T](resource: => R)(f: R=>T): Unit ={
    var res: Option[R] = None
    try {
      res = Some(resource)
      f(res.get)
    } catch {
      case NonFatal(ex) => println(s"Non fatal exception! $ex")
    } finally {
      if(res != None){
        println(s"closing resource...")
        res.get.close
      }
    }
  }
}

object TryCatchArm {

  def main(args: Array[String]) = {
    Array("/Users/kevinmonster/workspace/ktscala/src/main/resources/read.txt") foreach(arg => countLines(arg))
  }

  def countLines(fileName: String) = {

    println()
    manage(Source.fromFile(fileName)){
      source =>
        val size = source.getLines.size
        println(s"file $fileName has $size lines")
    }
  }
}
