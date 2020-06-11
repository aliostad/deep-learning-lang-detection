trait Expr
case class Number(n: Int) extends Expr
case class Sum(e1: Expr, e2: Expr) extends Expr
case class Var(name: String) extends Expr
case class Prod(e1: Expr, e2: Expr) extends Expr

object exprs {
  def show(e: Expr): String = e match {
    case Number(x) => x.toString
    case Sum(l, r) => show(l) + " + " + show(r)
    case Var(name) => name

    // make the operator
    case Prod(Sum(l1, r1), Sum(l2, r2)) => "(" + show(Sum(l1, r1)) + ") * (" + show(Sum(l2, r2)) + ")"
    case Prod(Sum(l, r), e) => "(" + show(Sum(l, r)) + ") * " + show(e)
    case Prod(e, Sum(l, r)) => show(e) + " * (" + show(Sum(l, r)) + ")"
    case Prod(e1, e2) => show(e1) + " * " + show(e1)
  }
}

exprs.show(Sum(Number(1), Number(2)))
exprs.show(Sum(Prod(Number(2),Var("x")),Var("y")))
exprs.show(Prod(Sum(Number(2),Var("x")),Var("y")))
