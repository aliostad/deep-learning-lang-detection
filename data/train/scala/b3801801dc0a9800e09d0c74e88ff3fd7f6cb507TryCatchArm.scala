package Chapter3

import scala.util.control.NonFatal

/**
  * Created by zjjfly on 2016/11/6.
  */
object TryCatchArm {
  def main(args: Array[String]): Unit = {
    args foreach countLines
  }
  import scala.io.Source
  def countLines(fileName:String)={
    println()
    manage(Source.fromFile(fileName)){source=>
      val size=source.getLines().size
      println(s"file $fileName has $size lines")
      if(size>20)throw new RuntimeException("Big file!")
    }
  }
}
object manage{
  def apply[R <: {def close() : Unit},T](resouce: =>R)(f: R=>T) ={
    var res:Option[R]=None
    try{
      res=Some(resouce)
      f(res.get)
    }catch {
      case NonFatal(ex)=>println(s"Non fatak exception! $ex")
    }finally {
      if (res != None){
        println("Closing resource...")
        res.get.close()
      }
    }
  }
}