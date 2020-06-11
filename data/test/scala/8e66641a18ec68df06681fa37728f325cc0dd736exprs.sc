package week4

object exprs {
  def show(e: Expr): String = e match {
  	case Number(x) => x.toString
  	case Sum(l, r) => show(l) + " + " + show(r)
  	case Prod(Sum(sl, sr), r) => "(" + show(sl) + " + " + show(sr) + ")" + "*" + show(r)
  	case Prod(l, r) => show(l) + "*" + show(r)
  	case Var(name) => name
  }                                               //> show: (e: week4.Expr)String
  
  show(Sum(Number(1), Number(44)))                //> res0: String = 1 + 44
  show(Sum(Prod(Number(2), Var("x")), Var("y")))  //> res1: String = 2*x + y
  show(Prod(Sum(Number(2), Var("x")), Var("y")))  //> res2: String = (2 + x)*y
}