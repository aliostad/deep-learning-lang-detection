package week4


object exprs {
	/*In this case we are creating the pattern matching method outside the class hierarchy
	we also can crea it inside the class hierarchy (Expr.scala of this package)*/
  def show(e: Expr):String = e match {
  	case Number(x) => x.toString
  	case Var(x) => x
  	case Sum(l,r) => show(l) + " + " + show(r)
  	case Prod(l,r) => show(l) + " * " + show(r)
  }                                               //> show: (e: week4.Expr)String
  
  show(Sum(Number(1),Number(44)))                 //> res0: String = 1 + 44
  show(Sum(Prod(Number(2),Var("x")),Var("y")))    //> res1: String = 2 * x + y
  show(Prod(Sum(Number(2),Var("x")),Var("y")))    //> res2: String = 2 + x * y
  
}