package com.ashish.initial

import scala.io.Source
import scala.util.control.NonFatal

// Defining the apply method in this object
object manage {
  def apply[R <: { def close():Unit}, T ](resource: =>R)(f:R=>T)={
    // resource: => R this designates the call by name .  The value is evaluated only when needed and not at the time of passing to the function itself.
    var res:Option[R]=None
    try{
        res=Some(resource)
        f(res.get)
    }catch{
     case NonFatal(ex) => println(s"Non Fatal Exception $ex")
    }finally{
      if(res!=null){
        println("Closing Resource")
        res.get.close()
      }
    }

  }
}

/**
  * Created by ash on 3/15/17.
  */
object TryCatchARM {
  def main(args: Array[String]): Unit = {
    args foreach(arg=>countLine(arg))
  }

  def countLine(filename:String)={
    println()
    manage(Source.fromFile(filename)){
      source=>
        val size=source.getLines.size
        println(s" file $filename has size $size")
    }
  }


}
