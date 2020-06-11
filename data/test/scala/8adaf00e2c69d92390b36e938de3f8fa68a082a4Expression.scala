package ast.keith_example

/**
 * Created by liliya on 23/05/2015.
 */

  sealed trait Expression

  final case class Num1(n: Int) extends Expression

  final case class Plus(n1: Expression, n2: Expression) extends Expression

  final case class Mul(n1: Expression, n2: Expression) extends Expression

  final case class Sub(n1: Expression, n2: Expression) extends Expression

  object Expression {
    def evaluate(e: Expression): Int = e match {
      case Num1(n) => n
      case Plus(n1, n2) => evaluate(n1) + evaluate(n2)
      case Mul(n1, n2) => evaluate(n1) * evaluate(n2)
      case Sub(n1, n2) => evaluate(n1) - evaluate(n2)
    }
    
    def show(e:Expression):String = e match {

      case Num1(n) => n.toString
      case Plus(a, b)=> show(a) + " + " + show(b)
      case Mul(a, b) => (a, b) match {
        case (Plus(`a`, `b`), z) => "( "+ show(`a`) + " + " + show(`b`) + " )" + " * " +  show(z)
          //backticks prevent the suspicious shadowing of variable - refers to stable variable in scope
        case (z, Plus(x, y)) =>  show(z) +  " * "  + "( "+ show(x) + " + " + show(y) + " )"
        case (Plus(d, f), Plus(x, y)) =>   "( "+ show(d) + " + " + show(f) + " )"+  " * "  + "( "+ show(x) + " + " + show(y) + " )"
        case(any, other) => show(any) + " * " + show(other)
      }
      case Sub(a, b) => (a, b) match {
        case (Sub(x, y), z) => "( "+ show(x) + " - " + show(y) + " )"+ " - " +  show(z)
        case (z, Sub(x, y)) =>  show(z) +  " - "  + "( "+ show(x) + " - " + show(y) + " )"
        case (Sub(d, f), Sub(x, y)) =>   "( "+ show(d) + " - " + show(f) + " )"+  " - "  + "( "+ show(x) + " - " + show(y) + " )"
        case (any, other) => show(any) + " - " + show(other)
        
      }
      
    }
  }

object ExpressionExample extends App {

  println(Expression.evaluate(Plus(Mul(Num1(3), Num1(4)), Sub(Num1(3), Num1(4)))))
}