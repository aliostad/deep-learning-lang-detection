package typeclasses.homebrew

/**
 * Created by eap on 7/31/14.
 */

trait Show[A] {
  def show(a: A): String
}

object Show {
  implicit def showString = Show[String] { identity }
  implicit def showInt = Show[Int] { _.toString }
  implicit def showDouble = Show[Double] { _.toString }
  implicit def showTuple[A: Show, B: Show] = Show[(A, B)] {
    case (a, b) => s"(${a.show}, ${b.show})"
  }
  implicit def showSeq[A: Show] = Show[Seq[A]] {
    as => as.map(_.show).mkString("Seq(", ", ", ")")
  }
  implicit class ShowOps[A](a: A)(implicit s: Show[A]) {
    def show: String = s.show(a)
  }
  def apply[A](s: A => String) = new Show[A] {
    def show(a: A): String = s(a)
  }
}
