package week4

object exprs {
  def show(e: Expr): String = e match {
    case Number(x) => x.toString
    case Sum(l, r) => show(l) + " + " + show(r)
    case Prod(l, r) => showHelper(l) + " * " + showHelper(r)
    case Var(x) => x
  }                                               //> show: (e: week4.Expr)String

  def showHelper(e: Expr): String = e match {
    case Sum(l, r) => "(" + show(e) + ")"
    case Number(x) => show(e)
    case Prod(l, r) => show(e)
    case Var(x) => show(e)
  }                                               //> showHelper: (e: week4.Expr)String

  show(Sum(Number(1), Number(44)))                //> res0: String = 1 + 44

  show(Sum(Prod(Number(2), Var("x")), Var("y")))  //> res1: String = 2 * x + y
  show(Prod(Sum(Number(2), Var("x")), Var("y")))  //> res2: String = (2 + x) * y

}