package ebarrientos.stdutils.show

trait Show[A] {
  def show(a: A): String
}

object Show {
  def apply[A](implicit ev: Show[A]) = ev

  implicit class ShowSyntax[A : Show](a: A) {
    def show = Show[A].show(a)
  }

  implicit object ShowInt extends Show[Int]{
    def show(i: Int) = i.toString
  }

  implicit object ShowString extends Show[String]{
    def show(s: String) = s
  }

  implicit def showList[A](implicit ev: Show[A]) = new Show[List[A]] {
    def show(l: List[A]): String = l match {
      case x::Nil => x.show
      case x::xs => x.show + " :: " + show(xs)
      case Nil => ""
    }
  }

  // ... other default impls
}
