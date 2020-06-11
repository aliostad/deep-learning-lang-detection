package gridderface

import sys.process._
import java.awt.Image
import java.io._

object ImageTransferHack {
  def getImage(): Status[Image] = {
    var ret: Status[Image] = Failed("could not run pngpaste")
    def dumpImage(input: InputStream) = {
      ret = Success(javax.imageio.ImageIO.read(input))
      input.close()
    }
    try {
      Seq("pngpaste","-").run(new ProcessIO(_.close(), dumpImage _, _.close(), true)).exitValue() // block
    } catch {
      case e: Exception => ret = Failed("attempt to run pngpaste failed: " + e.getMessage)
    }
    ret
  }
}
