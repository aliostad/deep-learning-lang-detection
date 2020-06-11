package im.mange.common

import sys.process._

class ProcessRunner(name: String, command: String, workingDirectory: String = "") {
  private val processBuilder = workingDirectory match {
    case "" => Process(command)
    case _ => Process(command, new java.io.File(workingDirectory))
  }

  //TODO: replace null with Option
  private var process: Process = null

  def start() = { process = processBuilder.run(); this }
  def start(logger: ProcessLogger) = { process = processBuilder.run(logger); this }

  def stop(destroy: Boolean = true, waitForExitValue: Boolean = true) {
    if (destroy) {
      process.destroy()
      println("### " + name + " destroyed")
    }

    if (waitForExitValue) {
      println("### " + name + " exited with value: " + process.exitValue())
    }
  }
}