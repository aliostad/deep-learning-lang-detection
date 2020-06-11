package week4

object exprs {
  trait Expr
  case class Num(n: Int) extends Expr
  case class Sum(e1: Expr, e2: Expr) extends Expr
  case class Prod(e1: Expr, e2: Expr) extends Expr
  case class Var(x: String) extends Expr

  def show(e: Expr): String = e match {
    case Num(x) => x.toString
    case Sum(l, r) => show(l) + " + " + show(r)
    case Var(x) => x
    case Prod(Sum(e1,e2), Sum(e3,e4)) => "(" + show(Sum(e1,e2)) + ") * (" + show(Sum(e3,e4)) + ")"
    case Prod(Sum(e1,e2), r) => "(" + show(Sum(e1,e2)) + ") * " + show(r)
    case Prod(l, Sum(e1,e2)) => show(l) + " * (" + show(Sum(e1,e2)) + ")"
    case Prod(l, r) => show(l) + " * " + show(r)
  }                                               //> show: (e: week4.exprs.Expr)String
  
  val e1 = Sum(Num(2), Var("x"))                  //> e1  : week4.exprs.Sum = Sum(Num(2),Var(x))
  val e2 = Sum(Num(3), Var("y"))                  //> e2  : week4.exprs.Sum = Sum(Num(3),Var(y))
  
  show(Sum(Num(1), Num(44)))                      //> res0: String = 1 + 44
  show(Sum(Prod(Num(2), Var("x")), Var("y")))     //> res1: String = 2 * x + y
  show(Prod(e1, Var("y")))                        //> res2: String = (2 + x) * y
  show(Prod(Var("y"),e1))                         //> res3: String = y * (2 + x)
  show(Prod(e1, e2))                              //> res4: String = (2 + x) * (3 + y)
}
