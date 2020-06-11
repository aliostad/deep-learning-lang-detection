package bs.utils

import bs.Settings
import java.lang.ProcessBuilder

import java.io.BufferedReader
import java.io.InputStreamReader
import scala.annotation.tailrec

object Utils {
  def verbose(action: => Unit) {
    if (Settings.verbose) {
      action
    } 
  }

  def failIf(condition: => Boolean)(print: => Unit) = {
    if (condition) {
      fail { print }
    } 
  }

  def fail(print: => Unit) = {
    print
    System.exit(1)
  }

  def runProcess(command:List[String], tag:String = ""):Int = {
    verbose { println("running: " + command.mkString(" ")) }

    val processBuilder = new ProcessBuilder(command:_*)
    processBuilder.redirectErrorStream(true)
    val process = processBuilder.start()

    val processInput = new BufferedReader(new InputStreamReader(process.getInputStream()))


    @tailrec def processOutput:Unit = {
      val line = processInput.readLine()
      if (line != null) {
        println(tag + line)
        processOutput
      } 
    } 

    processOutput

    process.waitFor
  }

  def timed[T](tag:String)(body: =>T):T = {
    val startTime = System.currentTimeMillis
    val result = body
    val resultTime = System.currentTimeMillis - startTime
    println(tag + " time " + resultTime + " ms")
    result
  } 

} 
