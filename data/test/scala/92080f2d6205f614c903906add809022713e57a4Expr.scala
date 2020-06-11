package week4

trait Expr {
	def show: String = {
	  this match {
	  case Prod(Sum(s1, s2), Sum(s3, s4)) => "(" + Sum(s1, s2).show + ") * (" + Sum(s3, s4).show + ")"
	    case Prod(Sum(s1, s2), p2) => "(" + Sum(s1, s2).show + ") * " + p2.show
	    case Prod(p1, Sum(s1, s2)) => p1.show + " * " + "(" + Sum(s1, s2).show + ")"
	    case Prod(e1, e2) => e1.show + " * " + e2.show
	    case Sum(e1, e2) => e1.show + " + " + e2.show
	    case Number(n) => n.toString()
	    case Var(name) => name
	  }
	}
}

case class Sum(e1: Expr, e2: Expr) extends Expr
case class Prod(e1: Expr, e2: Expr) extends Expr
case class Number(n: Integer) extends Expr
case class Var(name: String) extends Expr
