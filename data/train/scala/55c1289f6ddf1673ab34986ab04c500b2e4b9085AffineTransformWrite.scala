package com.faacets
package polyta
package formats
package panda

import java.io.Writer


import spire.math.Rational
import spire.syntax.cfor._
import spire.util._

import scalin.Vec
import scalin.immutable.dense._

class AffineTransformWrite(val variableNames: Seq[String]) extends FormatWrite[AffineTransform[Rational]] {

  def writeImage(v: Vec[Rational], constant: Rational, out: Writer): Unit = {
    Format.writeVector(v, variableNames, out, constantOpt = Opt(constant), withSpaces = false)
    if (constant != 0) {
      if (constant > 0)
        out.write("+")
      out.write(constant.toString)
    }
  }

  def write(data: AffineTransform[Rational], out: Writer): Unit = {
    var space = ""
    cforRange(0 until data.dim) { r =>
      out.write(space)
      writeImage(data.mA(r, ::), data.vb(r), out)
      space = " "
    }
  }

}
