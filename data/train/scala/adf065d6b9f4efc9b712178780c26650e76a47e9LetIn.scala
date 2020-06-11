package de.tu_darmstadt.veritas.backend.fool

import de.tu_darmstadt.veritas.backend.fof.Term
import de.tu_darmstadt.veritas.backend.util.prettyprint.PrettyPrintWriter
import de.tu_darmstadt.veritas.backend.fof.PlainTerm
import de.tu_darmstadt.veritas.backend.fof.FofUnitary

final case class LetInFofUnitary(bindings: Seq[(Term, Term)], body: FofUnitary) extends FofUnitary {
  require(bindings.length > 0, "Cannot construct a let-in with 0 bindings")
  
  override def prettyPrint(writer: PrettyPrintWriter) = {
    writer.write("$let(")
    for ((t1, t2) <- bindings.dropRight(1)) {
      writer.write(t1).write(" := ")
      writer.write(t2).write("; ")
    }
    val (lastt1, lastt2) = bindings.last 
    writer.write(lastt1).write(" := ")
    writer.write(lastt2).write(", ")
    writer.write(body).write(")")
  }

}

final case class LetInTerm(bindings: Seq[(Term, Term)], body: Term) extends Term {
  require(bindings.length > 0, "Cannot construct a let-in with 0 bindings")
  
  override def prettyPrint(writer: PrettyPrintWriter) = {
    writer.write("$let(")
    for ((t1, t2) <- bindings.dropRight(1)) {
      writer.write(t1).write(" := ")
      writer.write(t2).write("; ")
    }
    val (lastt1, lastt2) = bindings.last 
    writer.write(lastt1).write(" := ")
    writer.write(lastt2).write(", ")
    writer.write(body).write(")")
  }

}
