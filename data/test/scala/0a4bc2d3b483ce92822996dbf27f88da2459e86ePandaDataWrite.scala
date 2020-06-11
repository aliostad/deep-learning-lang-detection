package com.faacets
package polyta
package formats
package panda

import java.io.Writer

import spire.math.Rational

trait PandaDataWrite extends Any {

  def writeDim(dim: Int, out: Writer): Unit = {
    out.write("DIM=")
    out.write(dim.toString)
    out.write("\n")
  }

  def writeNames(names: Seq[String], out: Writer): Unit = {
    out.write("Names:\n")
    out.write(names.mkString(" "))
    out.write("\n")
  }

  def writeMaps(maps: Seq[AffineTransform[Rational]], names: Seq[String], out: Writer): Unit = {
    out.write("Maps:\n")
    val afp = new AffineTransformWrite(names)
    maps.foreach { affineTransform =>
      afp.write(affineTransform, out)
      out.write("\n")
    }
  }

}
