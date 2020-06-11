package com.faacets
package polyta
package formats
package sympol

import java.io.Writer

import net.alasc.perms.{Perm, Cycles}
import net.alasc.syntax.all._

trait SympolDataWrite {

  def writePermutation1(perm: Perm, out: Writer): Unit = {
    val elements = perm.toPermutation[Cycles].seq.map(_.seq.map(_ + 1).mkString(" "))
    out.write(elements.mkString(","))
  }

  def writeSymmetryInfo(si: SymmetryInfo, out: Writer): Unit = {
    out.write("permutation group\n")
    si.order.foreach { o =>
      out.write("* order ")
      out.write(o.toString)
      out.write("\n")
    }
    if (si.upToSymmetryWRTO)
      out.write("* w.r.t. to the original inequalities/vertices\n")
    out.write(si.generators.size.toString)
    out.write("\n")
    si.generators.foreach { perm =>
      out.write("  ")
      writePermutation1(perm, out)
      out.write("\n")
    }
    out.write(si.base.size.toString)
    out.write("\n")
    out.write("  ")
    out.write(si.base.mkString(" "))
    out.write("\n")
  }

}
