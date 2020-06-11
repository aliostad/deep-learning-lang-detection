package week4

object exprs {
  def show(e: Expr): String = e match {
    case Number(n) => n.toString
    case Var(v) => v
    case Sum(l, r) => show(l) + " + " + show(r)
    case Prod(e1, e2) => paren(e1) + " * " + paren(e2)
  }                                               //> show: (e: week4.Expr)String
  
  def paren(e: Expr): String = e match {
  	case Sum(_, _) => "(" + show(e) + ")"
  	case _ => show(e)
  }                                               //> paren: (e: week4.Expr)String

  show(Number(1))                                 //> res0: String = 1
  show(Sum(Number(1), Number(3)))                 //> res1: String = 1 + 3
  show(Var("x"))                                  //> res2: String = x
  show(Sum(Number(5), Var("y")))                  //> res3: String = 5 + y
  show(Prod(Number(2), Var("y")))                 //> res4: String = 2 * y
  show(Sum(Prod(Number(2), Var("x")), Var("y")))  //> res5: String = 2 * x + y
  show(Prod(Sum(Number(2), Var("x")), Var("y")))  //> res6: String = (2 + x) * y
  show(Prod(Sum(Number(2), Var("x")), Sum(Number(7), Var("y"))))
                                                  //> res7: String = (2 + x) * (7 + y)
}