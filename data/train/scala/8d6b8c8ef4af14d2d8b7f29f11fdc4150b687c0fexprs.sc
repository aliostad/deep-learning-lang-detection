package week4

object exprs {
  def show(e: Expr): String = e match {
    case Number(x) => x.toString
    case Sum(l, r) => show(l) + " + " + show(r)
    case Var(x) => x
    case Prod(e1, e2) =>
      val format = (e1, e2) match {
        case (Sum(_, _), _) => "(%s) * %s"
        case (_, Sum(_, _)) => "%s * (%s)"
        case (_, _) => "%s * %s"
      }
      format.format(show(e1), show(e2))
  }                                               //> show: (e: week4.Expr)String

  show(Sum(Number(1), Number(44)))                //> res0: String = 1 + 44
  show(Sum(Prod(Number(2), Var("x")), Var("y")))  //> res1: String = 2 * x + y
  show(Prod(Sum(Number(2), Var("x")), Var("y")))  //> res2: String = (2 + x) * y
}