package com.softwaremill.supler_example.test

import com.typesafe.scalalogging.slf4j.LazyLogging

/**
 * @param shellCommand Command to run the process.
 * @param processGrepStrings Strings which will be used when grepping the process list to determine the process's pid.
 */
class KillableProcess(shellCommand: String, processGrepStrings: String*) extends LazyLogging {
  var process: Process = _

  def start(): Process = {
    process = new ProcessBuilder("sh",
      "-c",
      shellCommand).start()

    process
  }

  def sendSigInt() {
    sendSig(2)
  }

  def sendSigKill() {
    sendSig(9)
  }

  def sendSigTerm() {
    sendSig(15)
  }

  def sendSig(sig: Int) {
    for (pid <- readPids()) {
      logger.info(s"Sending signal $sig to pid $pid")
      Shell.runShellCommand("kill -"+sig+" "+pid).waitFor()
    }

    process = null
  }

  def readPids(): Iterator[String] = {
    Shell.readProcessPids(processGrepStrings: _*)
  }
}