/**
 * $Header$
 * 
 * Scala-Sandbox - ph.gutierrez.learning.scala
 * 
 * Copyright (C) 2010 gutierrez.ph
 * All Rights Reserved
 * 
 **/
package ph.gutierrez.learning.scala

/**
 * 
 * @author <a href="mailto:jeff@gutierrez.ph">Jeff Gutierrez</a>
 * @version $Revision$ $Date$
 * @since 0.1
 */
class ProcessHandler(val command: String) {

	// TODO: Execute command here
 	println("Execute: " + command)

  def |(pipeTo: ProcessHandler): ProcessHandler = {
 		// TODO: Pass the output of this process pipeTo
    pipeTo
  }

}

object ProcessHandler {
  implicit def string2ProcessHandler(process: String) = new ProcessHandler(process)
}

object ProcessHandlerMain {
  import ProcessHandler.string2ProcessHandler

  def main(args: Array[String]): Unit = {
    "ps -al" | "grep test" | "echo test"
  }
}