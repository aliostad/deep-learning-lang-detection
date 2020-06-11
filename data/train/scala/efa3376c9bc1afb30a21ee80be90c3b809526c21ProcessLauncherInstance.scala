package com.outr.jefe.launch

import scribe.Logging

class ProcessLauncherInstance(builder: ProcessBuilder) extends LauncherInstance with Logging {
  private lazy val process = builder.inheritIO().start()
  lazy val processId: Int = {
    val field = process.getClass.getDeclaredFields.find(f => f.getName == "pid" || f.getName == "handle").get
    field.setAccessible(true)
    field.get(process).asInstanceOf[Int]
  }

  override def start(): Unit = synchronized {
    _status := LauncherStatus.Starting
    process
    new Thread {
      // TODO: handle this better
      override def run(): Unit = {
        _status := LauncherStatus.Running
        while (process.isAlive) {
          Thread.sleep(10)
        }
        val exitValue = process.exitValue()
        if (exitValue == 0) {

        }
        _status := LauncherStatus.Finished
      }
    }
  }

  override def stop(): Unit = {
    process.destroy()
  }
}
