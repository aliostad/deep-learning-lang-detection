package de.tu_darmstadt.veritas.backend.fool

import de.tu_darmstadt.veritas.backend.fof.PlainTerm
import de.tu_darmstadt.veritas.backend.fof.FofUnitary
import de.tu_darmstadt.veritas.backend.util.prettyprint.PrettyPrintWriter
import de.tu_darmstadt.veritas.backend.fof.Term

final case class IfThenElseFofUnitary(g: FofUnitary, t: FofUnitary, e: FofUnitary) extends FofUnitary {
  override def prettyPrint(writer: PrettyPrintWriter) = {
    writer.write("$ite(")
    writer.write(g).write(", ")
    writer.write(t).write(", ")
    writer.write(e).write(")")
  }
  
  override def toString = s"IfThenElse($g, $t, $e)"

}

final case class IfThenElseTerm(g: FofUnitary, t: Term, e: Term) extends Term {
  override def prettyPrint(writer: PrettyPrintWriter) = {
    writer.write("$ite(")
    writer.write(g).write(", ")
    writer.write(t).write(", ")
    writer.write(e).write(")")
  }
  
  override def toString = s"IfThenElse($g, $t, $e)"

}

