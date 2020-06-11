package weekPackages.week4.expr

trait Expr /*{
  def show: String = {

    def showInParens(e: Expr): String = e match {
      case Sum(_, _) => "(" + e.show + ")"
      case _ => e.show
    }

    this match {
      case Number(n) => n.toString
      case Sum(l, r) => l.show + " + " + r.show
      case Var(name) => name
      case Prod(l, r) => showInParens(l) + " * " + showInParens(r)
    }
  }
}*/
case class Number(n: Int) extends Expr
case class Sum(e1: Expr, e2: Expr) extends Expr
case class Prod(e1: Expr, e2: Expr) extends Expr
case class Var(s: String) extends Expr
