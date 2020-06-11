package ch.usi.inf.l3.ifj.debug

import ch.usi.inf.l3._
import elang.ast._
import elang.namer._
import elang.typecheck._
import elang.debug._
import fj.ast._
import fj.debug._
import fj.namer._
import ifj.ast._

trait IFJAlgDebug extends IFJAlg[Show] with FJAlgDebug {
  // Re-writing the defs just for convenience


  def Interface(name: String, parents: List[Show], 
              ms: List[Show], pos: Position, 
              symbol: ClassSymbol): Show = {
    new Show {
      
      def show(col: Int = 0): String = {
        val extnds = parents match {
          case Nil => ""
          case ls => "extends " + ls.map(_.show()).mkString(", ")
        }
        s"""|${tab(col)}interface ${name} ${extnds} {
            |${showList(ms, "\n", col + 2)}
            |${tab(col)}}""".stripMargin

        }
      def loc(col: Int = 0): String = s"${tab(col)}${pos}"
    }
  }

  def ClassDef(name: String, parent: Show, 
              impls: List[Show], fields: List[Show], 
              const: Show, ms: List[Show], 
              pos: Position, symbol: ClassSymbol): Show = {
    impls match {
      case Nil => super[FJAlgDebug].ClassDef(name, parent, fields, 
                                              const, ms, pos, symbol)
      case _ =>
        new Show {
          def show(col: Int = 0): String = {
            val extnds = s"extends ${parent.show()}"
            val intrs = "implements " + impls.map(_.show()).mkString(", ")
            s"""|${tab(col)}class ${name} ${extnds} ${intrs} {
                |${showList(fields, "\n", col + 2)}
                |${const.show(2)}
                |${showList(ms, "\n", col + 2)}
                |${tab(col)}}""".stripMargin
          }
          def loc(col: Int = 0): String = s"${tab(col)}${pos}"
        }
    } 
  }

  def AbstractMethod(tpe: Show, name: String, 
              params: List[Show], pos: Position, 
              symbol: TermSymbol): Show = {
    new Show {
        def show(col: Int = 0): String = 
        s"${tab(col)}${tpe}(${showList(params, ", ", 0)});"
      def loc(col: Int = 0): String = s"${tab(col)}${pos}"
    }
  }

}


object IFJAlgDebug extends IFJAlgDebug
