import week4._

def show(e: Expr): String = e match {
  case Number(x) => x.toString
  case Sum(l, r) => show(l) + " + " + show(r)
  case Var(x) => x
  case Prod(Sum(xl, xr), Sum(yl, yr)) =>
    "( " + show(Sum(xl, xr)) + " ) * ( " + show(Sum(yl, yr)) + " )"
  case Prod(Sum(xl, xr), y) =>
    "( " + show(Sum(xl, xr)) + " ) * " + show(y)
  case Prod(x, Sum(yl, yr)) =>
    show(x) + " * ( " + show(Sum(yl, yr)) + " )"
  case Prod(l, r) => show(l) + " * " + show(r)
}

show(Prod(Sum(Var("x"), Number(44)), Sum(Number(3), Number(4))))
show(Prod(Sum(Number(1), Number(44)), Number(4)))
show(Prod(Number(3), Sum(Number(1), Number(44))))
