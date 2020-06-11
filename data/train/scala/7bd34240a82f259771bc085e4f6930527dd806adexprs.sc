package week04


object exprs {
 def show(e: Expr): String = e match {
  case Number(n) => n.toString()
  case Var(v) => v
  case Sum(e1,e2) => show(e1)+"+"+show(e2)
  case Prod(e1,e2) => addPrecedence(e1)+"*"+addPrecedence(e2)
  }                                               //> show: (e: week04.Expr)String
  def addPrecedence(e: Expr): String = e match {
  case Sum(_,_) => "("+show(e)+")"
  case e => show(e)
  }                                               //> addPrecedence: (e: week04.Expr)String

show(Sum(Number(1),Number(2)))                    //> res0: String = 1+2
show(Sum(Prod(Number(2),Var("x")),Var("y")))      //> res1: String = 2*x+y
show(Prod(Sum(Number(2),Var("x")), Var("y")))     //> res2: String = (2+x)*y
}