package weekPackages.week4

object exprs {

  def showInParenthesis(e: Expr): String = e match {
    case Sum(_, _) => "(" + show(e) + ")"
    case _ => show(e)
  }                                               //> showInParenthesis: (e: weekPackages.week4.Expr)String

  def show(e: Expr): String = e match {
    case Number(x) => x.toString
    case Sum(l, r) => show(l) + " + " + show(r)
    case Prod(l, r) => showInParenthesis(l) + " * " + showInParenthesis(r)
    case Var(s) => s
  }                                               //> show: (e: weekPackages.week4.Expr)String

  show(Sum(Number(1), Number(44)))                //> res0: String = 1 + 44

  show(Var("x"))                                  //> res1: String = x
  show(Sum(Prod(Number(2), Var("x")), Var("y")))  //> res2: String = 2 * x + y

  show(Prod(Sum(Number(2), Var("x")), Var("y")))  //> res3: String = (2 + x) * y

}