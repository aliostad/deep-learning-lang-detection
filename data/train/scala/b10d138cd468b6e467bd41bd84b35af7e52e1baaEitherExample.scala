import scalaz._, Scalaz._

object EitherExample {

  def main(args: Array[String]): Unit = {
    println(load(0))
    println(load(1))
  }


  case class User(id: Int)
  case class Foo()

  case class UserNotFound(id: Int)
  case class FooNotFound(user: User)

  sealed trait LoadError
  case class LoadErrorUser(e: UserNotFound) extends LoadError
  case class LoadErrorFoo(e: FooNotFound) extends LoadError

  def loadUser(id: Int): UserNotFound \/ User = id match {
    case 0 => User(0).right
    case i => UserNotFound(i).left
  }

  def loadFoo(u: User): FooNotFound \/ List[Foo] = u match {
    case User(0) => List(Foo()).right
    case _ => FooNotFound(u).left
  }

  def load(id: Int): LoadError \/ List[Foo] =
    for {
      u <- loadUser(id).leftMap(LoadErrorUser)
      b <- loadFoo(u).leftMap(LoadErrorFoo)
    } yield b
}
