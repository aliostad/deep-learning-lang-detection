package ch.usi.inf.l3.fj.debug

import ch.usi.inf.l3.elang.ast._
import ch.usi.inf.l3.elang.namer._
import ch.usi.inf.l3.elang.debug._
import ch.usi.inf.l3.fj.ast._

trait FJAlgDebug extends FJAlg[Show] {
  val level = 2
  def tab(c: Int = 0) = " " * (c * level) 

  protected def showList(l: List[Show], delim: String = ", ",
    col: Int): String = {
    val s = if(delim != ", ") "\n" else ""
    s ++ l.map(_.show(col)).mkString(delim)
  }
  protected def locList(l: List[Show], col: Int = 0): String = {
    l.foldLeft("")((z, y) => {
        z ++ "\n" ++ y.loc(col)
      })
  }

  def Program(classes: List[Show], main: Show): Show = {
    new Show {
      def show(col: Int = 0): String = 
        tab(col) ++ main.show(col) ++ showList(classes, "\n", 0)
      def loc(col: Int = 0): String = 
        tab(col) ++ main.loc(col) ++ locList(classes)
    }
  }

  def ClassDef(name: String, parent: Show, fields: List[Show], 
            const: Show, ms: List[Show], 
            pos: Position, symbol: ClassSymbol): Show = {
    new Show {
      def show(col: Int = 0): String = 
        s"""|${tab(col)}class ${name} extends ${parent.show()} {
            |${showList(fields, "\n", col + 2)}
            |${const.show(2)}
            |${showList(ms, "\n", col + 2)}
            |${tab(col)}}""".stripMargin
      def loc(col: Int = 0): String = s"${tab(col)}${pos}"
    }
  }

  def ConstDef(tpe: Show, params: List[Show], 
    su: Show, finit: List[Show], 
    pos: Position, symbol: TermSymbol): Show = {
    new Show {
      def show(col: Int = 0): String = 
        s"""|${tab(col)}${tpe.show()}(${showList(params, ", ", 0)}) {
            |${su.show(col + 2)}
            |${showList(finit, "\n", col + 2)}
            |${tab(col)}}""".stripMargin
      def loc(col: Int = 0): String = s"${tab(col)}${pos}"
    }
  }

  def FieldInit(name: Show, rhs: Show,
          pos: Position, sym: UseSymbol): Show = {
    new Show {
      def show(col: Int = 0): String = 
        s"${tab(col)}${name.show()} = ${rhs.show()}"
      def loc(col: Int = 0): String = s"${tab(col)}${pos}"
    }
  }

  def Super(exprs: List[Show], pos: Position, symbol: UseSymbol): Show = {
    new Show {
      def show(col: Int = 0): String = 
        s"${tab(col)}super(${showList(exprs, ", ", 0)})"
      def loc(col: Int = 0): String = s"${tab(col)}${pos}"
    }
  }

  def MethodDef(tpe: Show, name: String, 
        params: List[Show], body: Show, 
        pos: Position, symbol: TermSymbol): Show = {
    new Show {
      def show(col: Int = 0): String = 
        s"""|${tab(col)}${tpe}(${showList(params, ", ", 0)}) {
            |${body.show(col + 2)}
            |${tab(col)}}""".stripMargin
      def loc(col: Int = 0): String = s"${tab(col)}${pos}"
    }
  }

  def ValDef(tpe: Show, name: String, 
        pos: Position, symbol: TermSymbol): Show = {
    new Show {
      def show(col: Int = 0): String = s"${tab(col)}${tpe.show()} ${name}"
      def loc(col: Int = 0): String = s"${tab(col)}${pos}"
    }
  }


  def Ident(name: String, pos: Position, symbol: UseSymbol): Show = {
    new Show {
      def show(col: Int = 0): String = s"${tab(col)}${name}"
      def loc(col: Int = 0): String = s"${tab(col)}${pos}"
    }
  }

  def This(pos: Position, symbol: UseSymbol): Show = {
    new Show {
      def show(col: Int = 0): String = s"${tab(col)}this"
      def loc(col: Int = 0): String = s"${tab(col)}${pos}"
    }
  }

  def Select(s: Show, m: String, pos: Position, sym: UseSymbol): Show = {
    new Show {
      def show(col: Int = 0): String = s"${tab(col)}${s.show()}.${m}"
      def loc(col: Int = 0): String = s"${tab(col)}${pos}"
    }
  }
  
  def Apply(expr: Show, m: String, args: List[Show], 
        pos: Position, sym: UseSymbol): Show = {
    new Show {
      def show(col: Int = 0): String = 
        s"${tab(col)}${expr.show()}.${m}(${showList(args, ", ", 0)})"
      def loc(col: Int = 0): String = s"${tab(col)}${pos}"
    }
  }

  def New(id: Show, args: List[Show], pos: Position,
          sym: UseSymbol): Show = {
    new Show {
      def show(col: Int = 0): String = 
        s"${tab(col)}new ${id}(${showList(args, ", ", 0)})"
      def loc(col: Int = 0): String = s"${tab(col)}${pos}"
    }
  }

  def Cast(id: Show, expr: Show, pos: Position,
          sym: UseSymbol): Show = {
    new Show {
      def show(col: Int = 0): String = 
        s"${tab(col)}(${id.show()}) ${expr.show()}" 
      def loc(col: Int = 0): String = s"${tab(col)}${pos}"
    }
  }
}

object FJAlgDebug extends FJAlgDebug
