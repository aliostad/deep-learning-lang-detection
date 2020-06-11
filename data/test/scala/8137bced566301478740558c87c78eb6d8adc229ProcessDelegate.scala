package com.seanshubin.utility.exec

import java.io.{InputStream, OutputStream}
import java.util.concurrent.TimeUnit

class ProcessDelegate(process: Process) extends ProcessContract {
  override def getOutputStream: OutputStream = process.getOutputStream

  override def getInputStream: InputStream = process.getInputStream

  override def getErrorStream: InputStream = process.getErrorStream

  override def waitFor: Int = process.waitFor()

  override def waitFor(timeout: Long, unit: TimeUnit): Boolean = process.waitFor(timeout, unit)

  override def exitValue: Int = process.exitValue()

  override def destroy(): Unit = process.destroy()

  override def destroyForcibly: ProcessContract = new ProcessDelegate(process.destroyForcibly())

  override def isAlive: Boolean = process.isAlive
}
