package com.seanshubin.builder.core

import java.nio.file.Path

import scala.collection.JavaConverters._
import scala.sys.process._

class SystemExecutorImpl(processLoggerFactory: ProcessLoggerFactory) extends SystemExecutor {
  override def executeSynchronous(command: Seq[String], directory: Path): ExecutionResult = {
    val env: Seq[(String, String)] = System.getenv().asScala.toSeq
    val processBuilder: ProcessBuilder = Process(command, directory.toFile, env: _*)
    val processLogger = processLoggerFactory.newProcessLogger(command, directory, env)
    val process: Process = processBuilder.run(processLogger)
    val exitCode = process.exitValue()
    val outputLines: Seq[String] = processLogger.outputLines
    val errorLines: Seq[String] = processLogger.errorLines
    ExecutionResult(command, exitCode, directory, outputLines, errorLines)
  }
}
