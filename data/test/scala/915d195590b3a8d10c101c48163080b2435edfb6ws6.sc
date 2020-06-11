trait Expr

case class Num(value: Int) extends Expr

case class Sum(left: Expr, right: Expr) extends Expr

def eval(e: Expr): Int = e match {
  case Num(value) => value
  case Sum(left, right) => eval(left) + eval(right)
}

val one = Num(1)

eval(one)
eval(Sum(one, one))

def show(e: Expr): String = e match {
  case Num(value) => value.toString
  case Sum(left, right) => show(left) + "+" + show(right)
  case Var(name) => name
  case Prod(left, right) => showProdOp(left) + "*" + showProdOp(right)
}

def showProdOp(e: Expr): String = e match {
  case Sum(left, right) => "(" + show(left) + "+" + show(right) + ")"
  case other => show(other)
}

show(one)
show(Sum(one, one))

case class Var(name: String) extends Expr

show(Sum(one, Sum(Var("x"), one)))

case class Prod(left: Expr, right: Expr) extends Expr

show(Sum(Prod(Num(2), Var("x")), Var("y")))
show(Prod(Sum(Num(2), Var("x")), Var("y")))