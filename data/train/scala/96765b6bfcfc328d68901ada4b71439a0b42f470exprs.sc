package week4

object exprs {
  def show(e: Expr): String = e match {
    case Number(x) => x.toString
    case Sum(left, right) => show(left) + " + " + show(right)
    case Var(varName) => varName
    case Prod(left: Sum, right: Sum) => "(" + show(left) + ") * (" + show(right) + ")"
    case Prod(left: Sum, right: Expr) => "(" + show(left) + ") * " + show(right)
    case Prod(left: Expr, right: Sum) => show(left) + " * (" + show(right) + ")"
    case Prod(left: Expr, right: Expr) => show(left) + " * " + show(right)
    case _ => show(e)
  }                                               //> show: (e: week4.Expr)String

  show(Number(5))                                 //> res0: String = 5
  show(Sum(Number(5), Number(10)))                //> res1: String = 5 + 10
  show(Sum(Var("x"), Var("y")))                   //> res2: String = x + y
  show(Prod(Var("x"), Var("y")))                  //> res3: String = x * y

  show(Sum(Prod(Number(2), Var("x")), Var("y")))  //> res4: String = 2 * x + y
  show(Prod(Sum(Number(2), Var("x")), Var("y")))  //> res5: String = (2 + x) * y
}