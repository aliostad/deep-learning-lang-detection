package com.faacets
package polyta
package formats
package porta

import java.io.Writer

import spire.math.Rational
import spire.syntax.cfor._

import scalin.Mat
import scalin.immutable.dense._

final class POIDataWrite extends FormatWrite[POIData] {

  def writeDim(d: Int, out: Writer): Unit = {
    out.write("DIM = ")
    out.write(d.toString)
    out.write("\n\n")
  }

  def writeConv(vertices: Mat[Rational], out: Writer): Unit = {
    out.write("CONV_SECTION\n")
    cforRange(0 until vertices.nRows) { r =>
      Format.writeVectorSep[Rational](vertices(r, ::), " ", out)
      out.write("\n")
    }
    out.write("\n")
  }

  def writeCone(rays: Mat[Rational], out: Writer): Unit = {
    out.write("CONE_SECTION\n")
    cforRange(0 until rays.nRows) { r =>
      Format.writeVectorSep[Rational](rays(r, ::), " ", out)
      out.write("\n")
    }
    out.write("\n")
  }

  def writeEnd(out: Writer): Unit =
    out.write("END\n")

  def write(data: POIData, out: Writer): Unit = {
    writeDim(data.polytope.dim, out)
    if (data.polytope.mV.nRows > 0) writeConv(data.polytope.mV, out)
    if (data.polytope.mR.nRows > 0) writeCone(data.polytope.mR, out)
    writeEnd(out)
  }

}
