package week4

object patternMatching {
  println("Welcome to the Scala worksheet")       //> Welcome to the Scala worksheet
  
  def show(e:Expr): String = e match {
  	case Number(x) => x.toString
  	case Var(x) => x.toString
  	case Sum(l, r) => show(l) + " + " + show(r)
  	case Prod(Sum(l, r), Sum(l2, r2)) => "("show(l) + ") * (" + show() + ")"
  }                                               //> show: (e: week4.Expr)String
  
  show(Sum(Number(1), Number(44)))                //> res0: String = 1 + 44
  show(Sum(Var("x"), Prod(Number(2), Var("y"))))  //> res1: String = x + 2 * y
}