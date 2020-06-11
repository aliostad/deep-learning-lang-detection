// Simply speaking
// 1. A typleclass is represented by a parameterized trait e.g. Expression[A],
// defining operations on member types
// 2. A type T is a member of typeclass TC[_] if there is a value of type TC[T]
// available in implicit scope
// 3. A context bound [T: TC] in the type parameter list for a class or method
// asserts that T is a member of TC[_] (have implicit converter that could
// convert T to TC[T])

trait Expression[A] {
  def value(expr: A): Int
}

object Expression {
  implicit val intExpression = new Expression[Int] {
    def value(expr: Int): Int = expr
  }

  implicit val stringExpression = new Expression[String] {
    def value(expr: String): Int = expr.toInt
  }

  implicit def plusExpression[A: Expression, B: Expression] = new Expression[Plus[A, B]] {
    def value(expr: Plus[A, B]): Int =
      implicitly[Expression[A]].value(expr.a) + implicitly[Expression[B]].value(expr.b)
  }

  implicit def minusExpression[A: Expression, B: Expression] = new Expression[Minus[A, B]] {
    def value(expr: Minus[A, B]): Int =
      implicitly[Expression[A]].value(expr.a) - implicitly[Expression[B]].value(expr.b)
  }
}

/** Next we add a helper function to help simplify code */

trait Show[A] {
  def show(x: A): String
}

object Show {
  /** creates an instance of [[Show]] using the provided function */
  def show[A](f: A => String): Show[A] = new Show[A] {
    def show(a: A): String = f(a)
  }

  /** Show operations */
  trait Ops[T] {
    def show : String
  }

  /** Implicit convert a Show[T] object to Show.Ops[T] that have a show function */
  implicit def toShowOps[T: Show](target : T) : Show.Ops[T] = new Ops[T] {
    override def show: String = implicitly[Show[T]].show(target)
  }

  implicit val intShow = show[Int](_.toString)
  implicit val stringShow = show[String](x => x)
  implicit def plusShow[A: Show, B: Show] = show[Plus[A, B]](x => s"(${x.a.show} + ${x.b.show})")
  implicit def minusShow[A: Show, B: Show] = show[Minus[A, B]](x => s"(${x.a.show} - ${x.b.show})")
}

case class Plus[A, B](a: A, b: B)
case class Minus[A, B](a: A, b: B)

def evaluate[A: Expression](expr: A): Int = implicitly[Expression[A]].value(expr)

//import Show.toShowOps
def log[A: Show](x: A): String = {
  import Show.toShowOps
  x.show
}
// Or:
// def log[A: Show](x: A): String = implicitly[Show[A]].show(x)

evaluate(1)
evaluate(Plus(3, 2))
evaluate(Minus(3, Plus(2, 1)))
evaluate(Minus("6", Plus(2, 1)))

log(1)
log(Plus(3, 2))
log(Minus(3, Plus(2, 1)))
log(Minus("6", Plus(2, 1)))
// This will not type check because no implicits defined for double => Show
// StringPrinter.print(Minus(3.3, Plus(2, 1)))

// Alternative log functions
def log1[A](x: A)(implicit s: Show[A]) = println(s.show(x))
def log2[A: Show](x: A) = println(implicitly[Show[A]].show(x))
log1(Plus(3, 2))
log2(Plus(3, 2))
