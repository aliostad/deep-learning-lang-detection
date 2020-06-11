package week04

object session6 {
  println("Welcome to the Scala worksheet")       //> Welcome to the Scala worksheet
  
  def show(e: Expr): String = e match {
    case Number(n) => n.toString
    case Var(x) => x
    case Sum(e1, e2) => "(" + show(e1) + " + " + show(e2) + ")"
    case Prod(e1, e2) => "(" + show(e1) + " * " + show(e2) + ")"
  }                                               //> show: (e: week04.Expr)String
  
	Sum(Number(1), Number(2)).eval            //> res0: Int = 3
	show(Sum(Number(1), Number(2)))           //> res1: String = (1 + 2)
	show(Sum(Prod(Number(2), Var("x")), Var("y")))
                                                  //> res2: String = ((2 * x) + y)
  show(Prod(Sum(Number(2), Var("x")), Var("y")))  //> res3: String = ((2 + x) * y)
}