package week04


object exprs {

	def precedence(e: Expr): Int = e match {
		case Number(_) => 0
		case Sum(_,_) => 0
		case Prod(_,_) => 1
		case Var(_) => 0
	}                                         //> precedence: (e: week04.Expr)Int

  def show(e: Expr): String = {
  
  	def internalShow(e:Expr, prec: Int):String = e match {
  		case Number(x) => x.toString
  		case Sum(l, r) => {
  			if (prec > precedence(e)) "("+internalShow(l, precedence(e)) + " + " + internalShow(r,precedence(e))+")"
  			else internalShow(l,precedence(e)) + " + " + internalShow(r,precedence(e))
  		}
  		case Prod(l,r) => internalShow(l,precedence(e)) + " * " + internalShow(r,precedence(e))
  		case Var(name) => name
  	}
  	
  	internalShow(e,0)
  }                                               //> show: (e: week04.Expr)String
  
  show(Sum(Prod(Number(2),Var("x")),Var("y")))    //> res0: String = 2 * x + y
  show(Prod(Sum(Number(2),Sum(Var("x"),Number(8))),Var("y")))
                                                  //> res1: String = (2 + x + 8) * y
}