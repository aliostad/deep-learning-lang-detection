package dzufferey.smtlib

import dzufferey.utils.Logger
import dzufferey.utils.LogLevel._
import java.io._
import Names._

object Printer {
  
  def printable(str: String): String = {
    assert(str.length > 0)
    val noDollars = str.replace("$","_")
    if (noDollars startsWith "_") "v" + noDollars
    else noDollars
  }

  protected def asDecl(v: Variable): String = {
    "(" + printable(v.name) + " " + tpe(v.tpe) + ")"
  }
  
  protected def printAttribute(a: Attribute)(implicit writer: BufferedWriter) {
    writer.write(a.keyword)
    a match {
      case AttrKeyword(_) =>
        ()
      case AttrSymbol(_, s) =>
        writer.write(" ")
        writer.write(s)
      case AttrExpr(_, exprs) =>
        writer.write(" ")
        writer.write("(")
        exprs.foreach( e => {
          printFormula1(e)
          writer.write(" ")
        })
        writer.write(")")
    }
  }


  protected def printQuantifier(q: String, vars: Iterable[Variable], f: Formula)(implicit writer: BufferedWriter) {
    writer.write("(")
    writer.write(q)
    writer.write(vars.map(asDecl).mkString(" (", " ", ") "))
    printFormula(f)
    writer.write(")")
  }

  protected def printFormula(f: Formula)(implicit writer: BufferedWriter): Unit = {
    if (f.attributes.nonEmpty) {
      writer.write("(! ")
      printFormula1(f)
      f.attributes.foreach( a => {
        writer.write(" ")
        printAttribute(a)
      })
      writer.write(")")
    } else {
      printFormula1(f)
    }
  }

  protected def printFormula1(f: Formula)(implicit writer: BufferedWriter): Unit = f match {
    case Exists(vars, f2) => printQuantifier("exists", vars, f2)
    case ForAll(vars, f2) => printQuantifier("forall", vars, f2)
    case Variable(v) => writer.write(printable(v))
    case Literal(l: Byte) => if (l >= 0) writer.write(l.toString) else writer.write("(- " + (-l).toString + ")")
    case Literal(l: Short) => if (l >= 0) writer.write(l.toString) else writer.write("(- " + (-l).toString + ")")
    case Literal(l: Int) => if (l >= 0) writer.write(l.toString) else writer.write("(- " + (-l).toString + ")")
    case Literal(l: Long) => if (l >= 0) writer.write(l.toString) else writer.write("(- " + (-l).toString + ")")
    case Literal(l: Float) => if (l >= 0.0) writer.write(l.toString) else writer.write("(- " + (-l).toString + ")")
    case Literal(l: Double) => if (l >= 0.0) writer.write(l.toString) else writer.write("(- " + (-l).toString + ")")
    case Literal(l) => writer.write(l.toString)
    case d @ Divides(a, b) if d.tpe == Real =>
        writer.write("( / ")
        printFormula(a)
        writer.write(" ")
        printFormula(b)
        writer.write(")")
    case app @ Application(fct, args) => 
      val params = FormulaUtils.typeParams(app)
      if (!args.isEmpty) {
        writer.write("(")
        writer.write(printable(overloadedSymbol(fct, params)))
        for (a <- args) {
          writer.write(" ")
          printFormula(a)
        }
        writer.write(")")
      } else {
        writer.write(printable(overloadedSymbol(fct, params)))
      }
  }

  def toString(f: Formula)= {
    val w1 = new StringWriter
    val w2 = new BufferedWriter(w1)
    apply(w2, f)
    w2.flush
    w2.close
    w1.toString
  }

  def apply(implicit writer: BufferedWriter, f: Formula) {
    printFormula(f)
    //writer.newLine
  }
  
  def apply(implicit writer: BufferedWriter, cmd: Command) = cmd match {
    case Assert(f) =>
      writer.write("(assert ")
      printFormula(f)
      writer.write(")")

    case DeclareSort(id, arity) =>
      writer.write("(declare-sort ")
      writer.write(printable(id))
      writer.write(" ")
      writer.write(arity.toString)
      writer.write(")")

    case DeclareFun(id, sig) =>
      writer.write("(declare-fun ")
      writer.write(printable(id))
      writer.write(" ")
      writer.write(typeDecl(sig))
      writer.write(")")

    case DefineSort(id, args, ret) =>
      writer.write("(define-sort ")
      ???
      writer.write(")")

    case DefineFun(id, args, ret, body) =>
      writer.write("(define-fun ")
      ???
      writer.write(")")

    case Exit => writer.write("(exit)")
    case CheckSat => writer.write("(check-sat)")
    case GetModel => writer.write("(get-model)")
    case Push => writer.write("(push 1)")
    case Pop => writer.write("(pop 1)")

    case GetValue(ts) =>
      writer.write("(get-value (")
      for (t <- ts) {
        printFormula(t)
        writer.write(" ")
      }
      writer.write("))")

    case SetOption(opt, value) =>
      //TODO sanitizing value
      writer.write("(set-option :" + opt + " " + value + ")")
  }

}
