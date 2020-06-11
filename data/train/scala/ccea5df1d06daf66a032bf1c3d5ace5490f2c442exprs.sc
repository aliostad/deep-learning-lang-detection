package week4

object exprs {
  def show(e: Expr): String = e match {
    case Number(x) => x.toString
    case Sum(l, r) => {
      if (l.isInstanceOf[Number])
        "(" + show(l) + " + " + show(r) + ")"
      else
        show(l) + " + " + show(r)
    }
    case Prod(l,r) => show(l) + " * " + show(r)
    case Var(x)    => x.toString
  }                                               //> show: (e: week4.Expr)String
  
  show(Sum(Number(1), Number(12)))                //> res0: String = (1 + 12)

  show(Sum(Prod(Number(2), Var("x")), Var("y")))  //> res1: String = 2 * x + y
  show(Prod(Sum(Number(2), Var("x")), Var("y")))  //> res2: String = (2 + x) * y
}