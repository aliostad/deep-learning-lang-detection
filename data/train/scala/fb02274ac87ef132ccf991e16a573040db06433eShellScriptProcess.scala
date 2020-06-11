package com.sos.scheduler.engine.taskserver.task.process

import com.sos.scheduler.engine.common.process.Processes
import com.sos.scheduler.engine.common.process.Processes._
import com.sos.scheduler.engine.common.scalautil.FileUtils.implicits._
import com.sos.scheduler.engine.taskserver.data.TaskServerConfiguration.Encoding
import com.sos.scheduler.engine.taskserver.task.process.RichProcess._
import java.nio.file.Path
import scala.concurrent.{ExecutionContext, Promise}
import scala.util.control.NonFatal

/**
  * @author Joacim Zschimmer
  */
final class ShellScriptProcess private(
  processConfiguration: ProcessConfiguration,
  process: Process,
  private[process] val temporaryScriptFile: Path,
  argumentsForLogging: Seq[String])
  (implicit executionContext: ExecutionContext)
extends RichProcess(processConfiguration, process, argumentsForLogging) {

  private val scriptFileDeletedPromise = Promise[Boolean]()

  def scriptFileDeleted = scriptFileDeletedPromise.future

  stdin.close() // Process gets an empty stdin
  closed.onComplete { _ ⇒
    val deleted = tryDeleteFiles(List(temporaryScriptFile))
    scriptFileDeletedPromise.success(deleted)
  }
}

object ShellScriptProcess {
  def startShellScript(
    processConfiguration: ProcessConfiguration = ProcessConfiguration(),
    name: String = "shell-script",
    scriptString: String)
    (implicit executionContext: ExecutionContext): ShellScriptProcess =
  {
    val shellFile = newTemporaryShellFile(name, processConfiguration.logon map { _.user })
    try {
      shellFile.write(scriptString, Encoding)
      val conf = processConfiguration.copy(fileOption = Some(shellFile))
      val process = startProcessBuilder(conf, shellFile) {
        _.startRobustly(start = Processes.startProcess(_, processConfiguration.logon))
      }
      new ShellScriptProcess(conf, process, shellFile, argumentsForLogging = name :: Nil)
    }
    catch { case NonFatal(t) ⇒
      RichProcess.tryDeleteFiles(List(shellFile))
      throw t
    }
  }
}
