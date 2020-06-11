package com.mayreh.kaiyote.backend

import com.mayreh.kaiyote.data.{Stderr, Stdout}

import scala.sys.process.{Process, ProcessLogger}

/**
 * Provides features to execute commands.
 */
trait Exec extends Backend {
  def runCommand(cmd: Command): CommandResult = {
    val builder = Process(cmd.command)

    val stdoutLog = StringBuilder.newBuilder
    val stderrLog = StringBuilder.newBuilder

    val processLogger = ProcessLogger(stdoutLog ++= _, stderrLog ++= _)

    val status = builder.run(processLogger).exitValue()

    CommandResult(
      Stdout(stdoutLog.result()),
      Stderr(stderrLog.result()),
      status
    )
  }
}
