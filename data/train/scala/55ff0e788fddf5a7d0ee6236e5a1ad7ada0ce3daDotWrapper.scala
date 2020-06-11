package de.jowisoftware.mining.external.dot

import java.io.File
import scala.io.Source
import java.io.BufferedWriter
import java.io.OutputStreamWriter
import javax.imageio.ImageIO
import grizzled.slf4j.Logging
import java.awt.image.BufferedImage

class DotWrapper(dotPath: File) extends Logging {
  def run(input: String): BufferedImage = {
    val process = startProcess

    writeDot(input, process)
    val image = ImageIO.read(process.getInputStream)
    dumpError(process)

    process.waitFor
    image
  }

  private def writeDot(input: String, process: Process) {
    val stdIn = process.getOutputStream
    val writer = new BufferedWriter(new OutputStreamWriter(stdIn))
    writer.write(input)
    writer.close
  }

  private def startProcess: Process = {
    val builder = new ProcessBuilder
    builder.command(dotPath.getCanonicalPath, "-Tpng")
    val process = builder.start
    process
  }

  private def dumpError(process: Process) {
    val lines = Source.fromInputStream(process.getErrorStream).getLines
    for (line <- lines) {
      error("dot: "+line)
    }
  }
}