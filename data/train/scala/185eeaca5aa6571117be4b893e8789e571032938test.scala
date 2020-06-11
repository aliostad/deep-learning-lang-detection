trait Showable[T] { def show(x: T): String }

class User(val firstName: String, val lastName: String, val age: Int)

object ShowDef {
  implicit object IntShowable extends Showable[Int] {
    def show(x: Int) = x.toString
  }

  implicit object StringShowable extends Showable[String] {
    def show(x: String) = x
  }

  implicit object UserShowable extends Showable[User] {
    def show(u: User) = ShowDef.show(u.firstName) + " " + ShowDef.show(u.lastName) + " " + ShowDef.show(u.age)
  }

  def show[T](x: T)(implicit s: Showable[T]) = s.show(x)
}

object Main extends App {
  import ShowDef._

  val u = new User("Marc", "Simon", 25);

  val res = show(u);
  println(res)
}
