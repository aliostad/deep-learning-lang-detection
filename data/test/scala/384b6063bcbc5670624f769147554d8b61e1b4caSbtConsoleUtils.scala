package com.besuikerd.playtest.console

import java.io.File

import play.core.server.{ServerWithStop, ServerProcess, RealServerProcess, ProdServerStart}

object SbtConsoleUtils {
  private var process:ServerWithStop = null

  def startApplication(): Unit = {
    if(process == null){
      process = ProdServerStart.start(new RealServerProcess(Seq.empty))
    } else{
      println("process is already started")
    }
  }

  def stopApplication(): Unit = {
    if(process != null){
      process.stop()
      new File("RUNNING_PID").delete()
      process = null
    } else{
      println("process is not started")
    }
  }
}
