package org.odfi.indesign.core.module.process

import java.io.ByteArrayOutputStream
import java.io.BufferedInputStream
import org.odfi.indesign.core.harvest.HarvestedResource
import com.idyria.osi.tea.thread.ThreadLanguage

class IDProcess(val processBuilder: ProcessBuilder) extends HarvestedResource with ThreadLanguage {

  var process: Option[Process] = None

  def getId = process match {
    case None => "0"
    case Some(p) => p.toString()
  }

  // IO
  //-------------
  def inheritIO = process match {
    case None =>
      processBuilder.redirectErrorStream(true)
      processBuilder.redirectOutput(ProcessBuilder.Redirect.INHERIT)
    //processBuilder.inheritIO()
    case _ => throw new RuntimeException("Process Already Started")
  }

  var outputBufferThread: Option[Thread] = None
  var outputBuffer: Option[ByteArrayOutputStream] = None

  def outputToBuffer = process match {

    case None =>

      var th = createThread {

        // Started when the process starts 
        var br = process.get.getInputStream

        // Output buffer
        outputBuffer = Some(new ByteArrayOutputStream(4096))

        // Read
        var bytes = new Array[Byte](4096)
        var read = br.read(bytes)
        while (read >= 0) {
          outputBuffer.get.write(bytes, 0, read)
          read = br.read(bytes)
        }

        // Finish
        this.outputBufferThread = None

      }
      this.outputBufferThread = Some(th)

      //-- Redirect Error Stream to stdout
      processBuilder.redirectErrorStream(true)

    case _ => throw new RuntimeException("Process Already Started")
  }

  def getOutputBuffer = outputBuffer match {
    case Some(ob) => ob
    case None =>
      throw new RuntimeException("No Output Buffer Available, maybe process was not started using outputToBuffer")
  }

  def getOutputString = new String(getOutputBuffer.toByteArray())

  // Start/Stop
  //-----------------

  def startProcess = process match {
    case po if (po.isEmpty || !po.get.isAlive) =>
      //processBuilder.redirectErrorStream(true)
      println("Start: " + processBuilder.command())
      var p = processBuilder.start
      this.process = Some(p)

      // Output buffer start ?
      this.outputBufferThread match {
        case Some(th) => th.start
        case None =>
      }

    case Some(p) => throw new RuntimeException("Process Already Started")
  }

  /**
   * Returns return code
   */
  def startProcessAndWait = {
    this.startProcess
    waitOnProcess
  }

  def waitOnProcess = this.process match {
    case Some(p) if (p.isAlive) =>
      this.process.get.waitFor()
      this.process = None

    case Some(p) =>
      this.process = None
    case _ =>

  }

  def killProcess = process match {
    case None =>
      throw new RuntimeException("Cannot kill non started tool")

    case Some(p) =>
      p.destroyForcibly()
      process = None
  }

  // Cleaning
  //----------------

  this.onClean {
    process match {

      case Some(p) =>
        throw new RuntimeException("Cannot clean during tool run")

      case None =>
        this.outputBuffer = None
        this.outputBufferThread = None
        System.gc
    }
  }
}
