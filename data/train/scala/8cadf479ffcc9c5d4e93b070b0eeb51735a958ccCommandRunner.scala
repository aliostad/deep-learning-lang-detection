package com.mle.idea.sbtexecutor

import com.intellij.execution.ui.{ConsoleView, ConsoleViewContentType}
import scala.concurrent.Future
import scala.io.Source
import scala.concurrent.ExecutionContext.Implicits.global
import scala.collection.JavaConversions._
import CommandRunner._

/**
 * TODO concurrent programming
 *
 * @author mle
 */
class CommandRunner(console: ConsoleView) {
  // runs the SBT command in the background
  private var javaBackgroundProcess: Option[java.lang.Process] = None

  /**
   *
   * @return the exit value wrapped in an Option or None if the process is running, was canceled or has not been started
   */
  def exitValue: Option[Int] = javaBackgroundProcess.map(CommandRunner.exitValue).flatten

  def isRunning = javaBackgroundProcess.exists(p => CommandRunner.exitValue(p).isEmpty)

  def runJavaProcess(builder: java.lang.ProcessBuilder) {
    javaBackgroundProcess.foreach(_.destroy())
    console.clear()
    val commandString = builder.command().mkString(" ") + newLine
    console.print(commandString, ConsoleViewContentType.SYSTEM_OUTPUT)
    val process = builder.start()
    javaBackgroundProcess = Some(process)
    Future {
      val is = Source.fromInputStream(process.getInputStream)
      try {
        is.getLines().foreach(line => {
          console print(line + newLine, ConsoleViewContentType.NORMAL_OUTPUT)
        })
      } finally {
        is.close()
      }
    }
  }

  def cancelJavaProcess() {
    javaBackgroundProcess.foreach(_.destroy())
    javaBackgroundProcess = None
  }

  //  private var backgroundProcess: Option[Process] = None

  //  private val consoleLogger = ProcessLogger(
  //    out => console.print(out + "\n", ConsoleViewContentType.NORMAL_OUTPUT),
  //    err => console.print(err + "\n", ConsoleViewContentType.ERROR_OUTPUT)
  //  )

  /**
   *
   * @see runJavaProcess
   */
  //  def runProcess(builder: ProcessBuilder) {
  //    backgroundProcess.foreach(_.destroy())
  //    console.clear()
  //    backgroundProcess = Some(builder run consoleLogger)
  //  }


  /**
   * Throws ThreadDeath, causing plugin to explode. Using java.lang.Process for now,
   * which does not exhibit that behavior upon destruction.
   *
   * TODO: get this working and cut the java bs
   * @see cancelJavaProcess
   */
  //  def cancelProcess() {
  //    backgroundProcess.foreach(_.destroy())
  //    backgroundProcess = None
  //  }
}

object CommandRunner {
  def exitValue(process: Process): Option[Int] =
    try {
      Some(process.exitValue())
    } catch {
      case itse: IllegalThreadStateException =>
        None
    }

  val newLine = sys.props("line.separator")
}
