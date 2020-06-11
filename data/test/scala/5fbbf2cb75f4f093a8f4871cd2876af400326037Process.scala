package net.usersource.process


class Process( val args: List[String] ) {
  
  implicit def convertScalaListToJavaList(aList:List[String]) = java.util.Arrays.asList(aList.toArray: _*)

  var rc: Option[Int] = None
  var process: Option[java.lang.Process] = None
  val processBuilder = new ProcessBuilder(args)

  
  def run: Process = {
    process = Some(processBuilder.start)
    this
  }

  def waitTillDone: Process = {
    rc = Some(process.get.waitFor)
    this
  }

  def returnCode = { rc }

}

object Process {

  def apply( args: String* ): Process = {
    new Process( args.toList )
  }

}