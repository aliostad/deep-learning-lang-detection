package com.faacets
package polyta
package formats
package sympol

import java.io.Writer

import spire.math.Rational
import spire.syntax.cfor._

import scalin.immutable.dense._

class ExtDataWrite extends FormatWrite[ExtData] with SympolDataWrite {

  def writeHeader(upToSymmetry: Boolean, out: Writer): Unit = {
    out.write("V-representation\n")
    if (upToSymmetry) out.write("* UP TO SYMMETRY\n")
  }

  def writePolytope(poly: VPolytope[Rational], rayRows: Set[Int], out: Writer): Unit = {
    out.write("begin\n")
    val n = poly.mV.nRows + poly.mR.nRows
    require(rayRows.size == poly.mR.nRows)
    out.write(n.toString)
    out.write(" ")
    out.write((poly.dim + 1).toString)
    out.write(" rational\n")
    var vertC = 0
    var rayC = 0
    cforRange(0 until n) { c =>
      if (rayRows.contains(c)) {
        out.write("0 ")
        Format.writeVectorSep[Rational](poly.mR(rayC, ::), " ", out)
        rayC += 1
      } else {
        out.write("1 ")
        Format.writeVectorSep[Rational](poly.mV(vertC, ::), " ", out)
        vertC += 1
      }
      out.write("\n")
    }
    out.write("end\n")
  }

  def write(data: ExtData, out: Writer): Unit = {
    writeHeader(data.symmetryInfo.fold(false)(_.upToSymmetryWRTO), out)
    writePolytope(data.polytope, data.rayRows, out)
    data.symmetryInfo.foreach { writeSymmetryInfo(_, out) }
  }

}
