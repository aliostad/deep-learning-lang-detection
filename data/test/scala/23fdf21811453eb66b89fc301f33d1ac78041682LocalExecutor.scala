package org.zenmode.commands.executor

import sys.process.{Process, ProcessBuilder}
import java.io.File
import org.zenmode.commands.util.SimpleProcessLogger
import org.zenmode.commands.result.SingleResult

class LocalExecutor extends Executor {

  override def execute(
    appPath: String,
    args:    Iterable[String]    = Nil,
    workDir: String              = LocalExecutor.currentDir,
    env:     Map[String, String] = Map.empty
  ) = {
    val process = Process(appPath :: args.toList, new File(workDir), env.toSeq: _*)
    executeWithLogger(process)
  }

  private def executeWithLogger(process: ProcessBuilder) = {
    val logger = new SimpleProcessLogger
    val exitCode = process ! logger
    SingleResult(exitCode, logger.stdout, logger.stderr)
  }

}

object LocalExecutor {
  val currentDir = "."
}
