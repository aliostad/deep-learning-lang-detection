package com.faacets
package polyta
package formats
package sympol

import java.io.Writer

import spire.math.Rational
import spire.syntax.cfor._

import scalin.immutable.dense._

class IneDataWrite extends FormatWrite[IneData] with SympolDataWrite {

  def writeHeader(upToSymmetry: Boolean, out: Writer): Unit = {
    out.write("H-representation\n")
    if (upToSymmetry) out.write("* UP TO SYMMETRY\n")
  }

  def writePolytope(poly: HPolytope[Rational], equalityRows: Set[Int], out: Writer): Unit = {
    val n = poly.mAeq.nRows + poly.mA.nRows
    require(equalityRows.size == poly.mAeq.nRows)
    if (equalityRows.nonEmpty) {
      out.write("linearity ")
      out.write(equalityRows.size)
      out.write(" ")
      out.write(equalityRows.toSeq.sorted.map(r => (r + 1).toString).mkString(" "))
      out.write("\n")
    }
    out.write("begin\n")
    out.write(n.toString)
    out.write(" ")
    out.write((poly.dim + 1).toString)
    out.write(" rational\n")
    var ineqR = 0
    var eqR = 0
    cforRange(0 until n) { r =>
      if (equalityRows.contains(r)) {
        out.write(poly.vbeq(eqR).toString)
        out.write(" ")
        Format.writeVectorSep[Rational](-poly.mAeq(eqR, ::), " ", out)
        eqR += 1
      } else {
        out.write(poly.vb(ineqR).toString)
        out.write(" ")
        Format.writeVectorSep[Rational](-poly.mA(ineqR, ::), " ", out)
        ineqR += 1
      }
      out.write("\n")
    }
    out.write("end\n")
  }

  def write(data: IneData, out: Writer): Unit = {
    writeHeader(data.symmetryInfo.fold(false)(_.upToSymmetryWRTO), out)
    writePolytope(data.polytope, data.equalityRows, out)
    data.symmetryInfo.foreach { writeSymmetryInfo(_, out) }
  }

}
