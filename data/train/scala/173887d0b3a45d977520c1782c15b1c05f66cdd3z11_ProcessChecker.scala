package a11_Producers

import grizzled.slf4j.Logging
import sys.process._

case class ProcessInfo(  processId:String, 
                         cpuInfo:String, 
                         memInfo:String,
                         javaProcessName:String)

object z11_ProcessChecker extends Logging {
  
  /*******************************************************************
   * getProcessInfo() 
   ******************************************************************/
  def getProcessInfo(processId:Int, javaProcessName:String): ProcessInfo = {
    println("Retrieving process info for process ID -> " +  processId)
    val command = s"ps -p ${processId} -o %cpu,%mem"
    println("command -> " + command)
    
    val res:String = command.!!
    println("res -> " + res)
    
    val lines = res.split("\n").drop(1).map(x => x.trim())
    lines.foreach(println)
    
    val result = lines(0).split(" +")
    ProcessInfo(processId.toString(), result(0), result(1), 
                javaProcessName)    
  }
  
  /*******************************************************************
   * getJavaProcessInfo() 
   ******************************************************************/
  def getJavaProcessInfo():Seq[ProcessInfo] = {
    val command = "jps"
    val res:String = command.!!
    println("res -> " + res)
   
    val lines:Seq[String] = res.split("\n")
    lines.foreach(println)
    
    val idNname = lines.map( x => x.split(" ") )
    
    val filtered = idNname.filter{ x => 
      if(x.size == 2) {
        println(s"x(0) -> ${x(0)}, x(1) -> ${x(1)}, size -> ${x.size}")
        if(x(1) != "Jps")
          true
        else
          false
      }
      else {
        false
      }
    }
    
    val result = filtered.map{ x =>
      val processInfo:ProcessInfo = getProcessInfo(x(0).toInt, 
                                              x(1))
      println(s"processInfo -> ${processInfo}")
      processInfo
    }
    result
  }
  
  /*******************************************************************
   * main() 
   ******************************************************************/
  /*def main(args: Array[String]) {
    getJavaProcessInfo()
    //val tupled = getProcessInfo(14389)  
    //tupled.foreach(println)
  }*/
  
}















