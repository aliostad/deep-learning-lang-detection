package ch.usi.inf.l3.fjexpr.debug


import ch.usi.inf.l3._
import elang.debug._
import fj.debug._
import elang.namer._
import fjexpr.ast._
import elang.ast._
import elang.analyzer._

trait FJExprDebug extends FJExprAlg[Show] with FJAlgDebug {
  def BinOp(lhs: Show, op: Bop, rhs: Show, 
          pos: Position, symbol: UseSymbol): Show = {
    new Show {
      def show(col: Int = 0): String = 
        s"${tab(col)}${lhs.show(col)} ${op.name} ${rhs.show(col)}"
      def loc(col: Int = 0): String = s"${tab(col)}${pos}"
    }
  }

  def UniOp(op: Uop, expr: Show, pos: Position, symbol: UseSymbol): Show = {
    new Show {
      def show(col: Int = 0): String = 
        s"${tab(col)}${op.name}${expr.show(col)}"
      def loc(col: Int = 0): String = s"${tab(col)}${pos}"
    }
  }

  def Literal(v: Int, pos: Position): Show = {
    new Show {
      def show(col: Int = 0): String = 
        s"${tab(col)}${v.toString}"
      def loc(col: Int = 0): String = s"${tab(col)}${pos}"
    }
  }
  def Literal(v: Double, pos: Position): Show = {
    new Show {
      def show(col: Int = 0): String = 
        s"${tab(col)}${v.toString}"
      def loc(col: Int = 0): String = s"${tab(col)}${pos}"
    }
  }
  def Literal(v: Boolean, pos: Position): Show = {
    new Show {
      def show(col: Int = 0): String = 
        s"${tab(col)}${v.toString}"
      def loc(col: Int = 0): String = s"${tab(col)}${pos}"
    }
  }
  def Literal(v: String, pos: Position): Show = {
    new Show {
      def show(col: Int = 0): String = s"""${tab(col)}"${v}""""
      def loc(col: Int = 0): String = s"${tab(col)}${pos}"
    }
  }
  def NullLiteral(pos: Position): Show = {
    new Show {
      def show(col: Int = 0): String = s"${tab(col)}null"
      def loc(col: Int = 0): String = s"${tab(col)}${pos}"
    }
  }
}

object FJExprDebug extends FJExprDebug
