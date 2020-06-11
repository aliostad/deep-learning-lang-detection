package com.faacets
package polyta
package formats
package porta

import java.io.Writer

import spire.math.Rational
import spire.syntax.cfor._

import scalin.Vec
import scalin.immutable.dense._

final class IEQDataWrite extends FormatWrite[IEQData] {

  def writeDim(d: Int, out: Writer): Unit = {
    out.write("DIM = ")
    out.write(d.toString)
    out.write("\n\n")
  }

  def writeValid(valid: Vec[Rational], out: Writer): Unit = {
    out.write("VALID\n")
    Format.writeVectorSep[Rational](valid, " ", out)
    out.write("\n")
  }

  def writeLowerBounds(lowerBounds: Vec[Rational], out: Writer): Unit = {
    out.write("LOWER_BOUNDS\n")
    Format.writeVectorSep[Rational](lowerBounds, " ", out)
    out.write("\n")
  }

  def writeUpperBounds(upperBounds: Vec[Rational], out: Writer): Unit = {
    out.write("UPPER_BOUNDS\n")
    Format.writeVectorSep[Rational](upperBounds, " ", out)
    out.write("\n")
  }

  def writeEliminationOrder(d: Int, eliminationOrder: Seq[Int], out: Writer): Unit = {
    val indices = (eliminationOrder zip (1 to eliminationOrder.size)).toMap
    var prefix = ""
    out.write("ELIMINATION_ORDER\n")
    cforRange(0 until d) { k =>
      out.write(prefix)
      out.write(indices.getOrElse(k, 0).toString)
      prefix = " "
    }
    out.write("\n")
  }

  def writePolytope(dim: Int, poly: HPolytope[Rational], out: Writer): Unit = {

    out.write("INEQUALITIES_SECTION\n")
    val names = Format.x1toN(dim)

    cforRange(0 until poly.mA.nRows) { r =>
      Format.writeVector[Rational](poly.mA(r, ::), names, out)
      out.write(" <= ")
      out.write(poly.vb(r).toString)
      out.write("\n")
    }

    cforRange(0 until poly.mAeq.nRows) { r =>
      Format.writeVector[Rational](poly.mAeq(r, ::), names, out)
      out.write(" == ")
      out.write(poly.vbeq(r).toString)
      out.write("\n")
    }

    out.write("\n")
  }

  def writeEnd(out: Writer): Unit =
    out.write("END\n")

  def write(data: IEQData, out: Writer): Unit = {
    val dim = data.polytope.dim
    writeDim(dim, out)
    if (data.validPoint.toIndexedSeq.exists(!_.isZero))
      writeValid(data.validPoint, out)
    data.lowerBounds.foreach { writeLowerBounds(_, out) }
    data.upperBounds.foreach { writeUpperBounds(_, out) }
    data.eliminationOrder.foreach { writeEliminationOrder(dim, _, out) }
    writePolytope(dim, data.polytope, out)
    writeEnd(out)
  }
}
