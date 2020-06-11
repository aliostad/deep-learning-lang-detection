package week4

object exprs {
  println("Welcome to the Scala worksheet")       //> Welcome to the Scala worksheet
  def show(e: Expr): String = e match {
    case Number(x) => x.toString
    case Sum(l, r) => show(l) + " + " + show(r)
    case Var(x) => x
    case Prod(l, r) => {
    	def showSum(e: Expr): String = e match{
    		case Sum(a,b) => "(" + show(Sum(a,b)) + ")"
    		case _ => show(e)
    	}
    	showSum(l)+" * "+showSum(r)
    }
  }                                               //> show: (e: week4.Expr)String
  show(Sum(Number(1),Number(44)))                 //> res0: String = 1 + 44
  show(Prod(Number(2),Number(3)))                 //> res1: String = 2 * 3
  show(Sum(Prod(Number(2),Var("x")),Var("y")))    //> res2: String = 2 * x + y
  show(Prod(Sum(Number(2),Var("x")),Var("y")))    //> res3: String = (2 + x) * y
  
}