package week4


object Expression {
  def show(e:Expr):String = e match {
  	case Number(x) => x.toString
  	case Sum(l,r) => show(l) + " + " + show(r)
  	case Prod(l,Sum(x,y)) => show(l) + " * " + " ( " + show(Sum(x,y)) + " ) "
  	case Prod(Sum(x,y),r) => " ( " + show(Sum(x,y)) + " ) " + " + " + show(r)
  	case Prod(l,r) => show(l) + " * " + show(r)
  }                                               //> show: (e: week4.Expr)String
  
  show(Sum(Number(1),Number(44)))                 //> res0: String = 1 + 44
  show(Prod(Number(1),Number(2)))                 //> res1: String = 1 * 2
  show(Sum(Number(3),Prod(Number(1),Number(2))))  //> res2: String = 3 + 1 * 2
  show(Prod(Number(3),Sum(Number(1),Number(2))))  //> res3: String = "3 *  ( 1 + 2 ) "
  

}