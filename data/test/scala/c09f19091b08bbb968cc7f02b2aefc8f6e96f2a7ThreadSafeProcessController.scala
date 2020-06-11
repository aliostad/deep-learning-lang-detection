package molmed.queue.engine.parallelshell

import org.broadinstitute.gatk.queue.util.Logging
import org.broadinstitute.gatk.utils.runtime.ProcessSettings
import org.broadinstitute.gatk.utils.runtime.ProcessOutput
import scala.sys.process.FileProcessLogger
import scala.sys.process._

class ThreadSafeProcessController extends Logging {

  private var process: Option[Process] = None

  /**
   * TODO Write docs...
   */
  def exec(processSettings: ProcessSettings): Int = {

    val commandLine: ProcessBuilder = processSettings.getCommand.mkString(" ")

    logger.debug("Trying to start process: " + commandLine)

    val outputFile = processSettings.getStdoutSettings.getOutputFile
    val processLogger = new FileProcessLogger(outputFile)

    process = Some(commandLine.run(processLogger))
    process.get.exitValue()

  }

  /**
   * TODO Write docs...
   */
  def tryDestroy(): Unit = {
    logger.debug("Trying to kill process")
    process.getOrElse {
      throw new IllegalStateException("Tried to kill unstarted job.")
    }.destroy()
  }

}